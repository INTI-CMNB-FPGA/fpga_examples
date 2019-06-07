#!/usr/bin/python
#
# udp_echo
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

UDP_SAMPLES_PER_READ = 1024

###################################################################################################
# Parsing the command line
###################################################################################################

parser = argparse.ArgumentParser(
   prog        = 'udp_echo',
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
   '-f', '--filename',
   metavar     = 'FILENAME',
   default     = 'samples',
   help        = ''
)

parser.add_argument(
   '-s', '--samples',
   metavar     = 'NUM_OF_SAMPLES',
   default     = '1024',
   help        = ''
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

print("Address: %s" % (ip_addr))
print("Port:    %s" % (port))
print("Samples: %s" % (str(samples)))
print("Index:   %s" % (str(index)))

try:
   s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
except:
   print("Connection refused")
   exit()

s.settimeout(1.0)

print("Sending parameters")

tx_buf  = pack("i",samples)
tx_buf += pack("i",index)
s.sendto(tx_buf, (ip_addr, port))

print("Waiting for data...")

fp = open(filename+".txt", "w")

rx_buf = bytearray()
while samples:
   if samples > UDP_SAMPLES_PER_READ:
      qty = UDP_SAMPLES_PER_READ
   else:
      qty = samples
   try:
      rx_buf.extend(s.recvfrom(qty*4)[0])
   except:
      print("ERROR: RX TimeOut (%d missing samples). Please, try again." % (samples))
      exit()
   samples = samples - qty

print("Data received, processing...")

for aux in iter_unpack("i", rx_buf):
    data = aux[0]
    if index != data:
       print("ERROR: received (%d) != awaited (%d)" % (data, index))
    index+=1
    fp.write("%d\n" % (data))

print("Done")
s.close()
fp.close()
