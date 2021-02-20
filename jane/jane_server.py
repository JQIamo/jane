from pynq import Overlay, PL
from pynq.mmio import MMIO
from pynq.gpio import GPIO
import numpy as np
import sys
import jane_socket
from pynq import Clocks

from pynq import Xlnk

xlnk = Xlnk()

jane = Overlay("/home/xilinx/jupyter_notebooks/jane/jane.bit")

dma_send = jane.PS_to_PL
num_words_mmio = MMIO(PL.ip_dict['num_words']['phys_addr'],PL.ip_dict['num_words']['addr_range'])


run_pin = GPIO(GPIO.get_gpio_pin(jane.gpio_dict['run']['index']),"out")
clk_pin = GPIO(GPIO.get_gpio_pin(jane.gpio_dict['clk_pin']['index']),"out")
reset_pin = GPIO(GPIO.get_gpio_pin(jane.gpio_dict['reset_pin']['index']),"out")
status_pins = (GPIO(GPIO.get_gpio_pin(3), 'in'),
               GPIO(GPIO.get_gpio_pin(4), 'in'),
               GPIO(GPIO.get_gpio_pin(5), 'in'),
               GPIO(GPIO.get_gpio_pin(6), 'in'))

def toggle_start():
    run_pin.write(1)
    run_pin.write(0)

def toggle_trigger():
    clk_pin.write(1)
    clk_pin.write(0)

def read_clk_freq():
    data = np.array(Clocks.fclk0_mhz, dtype = np.float64)
    connection.connection.sendall(data)

def reset_brd():
    reset_pin.write(1)
    reset_pin.write(0)
    connection.connection.sendall(b'\x00')

def send_status():
    status = 0
    for n,w in enumerate(status_pins):
        status += w.read()*(2**n)
    status = np.array(status, dtype = np.uint8)
    connection.connection.sendall(status)

def watchdog():
    '''This is a dummy command.
    '''
    pass


def abort():
    '''This is a dummy command.
    '''
    pass

def print_program_line(program, n):
    #print("{:032b}|{:032b}|{:032b}|{:032b}".format(
    #    program[n*4+3],program[n*4+2],program[n*4+1],program[n*4]))
    bitstream = "{:032b}{:032b}{:032b}{:032b}".format(
                    program[n*4+3],program[n*4+2],program[n*4+1],program[n*4])[::-1]

    opcode = int(bitstream[52:56][::-1],2)
    flags = int(bitstream[56:120][::-1],2)
    data = int(bitstream[32:52][::-1],2)
    time =int(bitstream[0:32][::-1],2)
    print("{:064b}|{}|{}|{}".format(flags,data,opcode,time))

def receive_program(connection):
    #print("STOP:{}".format(status_pins[0].read()))
    #print("RESET:{}".format(status_pins[1].read()))
    #print("WAIT:{}".format(status_pins[2].read()))
    #print("RUN:{}".format(status_pins[3].read()))

    #Receiving data size as 4 bytes to firm a 32 bit number
    data_size = np.array(0,dtype=np.uint32)
    buff = connection.read_all_data(4)
    np.copyto(data_size,np.frombuffer(buff,dtype=np.uint32))
    #print("Received size of program: {} bytes".format(data_size))

    #Receiving program
    buff = connection.read_all_data(data_size)
    #print("Buffer received {} bytes".format(len(buff)))

    #Allocating memory
    program = xlnk.cma_array(shape=(data_size//4,), dtype=np.uint32)
    #print("Memory allocated")
    np.copyto(program,np.frombuffer(buff,dtype=np.uint32))
    #print("Memory content:")
    #for n in range(100):
    #    print_program_line(program,n)

    #Sending program size to DMA engine
    num_words_mmio.array[0]=data_size//4-1

    #Starting the DMA channel
    dma_send.sendchannel.start()

    #Starting DMA transfer
    dma_send.sendchannel.transfer(program)
    #print("DMA started and waiting...")
    dma_send.sendchannel.wait()
    #print("...DMA done!")

    program.close()
    del program

    #print("Memory de-allocated")


while True:
    connection = jane_socket.LINK()
    allowed_instr = {'receive_program':receive_program, #connection.receive_program
                'toggle_start': toggle_start,
                'read_clk_freq': read_clk_freq,
                'reset_brd': reset_brd,
                'print': print,
                'watchdog': watchdog,
                'abort': abort,
                'send_status': send_status}
    instruction = ""


    while not (instruction == "abort()") :
        #    eval(instruction,{'__builtins__': None}, allowed_instr)
        try:
            instruction = connection.receive_string()
            #print(instruction)
            eval(instruction)
        except:
            print("\u001b[2KTimeout: connection lost! Ready for reconnection.                ",end = '\r')
            connection.reconnect()
    #print("Connection properly closed by client!")
    del connection
