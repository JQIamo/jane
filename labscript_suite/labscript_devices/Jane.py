#####################################################################
#                                                                   #
# /jane.py                                                          #
#                                                                   #
# Copyright 2013, Monash University                                 #
#                                                                   #
# This file is part of labscript_devices, in the labscript suite    #
# (see http://labscriptsuite.org), and is licensed under the        #
# Simplified BSD License. See the license.txt file in the root of   #
# the project for the full license.                                 #
#                                                                   #
#####################################################################
from labscript_devices import BLACS_tab, runviewer_parser
from labscript_devices.PulseBlaster_No_DDS import (
    PulseBlaster_No_DDS,
    Pulseblaster_No_DDS_Tab,
    PulseblasterNoDDSWorker,
    PulseBlaster_No_DDS_Parser
)
from labscript.labscript import PseudoclockDevice, config
import numpy as np

from blacs.tab_base_classes import Worker


class Jane(PulseBlaster_No_DDS):
    description = 'Jane'
    clock_limit = 50e6 # This needs to be checked against the following issues:
                        #  1) The actual minimum instruction lenght is still 2 cycles in most cases
                        #  2) A clock must have a high time and low time
                        # This might bring the max clock frequency down to 25MHz
    clock_resolution = 11e-9 #s (20 was the default)
    n_flags = 64
    core_clock_freq = 100.0 #MHz
    def __init__(self,*args,**kwargs):
        super(Jane, self).__init__(*args,**kwargs) #It was PulseBlaster_No_DDS
        self.programming_scheme = 'pb_stop_programming/STOP'
        self.max_instructions = 8192000
        self.min_ticks_in_frame = 65536//2 # 4 32-bit words for each instruction
                                        # Total size of a frame is 16k trerefore
                                        # total number of ticks is 4*16k = 64k
        self.dma_clock = 100 #MHz
        self.safety_margin = 1.05 * self.core_clock_freq/self.dma_clock       # More than 1, depends on ratio between clock
                                                                              # rate of state machine and the DMA clock
        self.framelength = 16384//2        #2^14 = 16384
        #Hack from desperation:
        # self.description = 'Jane'
        # self.clock_limit = 100e6 # can probably go faster (8.3e6 is the default)
        self._direct_output_device.clock_limit = self.clock_limit
        self._direct_output_clock_line._clock_limit = self.clock_limit
        # self.clock_resolution = 11e-9 #s (20 was the default)
        # self.n_flags = 64
        # self.core_clock_freq = 100.0 #MHz



    def write_pb_inst_to_h5(self, pb_inst, hdf5_file):
        # OK now we squeeze the instructions into a numpy array ready for writing to hdf5:
        pb_dtype= [('flags',np.uint64), ('inst',np.int32), ('inst_data',np.int32), ('length',np.float64)]
        pb_inst_table = np.empty(len(pb_inst),dtype = pb_dtype)
        for i,inst in enumerate(pb_inst):
            flagint = int(inst['flags'][::-1],2)
            instructionint = self.pb_instructions[inst['instruction']]
            dataint = inst['data']
            delaydouble = inst['delay']
            pb_inst_table[i] = (flagint, instructionint, dataint, delaydouble)
        print("pb_inst_table size={}".format(len(pb_inst_table)))

        # Okay now write it to the file:
        group = hdf5_file['/devices/'+self.name]
        group.create_dataset('PULSE_PROGRAM', compression=config.compression,data = pb_inst_table)
        self.set_property('stop_time', self.stop_time, location='device_properties')

    def generate_code(self, hdf5_file):
        # Generate the hardware instructions
        self.init_device_group(hdf5_file)
        PseudoclockDevice.generate_code(self, hdf5_file)
        dig_outputs, ignore = self.get_direct_outputs()
        #print("lock {}: timeout extended".format(hdf5_file.zlock))
        #hdf5_file.zlock.client.set_default_timeout(300)
        print("Start generate code")
        pb_inst = self.convert_to_pb_inst(dig_outputs)
        print("pb_inst size = {}".format(len(pb_inst)))
        print("End generate code")
        self.write_pb_inst_to_h5(pb_inst, hdf5_file)

    def convert_to_pb_inst(self, dig_outputs):
            pb_inst = []


            # index to keep track of where in output.raw_output the
            # Jane flags are coming from
            # starts at -1 because the internal flag should always tick on the first instruction and be
            # incremented (to 0) before it is used to index any arrays
            i = -1
            # index to record what line number of the Jane hardware
            # instructions we're up to:
            j = 0

            #Index to record number of ticks within the current frame
            ticks = 0
            frame_position = 0
            current_frame = 0


            # We've delegated the initial two instructions off to BLACS, which
            # can ensure continuity with the state of the front panel. Thus
            # these two instructions don't actually do anything:
            flags = [0]*self.n_flags

            pb_inst.append({'flags': ''.join([str(flag) for flag in flags]), 'instruction': 'STOP',
                            'data': 0, 'delay': 10.0/self.clock_limit*1e9})
            pb_inst.append({'flags': ''.join([str(flag) for flag in flags]), 'instruction': 'STOP',
                            'data': 0, 'delay': 10.0/self.clock_limit*1e9})
            ticks += 20.0/self.clock_limit*1e9
            j += 2

            flagstring = '0'*self.n_flags # So that this variable is still defined if the for loop has no iterations
            for k, instruction in enumerate(self.pseudoclock.clock):

                if (j%self.framelength<frame_position):
                    current_frame+=1
                    if ( ticks/1e3*self.core_clock_freq < self.min_ticks_in_frame * self.safety_margin):
                        raise Exception("The events are happening too fast")
                    ticks = 0
                frame_position = j%self.framelength

                if instruction == 'WAIT':
                    # This is a wait instruction. Repeat the last instruction but with a 100ns delay and a WAIT op code:
                    wait_instruction = pb_inst[-1].copy()
                    wait_instruction['delay'] = 100
                    wait_instruction['instruction'] = 'WAIT'
                    wait_instruction['data'] = 0
                    pb_inst.append(wait_instruction)
                    j += 1
                    ticks += 100
                    continue

                flags = [0]*self.n_flags


                # This flag indicates whether we need a full clock tick, or are just updating an internal output
                only_internal = True
                # find out which clock flags are ticking during this instruction
                for clock_line in instruction['enabled_clocks']:
                    if clock_line == self._direct_output_clock_line:
                        # advance i (the index keeping track of internal clockline output)
                        i += 1
                    else:
                        flag_index = int(clock_line.connection.split()[1])
                        flags[flag_index] = 1
                        # We are not just using the internal clock line
                        only_internal = False

                for output in dig_outputs:
                    flagindex = int(output.connection.split()[1])
                    flags[flagindex] = int(output.raw_output[i])

                flagstring = ''.join([str(flag) for flag in flags])

                if instruction['reps'] > 1048576:
                    raise LabscriptError('Jane cannot support more than 1048576 loop iterations. ' +
                                          str(instruction['reps']) +' were requested at t = ' + str(instruction['start']) + '. '+
                                         'This can be fixed easily enough by using nested loops. If it is needed, ' +
                                         'please file a feature request at' +
                                         'http://redmine.physics.monash.edu.au/projects/labscript.')

                if not only_internal:
                    if self.pulse_width == 'symmetric':
                        high_time = instruction['step']/2
                    else:
                        high_time = self.pulse_width
                    # High time cannot be longer than self.long_delay (~57 seconds for a
                    # 75MHz core clock freq). If it is, clip it to self.long_delay. In this
                    # case we are not honouring the requested symmetric or fixed pulse
                    # width. To do so would be possible, but would consume more Jane
                    # instructions, so we err on the side of fewer instructions:
                    high_time = min(high_time, self.long_delay)

                    # Low time is whatever is left:
                    low_time = instruction['step'] - high_time

                    # Do we need to insert a LONG_DELAY instruction to create a delay this
                    # long?
                    n_long_delays, remaining_low_time =  divmod(low_time, self.long_delay)

                    repetitions = instruction['reps']
                    if (frame_position == (self.framelength-1) and n_long_delays==0) or (frame_position == (self.framelength-2) and n_long_delays):
                        if (instruction['reps']==1):
                            #Case where we have single repetition loop starting at end of bank
                            #We just erode away some time from the 1st instruction (split into two instructions)
                            #End loop instruction will refer back to second of two instructions created
                            #Similar fix for long delay
                            erosion = 2 * 1e-6 / self.core_clock_freq #time in seconds
                            high_time = high_time -  erosion
                            pb_inst.append({'flags': flagstring, 'instruction': 'CONTINUE',
                                    'data': 0, 'delay': erosion*1e9})
                            j+=1
                            if n_long_delays:
                                high_time = high_time - erosion
                                pb_inst.append({'flags': flagstring, 'instruction': 'CONTINUE',
                                        'data': 0, 'delay': erosion*1e9})
                                j+=1
                        else:
                            #All other loops: we subtract 1 from number of repetitions
                            #Two CONTINUE instructions added before the loop
                            #Loop and end loop are now in the same bank
                            #Made flags_copy to differentiate flags for two added instructions
                            flags_copy = flags
                            for clock_line in instruction['enabled_clocks']:
                                if clock_line != self._direct_output_clock_line:
                                   flag_index = int(clock_line.connection.split()[1])
                                   flags_copy[flag_index] = 0

                            flagstring_copy = ''.join([str(flag) for flag in flags_copy])
                            repetitions = repetitions - 1
                            pb_inst.append({'flags': flagstring, 'instruction': 'CONTINUE',
                                    'data': 0, 'delay': high_time})
                            pb_inst.append({'flags': flagstring_copy, 'instruction': 'CONTINUE',
                                    'data': 0, 'delay': low_time})

                            j+=2





                    # If the remainder is too short to be output, add self.long_delay to it.
                    # self.long_delay was constructed such that adding self.min_delay to it
                    # is still not too long for a single instruction:
                    if n_long_delays and remaining_low_time < self.min_delay:
                        n_long_delays -= 1
                        remaining_low_time += self.long_delay

                    # The start loop instruction, Clock edges are high:
                    pb_inst.append({'flags': flagstring, 'instruction': 'LOOP',
                                    'data': repetitions, 'delay': high_time*1e9})

                    for clock_line in instruction['enabled_clocks']:
                        if clock_line != self._direct_output_clock_line:
                            flag_index = int(clock_line.connection.split()[1])
                            flags[flag_index] = 0

                    flagstring = ''.join([str(flag) for flag in flags])

                    # The long delay instruction, if any. Clock edges are low:
                    if n_long_delays:
                        pb_inst.append({'flags': flagstring, 'instruction': 'LONG_DELAY',
                                    'data': int(n_long_delays), 'delay': self.long_delay*1e9})

                    # Remaining low time. Clock edges are low:
                    pb_inst.append({'flags': flagstring, 'instruction': 'END_LOOP',
                                    'data': j%(2*self.framelength), 'delay': remaining_low_time*1e9})

                    # Two instructions were used in the case of there being no LONG_DELAY,
                    # otherwise three. This increment is done here so that the j referred
                    # to in the previous line still refers to the LOOP instruction.
                    j += 3 if n_long_delays else 2
                    if n_long_delays:
                        ticks += (remaining_low_time*1e9+high_time*1e9 + self.long_delay*1e9 * int(n_long_delays) ) * instruction['reps']
                    else:
                        ticks += (remaining_low_time*1e9+high_time*1e9) * instruction['reps']
                else:
                    # We only need to update a direct output, so no need to tick the clocks.

                    # Do we need to insert a LONG_DELAY instruction to create a delay this
                    # long?
                    n_long_delays, remaining_delay =  divmod(instruction['step'], self.long_delay)
                    # If the remainder is too short to be output, add self.long_delay to it.
                    # self.long_delay was constructed such that adding self.min_delay to it
                    # is still not too long for a single instruction:
                    if n_long_delays and remaining_delay < self.min_delay:
                        n_long_delays -= 1
                        remaining_delay += self.long_delay

                    if n_long_delays:
                        pb_inst.append({'flags': flagstring, 'instruction': 'LONG_DELAY',
                                    'data': int(n_long_delays), 'delay': self.long_delay*1e9})

                    pb_inst.append({'flags': flagstring, 'instruction': 'CONTINUE',
                                    'data': 0, 'delay': remaining_delay*1e9})

                    j += 2 if n_long_delays else 1
                    if n_long_delays:
                        ticks += (self.long_delay*1e9 * int(n_long_delays) + remaining_delay*1e9)
                    else:
                        ticks += remaining_delay*1e9


            if self.programming_scheme == 'pb_start/BRANCH':
                # This is how we stop the pulse program. We branch from the last
                # instruction to the zeroth, which BLACS has programmed in with
                # the same values and a WAIT instruction. Jane then
                # waits on instuction zero, which is a state ready for either
                # further static updates or buffered mode.
                pb_inst.append({'flags': flagstring, 'instruction': 'BRANCH',
                                'data': 0, 'delay': 10.0/self.clock_limit*1e9})
            elif self.programming_scheme == 'pb_stop_programming/STOP':
                # An ordinary stop instruction. This has the downside that the PulseBlaster might
                # (on some models) reset its output to zero momentarily until BLACS calls program_manual, which
                # it will for this programming scheme. However it is necessary when the PulseBlaster has
                # repeated triggers coming to it, such as a 50Hz/60Hz line trigger. We can't have it sit
                # on a WAIT instruction as above, or it will trigger and run repeatedly when that's not what
                # we wanted.
                pb_inst.append({'flags': flagstring, 'instruction': 'STOP',
                                'data': 0, 'delay': 10.0/self.clock_limit*1e9})
            else:
                raise AssertionError('Invalid programming scheme %s'%str(self.programming_scheme))

            if len(pb_inst) > self.max_instructions:
                raise LabscriptError("Jane's memory cannot store more than {:d} instuctions, but the PulseProgram contains {:d} instructions.".format(self.max_instructions, len(pb_inst)))
            return pb_inst



