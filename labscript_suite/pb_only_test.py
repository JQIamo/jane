#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 24 18:41:40 2018

@author: ananya
"""

#####################################################################
#                                                                   #
# /example.py                                                       #
#                                                                   #
# Copyright 2013, Monash University                                 #
#                                                                   #
# This file is part of the program labscript, in the labscript      #
# suite (see http://labscriptsuite.org), and is licensed under the  #
# Simplified BSD License. See the license.txt file in the root of   #
# the project for the full license.                                 #
#                                                                   #
#####################################################################

import __init__ # only have to do this because we're inside the labscript directory
from labscript import *
from labscript_devices.Jane import Jane
#from labscript_devices.NI_PCIe_6363 import NI_PCIe_6363
#from labscript_devices.NovaTechDDS9M import NovaTechDDS9M
#from labscript_devices.Camera import Camera
#from labscript_devices.PineBlaster import PineBlaster
#from labscript_devices.NI_PCI_6733 import NI_PCI_6733
from labscript_utils.unitconversions import *

Jane(name='jane_0', board_number=0, time_based_stop_workaround = True, time_based_stop_workaround_extra_time=0.5)
#ClockLine(name='jane_0_clockline_fast', pseudoclock=jane_0.pseudoclock, connection='flag 0')
#ClockLine(name='jane_0_clockline_slow', pseudoclock=jane_0.pseudoclock, connection='flag 1')

# same as above, but we are changing some parameters used in the conversion and specifying a prefix to be used with units. You can now program in mA, uA, mGauss, uGauss
DigitalOut( 'ch_1', jane_0.direct_outputs, 'flag 0')
DigitalOut( 'ch_2', jane_0.direct_outputs, 'flag 1')
DigitalOut( 'ch_3', jane_0.direct_outputs, 'flag 2')
DigitalOut( 'ch_4', jane_0.direct_outputs, 'flag 3')
DigitalOut( 'ch_5', jane_0.direct_outputs, 'flag 4')
DigitalOut( 'ch_6', jane_0.direct_outputs, 'flag 5')
DigitalOut( 'ch_7', jane_0.direct_outputs, 'flag 6')
DigitalOut( 'ch_8', jane_0.direct_outputs, 'flag 7')
DigitalOut( 'ch_9', jane_0.direct_outputs, 'flag 8')
DigitalOut( 'ch_10', jane_0.direct_outputs, 'flag 9')
DigitalOut( 'ch_11', jane_0.direct_outputs, 'flag 10')
DigitalOut( 'ch_12', jane_0.direct_outputs, 'flag 11')
DigitalOut( 'ch_13', jane_0.direct_outputs, 'flag 12')
DigitalOut( 'ch_14', jane_0.direct_outputs, 'flag 13')
DigitalOut( 'ch_15', jane_0.direct_outputs, 'flag 14')
DigitalOut( 'ch_16', jane_0.direct_outputs, 'flag 15')
DigitalOut( 'ch_17', jane_0.direct_outputs, 'flag 16')
DigitalOut( 'ch_18', jane_0.direct_outputs, 'flag 17')
DigitalOut( 'ch_19', jane_0.direct_outputs, 'flag 18')
DigitalOut( 'ch_20', jane_0.direct_outputs, 'flag 19')
DigitalOut( 'ch_21', jane_0.direct_outputs, 'flag 20')
DigitalOut( 'ch_22', jane_0.direct_outputs, 'flag 21')
DigitalOut( 'ch_23', jane_0.direct_outputs, 'flag 22')
DigitalOut( 'ch_24', jane_0.direct_outputs, 'flag 23')
DigitalOut( 'ch_25', jane_0.direct_outputs, 'flag 24')
DigitalOut( 'ch_26', jane_0.direct_outputs, 'flag 25')
DigitalOut( 'ch_27', jane_0.direct_outputs, 'flag 26')
DigitalOut( 'ch_28', jane_0.direct_outputs, 'flag 27')
DigitalOut( 'ch_29', jane_0.direct_outputs, 'flag 28')
DigitalOut( 'ch_30', jane_0.direct_outputs, 'flag 29')
DigitalOut( 'ch_31', jane_0.direct_outputs, 'flag 30')
DigitalOut( 'ch_32', jane_0.direct_outputs, 'flag 31')
DigitalOut( 'ch_33', jane_0.direct_outputs, 'flag 32')
DigitalOut( 'ch_34', jane_0.direct_outputs, 'flag 33')
DigitalOut( 'ch_35', jane_0.direct_outputs, 'flag 34')
DigitalOut( 'ch_36', jane_0.direct_outputs, 'flag 35')
DigitalOut( 'ch_37', jane_0.direct_outputs, 'flag 36')
DigitalOut( 'ch_38', jane_0.direct_outputs, 'flag 37')
DigitalOut( 'ch_39', jane_0.direct_outputs, 'flag 38')
DigitalOut( 'ch_40', jane_0.direct_outputs, 'flag 39')
DigitalOut( 'ch_41', jane_0.direct_outputs, 'flag 40')
DigitalOut( 'ch_42', jane_0.direct_outputs, 'flag 41')
DigitalOut( 'ch_43', jane_0.direct_outputs, 'flag 42')
DigitalOut( 'ch_44', jane_0.direct_outputs, 'flag 43')
DigitalOut( 'ch_45', jane_0.direct_outputs, 'flag 44')
DigitalOut( 'ch_46', jane_0.direct_outputs, 'flag 45')
DigitalOut( 'ch_47', jane_0.direct_outputs, 'flag 46')
DigitalOut( 'ch_48', jane_0.direct_outputs, 'flag 47')
DigitalOut( 'ch_49', jane_0.direct_outputs, 'flag 48')
DigitalOut( 'ch_50', jane_0.direct_outputs, 'flag 49')
DigitalOut( 'ch_51', jane_0.direct_outputs, 'flag 50')
DigitalOut( 'ch_52', jane_0.direct_outputs, 'flag 51')
DigitalOut( 'ch_53', jane_0.direct_outputs, 'flag 52')
DigitalOut( 'ch_54', jane_0.direct_outputs, 'flag 53')
DigitalOut( 'ch_55', jane_0.direct_outputs, 'flag 54')
DigitalOut( 'ch_56', jane_0.direct_outputs, 'flag 55')
DigitalOut( 'ch_57', jane_0.direct_outputs, 'flag 56')
DigitalOut( 'ch_58', jane_0.direct_outputs, 'flag 57')
DigitalOut( 'ch_59', jane_0.direct_outputs, 'flag 58')
DigitalOut( 'ch_60', jane_0.direct_outputs, 'flag 59')
DigitalOut( 'ch_61', jane_0.direct_outputs, 'flag 60')
DigitalOut( 'ch_62', jane_0.direct_outputs, 'flag 61')
DigitalOut( 'ch_63', jane_0.direct_outputs, 'flag 62')
DigitalOut( 'ch_64', jane_0.direct_outputs, 'flag 63')


# A variable to define the acquisition rate used for the analog outputs below.
# This is just here to show you that you can use variables instead of typing in numbers!
# Furthermore, these variables could be defined within runmanager (rather than in the code like this one is)
# for easy manipulation via a graphical interface.
rate = 1e4

# The time (in seconds) we wish the pineblaster pseudoclock to start after
# the master pseudoclock (the pulseblaster)
#pineblaster_0.set_initial_trigger_time(1)

# Start the experiment!
start()

# A variable to keep track of time
t = 0

# Let's increment our time variable!
t += 2e-7

# Open the shutter, enable the DDS, ramp an analog output!
ch_1.go_high(t)

t += 0.003

ch_1.go_high(t)
ch_2.go_high(t)
ch_4.go_high(t)
ch_5.go_high(t)
ch_6.go_high(t)
ch_7.go_high(t)
ch_8.go_high(t)

t += 0.003

ch_1.go_low(t)
ch_2.go_low(t)
ch_4.go_low(t)
ch_5.go_low(t)
ch_6.go_low(t)
ch_7.go_low(t)
ch_8.go_low(t)

t+=1


# Wait for an external trigger on the master pseudoclock
# Waits must be names
# The timeout defaults to 5s, unless otherwise specified.
# The timeout specifies how long to wait without seeing the external
# trigger before continuing the experiment
#t += wait('my_first_wait', t=t, timeout=2)
# Waits take very little time as far as labscript is concerned. They only add on the retirggering time needed to start devices up and get them all in sync again.
# After a wait, labscript time (the t variable here) and execution time (when the hardware instructions are executed on the hardware) will not be the same
# as the wait instruction may take anywhere from 0 to "timeout" seconds,
# and this number is only determined during execution time.


# Stop at t=15 seconds, note that because of the wait timeout, this might
# be as late as 17s (Plus a little bit of retriggering time) in execution
# time
stop(t)
