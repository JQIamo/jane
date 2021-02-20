import socket
import sys
import numpy as np
import logging


# Levels of log CRITICAL ERROR WARNING INFO DEBUG NOTSET
# When everything works WARNING is a reasonable setting
logging.basicConfig(level = logging.WARNING)


class LINK():
    def __init__(self,server_ip_address = '192.168.2.99', server_port = 6750):

        # Create a TCP/IP socket
        self.connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        # Connect the socket to the port where the server is listening
        self.server_address = (server_ip_address, server_port)
        print('connecting to server {0:} port {1:}'.format(server_ip_address,server_port))
        self.connection.connect(self.server_address)


    def send_string(self,string):
        logging.debug("Sending {}".format(bytes(string,'utf-8')))
        buffer=bytes(string, 'utf-8')
        length_of_buffer=len(buffer)
        logging.debug("Length is {}".format(length_of_buffer))
        self.connection.sendall(np.array(length_of_buffer,dtype=np.uint8))
        self.connection.sendall(buffer)

    def send_buff(self,buffer):
        self.connection.sendall(buffer)

    def receive_string(self):
        data = self.read_all_data(1)
        string_size=int(np.fromstring(data,dtype=np.uint8))
        if (string_size != 0):
            data = self.read_all_data(string_size)
        else:
            data=b''
        return str(data,'utf-8')

    def read_all_data(self,to_be_read):
        buffer=b''
        while to_be_read > 0:
            data = self.connection.recv(to_be_read)
            to_be_read=to_be_read-len(data)
            #Uncomment next three rows to use as loopback
            #print("Just received packet n. {}".format(i+1))
            #print('sending data back to the client')
            #connection.sendall(data)
            buffer+=data
        return buffer

    def close(self):
        self.connection.close()
        self.is_active = False

    def __del__(self):
        self.connection.close()
        print('connection to {} has been closed'.format(self.server_address))
