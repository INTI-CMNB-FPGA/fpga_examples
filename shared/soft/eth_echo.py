#!/usr/bin/python
#
# eth_echo
# Copyright (C) 2018-2019 INTI
# Copyright (C) 2018-2019 Rodrigo A. Melo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import socket, argparse, re, time
from struct import *

MAX_BYTES = 4096

###################################################################################################
# Parsing the command line
###################################################################################################

parser = argparse.ArgumentParser(
   prog        = 'eth_echo',
   description = ''
)

parser.add_argument(
   '-a', '--address',
   metavar     = 'IP',
   default     = '192.168.0.10',
   help        = ''
)

parser.add_argument(
   '-p', '--port',
   metavar     = 'PORT',
   default     = '1000',
   type        = int,
   help        = ''
)

parser.add_argument(
   '-u', '--udp',
    action     ='store_true'
)

parser.add_argument(
   '-f', '--filename',
   metavar     = 'FILENAME',
   default     = 'samples',
   help        = ''
)

parser.add_argument(
   '-s', '--samples',
   metavar     = 'NUM_OF_SAMPLES',
   default     = '1024',
   help        = '(4 bytes)'
)

parser.add_argument(
   '-i', '--index',
   metavar     = 'STARTING_VALUE',
   default     = '0',
   type        = int,
   help        = ''
)

options = parser.parse_args()

###################################################################################################

def getInt(value):
    try:
       if re.search("k", value, re.I):
          value = re.sub('k', '', value, 1,re.I)
          value = int(value)*1024
       elif re.search("m", value, re.I):
          value = re.sub('m', '', value, 1,re.I)
          value = int(value)*1024*1024
       value = int(value)
    except:
       print("There is an error with the NUM_OF_SAMPLES")
       print("It must be a integer, where you can use K (kilo) or M (mega)")
       exit()
    return value

###################################################################################################

ip_addr  = options.address
port     = options.port
filename = options.filename
samples  = getInt(options.samples)
index    = options.index
is_udp   = options.udp

print("Address: %s" % (ip_addr))
print("Port:    %s" % (port))
print("Samples: %s" % (str(samples)))
print("Index:   %s" % (str(index)))
print("Socket:  %s" % ("UDP" if is_udp else "TCP"))

try:
   if is_udp:
      s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
   else:
      s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      s.connect((ip_addr, port))
except:
   print("Connection refused")
   print("HINTS: check the IP address, the port and the socket type (TCP or UDP).")
   exit()

s.settimeout(1.0)

#
# TX
#

print("Sending parameters")

tx_buf  = pack("i",samples)
tx_buf += pack("i",index)
if is_udp:
   s.sendto(tx_buf, (ip_addr, port))
else:
   s.send(tx_buf)

#
# RX
#

print("Waiting for data...")

bytes = samples * 4

rx_buf = bytearray()
while bytes > 0:
   to_read = MAX_BYTES if bytes > MAX_BYTES else bytes
   try:
      if is_udp:
         recv = s.recvfrom(to_read)[0]
      else:
         recv = s.recv(to_read)
      rx_buf.extend(recv)
   except:
      print("ERROR: RX TimeOut (%d missing bytes). Please, try again." % (bytes))
      print("HINTS: check the socket type (TCP or UDP).")
      bytes = 0
   bytes -= len(recv)

s.close()

#
# Check
#

print("Verifying...")

if samples != (len(rx_buf)/4):
   print("ERROR: there were less samples than awaited (%d vs %d)" % (samples, len(rx_buf)/4))
else:
   print("INFO: %d samples received" % samples)

fp = open(filename+".txt", "w")
try:
   for aux in iter_unpack("i", rx_buf):
       data = aux[0]
       if index != data:
          print("ERROR: received (%d) != awaited (%d)" % (data, index))
       index+=1
       fp.write("%d\n" % (data))
except:
   print("ERROR: samples must be a multiple of 4 bytes (%d received)" % len(rx_buf))
fp.close()

print("INFO: the samples were written to %s.txt" % filename)
