#Imports necessary for TCP-IP sockets
import socket, select
import sys, traceback
import numpy as np
import logging
from time import time

#DEBUG, INFO, WARNING, ERROR, CRITICAL
logging.basicConfig(level = logging.WARNING)

#Decorator to silence the logging activity
def not_verbose(print_function):
    def do_nothing(self):
        pass
    return do_nothing;

class config:
    BITFILEDIRECTORY='/home/xilinx/pynq/overlays/labscript/'

# To add some color to representations
class color:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    ORANGE = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


#@not_verbose
def diagnostic_message(*argv,verbosity_level=0):
    return print(*argv);


class LINK():
    def __init__(self,host_name = None, local_port = 6750, reuse_address=True):

        #Figuring out the host host_name
        if (host_name == None):
            import subprocess as sp
            host_name = sp.check_output('hostname -I',shell = True).decode("utf-8")
        # create an INET, STREAMing socket

        self.serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.emergencysocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        if reuse_address:
            self.serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            diagnostic_message("Socket Binding has been disabled: to enable it call LINK()")
            diagnostic_message(" with the default argument reuse_address=False ")
            diagnostic_message("Disabling socket binding allows for re-use of sockets as soon")
            diagnostic_message(" as a connection has been improperly closed.")
            diagnostic_message("It might still require to kill previous processes or restart kernel")
            diagnostic_message(" in Jupyter in order to work")
            diagnostic_message("")
        # bind the socket to a public host, and a well-known port
        self.serversocket.bind((host_name, local_port))


        # become a server socket 5 is the magic number of connections that can wait... most servers use this number
        self.serversocket.listen(5)


        # Wait for a connection
        print("-----------------------------------------------------------------")
        print("")
        print('Waiting for a connection on port {}'.format(local_port))
        print('')
        print("-----------------------------------------------------------------")
        print('')
        self.connection, self.client_address = self.serversocket.accept()
        self.connection.setblocking(0)
        print('Connection established from', self.client_address)
        self.is_active = True
        self.param_loaded = False

        # To send back:
        # self.connection.sendall(data)
        # To receive n bytes:
        # data = self.connection.recv(n)

    def send_string(self,string):
        buffer=string.encode('ascii')
        lenght_of_buffer=bytes([len(buffer)])
        self.connection.sendall(lenght_of_buffer)
        self.connection.sendall(buffer)

    def receive_string(self):
        data = self.read_all_data(1)
        string_size=int(np.fromstring(data,dtype=np.uint8))
        logging.debug("The string size is {}".format(string_size))
        if (string_size != 0):
            data = self.read_all_data(string_size)
        else:
            data=b''
        return str(data,'utf-8')

    def receive_program(self, program):
        '''
        Receive a program, detects length automatically
        Interprets buffer as uint32, copies to program numpy array
        '''
        program_length = len(program)*4
        logging.debug("I'm about to receive {} bytes".format(program_length))
        buff = self.read_all_data(program_length)
        np.copyto(program,np.frombuffer(buff,dtype=np.uint32))

    def close(self):
        self.connection.close()
        self.is_active = False

    def reconnect(self):
        self.connection, self.client_address = self.serversocket.accept()
        self.connection.setblocking(0)
        print('Re-establishing connection from', self.client_address)

    def __del__(self):
        self.connection.close()
        print('connection from {} has been closed'.format(self.client_address))

    def __str__(self):
        s = ""
        s += "Content of the object is not set"
        s += "-----------------------------------------\r\n\r\n"


        return s

    def read_all_data(self,to_be_read, timeout = 5):
        buffer=b''
        now = time()
        time_elapsed=0
        while to_be_read > 0:
            data = b''
            if time_elapsed < timeout:
                try:
                    data = self.connection.recv(to_be_read)
                except:
                    pass
                if data:
                    now = time()
                time_elapsed = time() - now
            else:
                raise

            to_be_read=to_be_read-len(data)


            #print("Just received packet n. {}".format(i+1))
            #print('sending data back to the client')
            #connection.sendall(data)
            buffer+=data
        return buffer