@BLACS_tab
class JaneTab(Pulseblaster_No_DDS_Tab):
    # Capabilities
    num_DO = 64
    def __init__(self,*args,**kwargs):
        if not hasattr(self,'device_worker_class'):
            self.device_worker_class = JaneWorker
        Pulseblaster_No_DDS_Tab.__init__(self,*args,**kwargs )



class JaneWorker(PulseblasterNoDDSWorker):
    core_clock_freq = 100.0
    uberglobals =  globals()
    def init(self,uberglobals=uberglobals):
        self.programming_scheme = 'pb_stop_programming/STOP'
        exec('global pb_read_status; from janeapi import *',uberglobals)
        global h5py; import labscript_utils.h5_lock, h5py
        global zprocess; import zprocess

        self.pb_start = pb_start
        self.pb_stop = pb_stop
        self.pb_reset = pb_reset
        self.pb_close = pb_close
        self.pb_read_status = pb_read_status
        self.smart_cache = {'pulse_program':None,'ready_to_go':False,
                            'initial_values':None}
        # An event for checking when all waits (if any) have completed, so that
        # we can tell the difference between a wait and the end of an experiment.
        # The wait monitor device is expected to post such events, which we'll wait on:
        self.all_waits_finished = zprocess.Event('all_waits_finished')
        self.waits_pending = False

        pb_select_board(self.board_number)
        pb_init()
        pb_core_clock(self.core_clock_freq)

        # This is only set to True on a per-shot basis, so set it to False
        # for manual mode. Set associated attributes to None:
        self.time_based_stop_workaround = False
        self.time_based_shot_duration = None
        self.time_based_shot_end_time = None

    def check_status(self):
        if self.waits_pending:
            try:
                self.all_waits_finished.wait(self.h5file, timeout=0)
                self.waits_pending = False
            except zprocess.TimeoutError:
                pass
        if self.time_based_shot_end_time is not None:
            import time
            time_based_shot_over = time.time() > self.time_based_shot_end_time
        else:
            time_based_shot_over = None
        return pb_read_status(), self.waits_pending, time_based_shot_over

    # @define_state(MODE_MANUAL|MODE_BUFFERED|MODE_TRANSITION_TO_BUFFERED|MODE_TRANSITION_TO_MANUAL,True)
    def status_monitor(self,notify_queue=None):
        # When called with a queue, this function writes to the queue
        # when Jane is waiting. This indicates the end of
        # an experimental run.
        self.status, waits_pending, time_based_shot_over = yield(self.queue_work(self._primary_worker,'check_status'))

        if self.programming_scheme == 'pb_start/BRANCH':
            done_condition = self.status['waiting']
        elif self.programming_scheme == 'pb_stop_programming/STOP':
            done_condition = self.status['stopped']

        if time_based_shot_over is not None:
            done_condition = time_based_shot_over

        if notify_queue is not None and done_condition and not waits_pending:
            # Experiment is over. Tell the queue manager about it, then
            # set the status checking timeout back to every 2 seconds
            # with no queue.
            notify_queue.put('done')
            self.statemachine_timeout_remove(self.status_monitor)
            self.statemachine_timeout_add(2000,self.status_monitor)
            if self.programming_scheme == 'pb_stop_programming/STOP':
                # Not clear that on all models the outputs will be correct after being
                # stopped this way, so we do program_manual with current values to be sure:
                self.program_device()
        # Update widgets with new status
        for state in self.status_states:
            if self.status[state]:
                icon = QtGui.QIcon(':/qtutils/fugue/tick')
            else:
                icon = QtGui.QIcon(':/qtutils/fugue/cross')

            pixmap = icon.pixmap(QtCore.QSize(16, 16))
            self.status_widgets[state].setPixmap(pixmap)

    def program_manual(self,values):
            # Program the DDS registers:

            # create flags string
            # NOTE: The spinapi can take a string or integer for flags.
                    # If it is a string:
                    #     flag: 0          12
                    #          '101100011111'
                    #
                    # If it is a binary number:
                    #     flag:12          0
                    #         0b111110001101
                    #
                    # Be warned!
            flags = ''
            for i in range(self.num_DO):
                if values['flag %d'%i]:
                    flags += '1'
                else:
                    flags += '0'

            if self.programming_scheme == 'pb_stop_programming/STOP':
                # Need to ensure device is stopped before programming - or we won't know what line it's on.
                pb_stop()


            # Write the first two lines of the pulse program:
            pb_start_programming(PULSE_PROGRAM)
            # Line zero is a wait:
            pb_inst_pbonly(flags, CONTINUE, 0, 100)
            # Line one is a brach to line 0:
            pb_inst_pbonly(flags, STOP, 0, 100)
            pb_stop_programming()

            # Now we're waiting on line zero, so when we start() we'll go to
            # line one, then brach back to zero, completing the static update:
            pb_start()

            # The pulse program now has a branch in line one, and so can't proceed to the pulse program
            # without a reprogramming of the first two lines:
            self.smart_cache['ready_to_go'] = False

            # TODO: return coerced/quantised values
            return {}

    def transition_to_buffered(self,device_name,h5file,initial_values,fresh):
        self.h5file = h5file
        while pb_read_status()['stopped']==0:
            pass

        if self.programming_scheme == 'pb_stop_programming/STOP':
            # Need to ensure device is stopped before programming - or we wont know what line it's on.
            pb_stop()
        with h5py.File(h5file,'r') as hdf5_file:
            group = hdf5_file['devices/%s'%device_name]

            # Is this shot using the fixed-duration workaround instead of checking Jane's status?
            self.time_based_stop_workaround = group.attrs.get('time_based_stop_workaround', False)
            if self.time_based_stop_workaround:
                self.time_based_shot_duration = (group.attrs['stop_time']
                                                 + hdf5_file['waits'][:]['timeout'].sum()
                                                 + group.attrs['time_based_stop_workaround_extra_time'])

            # Now for the pulse program:
            pulse_program = group['PULSE_PROGRAM'][2:]
            print(pulse_program)

            #Let's get the final state of Jane. z's are the args we don't need:
            flags,z,z,z = pulse_program[-1]

            # Always call start_programming regardless of whether we are going to do any
            # programming or not. This is so that is the programming_scheme is 'pb_stop_programming/STOP'
            # we are ready to be triggered by a call to pb_stop_programming() even if no programming
            # occurred due to smart programming:
            pb_start_programming(PULSE_PROGRAM)

            # Begin of modified section
            initial_flags = ''
            for i in range(self.num_DO):
                if initial_values['flag %d'%i]:
                    initial_flags += '1'
                else:
                    initial_flags += '0'
            pb_inst_pbonly(initial_flags,CONTINUE,0,100)
            pb_inst_pbonly(initial_flags,CONTINUE,0,100)

            for args in pulse_program:
                pb_inst_pbonly(*args)
            # pb_stop_programming()

            # End of modified section

            if fresh or (self.smart_cache['initial_values'] != initial_values) or \
                (len(self.smart_cache['pulse_program']) != len(pulse_program)) or \
                (self.smart_cache['pulse_program'] != pulse_program).any() or \
                not self.smart_cache['ready_to_go']:

                self.smart_cache['ready_to_go'] = True
                self.smart_cache['initial_values'] = initial_values

                # create initial flags string
                # NOTE: The spinapi can take a string or integer for flags.
                # If it is a string:
                #     flag: 0          12
                #          '101100011111'
                #
                # If it is a binary number:
                #     flag:12          0
                #         0b111110001101
                #
                # Be warned!
                initial_flags = ''
                for i in range(self.num_DO):
                    if initial_values['flag %d'%i]:
                        initial_flags += '1'
                    else:
                        initial_flags += '0'

                if self.programming_scheme == 'pb_start/BRANCH':
                    # Line zero is a wait on the final state of the program in 'pb_start/BRANCH' mode
                    #pb_inst_pbonly(flags,WAIT,0,100)
                    pass
                else:
                    # Line zero otherwise just contains the initial flags
                    #pb_inst_pbonly(initial_flags,CONTINUE,0,100)
                    pass

                # Line one is a continue with the current front panel values:
                # pb_inst_pbonly(initial_flags, CONTINUE, 0, 100)

                # Now the rest of the program:
                if fresh or len(self.smart_cache['pulse_program']) != len(pulse_program) or \
                (self.smart_cache['pulse_program'] != pulse_program).any():
                    self.smart_cache['pulse_program'] = pulse_program
                    #for args in pulse_program:
                    #    pb_inst_pbonly(*args)

            if self.programming_scheme == 'pb_start/BRANCH':
                # We will be triggered by pb_start() if we are are the master pseudoclock or a single hardware trigger
                # from the master if we are not:
                pass
                #pb_stop_programming()

            elif self.programming_scheme == 'pb_stop_programming/STOP':
                # Don't call pb_stop_programming(). We don't want Jane to respond to hardware
                # triggers (such as 50/60Hz line triggers) until we are ready to run.
                # Our start_method will call pb_stop_programming() when we are ready
                pass
            else:
                raise ValueError('invalid programming_scheme %s'%str(self.programming_scheme))

            # Are there waits in use in this experiment? The monitor waiting for the end of
            # the experiment will need to know:
            self.waits_pending =  bool(len(hdf5_file['waits']))

            # Now we build a dictionary of the final state to send back to the GUI:
            return_values = {}
            # Since we are converting from an integer to a binary string, we need to reverse the string! (see notes above when we create flags variables)
            return_flags = str(bin(flags)[2:]).rjust(self.num_DO,'0')[::-1]
            for i in range(self.num_DO):
                return_values['flag %d'%i] = return_flags[i]

            return return_values

    def start_run(self):
        print("start_run()")
        if self.programming_scheme == 'pb_start/BRANCH':
            pb_stop_programming() #Added by JQI
            pb_start()
        elif self.programming_scheme == 'pb_stop_programming/STOP':
            pb_stop_programming()
            pb_start()
        else:
            raise ValueError('invalid programming_scheme: %s'%str(self.programming_scheme))
        if self.time_based_stop_workaround:
            import time
            self.time_based_shot_end_time = time.time() + self.time_based_shot_duration


@runviewer_parser
class JaneParser(PulseBlaster_No_DDS_Parser):
    num_dds = 0
    num_flags = 64
