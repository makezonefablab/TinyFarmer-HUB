#-*- coding: utf-8 -*-
#!/usr/bin/python
"""
    
    Project : Tiny Farmer
    SubProject : Tinyfarmer HUB Master for RFM69
    
    Since : 2017.01.11
    Author : Lee Sung Mo (Mediaflow)
    URL : www.tinyfarmer.com  / www.mediaflow.kr
    e-mail : iot@mediaflow.kr

    Reference Site (library)
    - https://github.com/etrombly/RFM69

    - RFM69 RF module
    - RF moddule via UART interface
    
    modification (2016.12.26)
    -
    
    
"""
import RFM69
from RFM69registers import *
import datetime
import socket
from netcat import *
import time
import RPi.GPIO as GPIO
import sys
import re, uuid
import struct 
import pprint
import ConfigParser
import os
import StringIO
import thread
import operator
import requests
import itertools
import logging
import logging.handlers
from collections import defaultdict
import json


#############################################################################
#### Log 

logFile = "/home/mediaflow/TinyfarmerMaster/log"
logDir = os.path.dirname(logFile)

if not os.path.exists(logDir):
    os.makedirs(logDir)

def setup_logger(logger_name, log_file, level=logging.INFO):
    l = logging.getLogger(logger_name)
    formatter = logging.Formatter('%(asctime)s[%(levelname)s] - %(message)s')
    fileHandler = logging.FileHandler(log_file)
    fileHandler.setFormatter(formatter)
    #streamHandler = logging.StreamHandler()
    #streamHandler.setFormatter(formatter)
    l.setLevel(level)
    l.addHandler(fileHandler)
    #l.addHandler(streamHandler)

#############################################################################
def read_properties_file(file_path):
    with open(file_path) as f:
        config = StringIO.StringIO()
        config.write('[dummy_section]\n')
        config.write(f.read().replace('%', '%%'))
        config.seek(0, os.SEEK_SET)

        cp = ConfigParser.SafeConfigParser()
        cp.readfp(config)

        return dict(cp.items('dummy_section'))

# HubWeb Get config Data
props = read_properties_file('/home/mediaflow/TinyfarmerHub/classes/config/config.properties')
baud = props['baudrate']
ch = props['channel']

#
data_delay = int(props['data.delay'])
rfModuleType = props['rfmod.type']
ch = int(props['channel'])
#http_host = props.get('http_host')
#http_port = int(props.get('http_port'))






rfMod = RFM69.RFM69(RF69_433MHZ, 1, ch, True)
print "class initialized"
print "reading all registers"
results = rfMod.readAllRegs()
for result in results:
    print result
print "Performing rcCalibration"
rfMod.rcCalibration()
print "setting high power"
rfMod.setHighPower(True)
print "Checking temperature"
print rfMod.readTemperature(0)
print "setting encryption"
rfMod.encrypt("sampleEncryptKey")
print "sending blah to 1"
if rfMod.sendWithRetry(12, "ACK TEST", 0, 1):
    print "ack recieved"
print "reading"




st = defaultdict(list)
idst = {}
count = 0
tempTotal = ""
tempCount = ""

http_host = '106.240.234.11'   # Redefine to thr right URL later
http_port = 9052

hub_host = '192.168.0.89'
#hub_host = '192.168.0.83'
hub_port = 9001
http_dir = 'protocol/sensor'
http_getDialDir = 'protocol/dialIds'
MAC_ADDRESS = ''.join(re.findall('..', '%012x' % uuid.getnode()))



try:
    # create an AF_INET, STREAM socket (TCP)
    client_connect = NetCat(hub_host, hub_port)
except socket.error, msg:
    print 'Failed to create socket. Error code: ' + str(msg[0]) + ' , Error message : ' + msg[1]
    sys.exit();

print 'Socket Created'





#############################################################################
def GetDataFromNODE():
    while True:
        try:

            rfMod.receiveBegin()

            while not rfMod.receiveDone():
                time.sleep(.1)

            print "[SENDERID = {}] {}".format(rfMod.SENDERID, "".join([chr(letter) for letter in rfMod.DATA]))
            # Data from Sensor Node
            dataString = "".join([chr(letter) for letter in rfMod.DATA])

            stringDiv = dataString.split(',')

            # Sensor Node ID
            nodeID = stringDiv[0]


            #value = "%s,%s,%s,%s,%s,%s"%(stringDiv[1],stringDiv[2], stringDiv[3], stringDiv[4], stringDiv[5], stringDiv[6])
            #valueId = "%s,%s,%s,%s,%s,%s"%(MAC_ADDRESS, stringDiv[0], stringDiv[3], stringDiv[4], stringDiv[5], stringDiv[6])

            # total, count , temp, hum, ill, co2
            value1 = "%s,%s,%s,%s,%s,%s"%(stringDiv[1],stringDiv[2], stringDiv[3], stringDiv[4], stringDiv[5], stringDiv[6])

            # total, count , ph, ec, soilTemp, soilHum
            value2 = "%s,%s,%s,%s,%s,%s"%(stringDiv[1],stringDiv[2], stringDiv[3], stringDiv[4], stringDiv[5], stringDiv[6])

            # total, count , windDir, windVol , rainfall, custom1
            value3 = "%s,%s,%s,%s,%s,%s"%(stringDiv[1],stringDiv[2], stringDiv[3], stringDiv[4], stringDiv[5], stringDiv[6])

            # total, count , custom2, custom3, custom4, sleep
            value4 = "%s,%s,%s,%s,%s,%s"%(stringDiv[1],stringDiv[2], stringDiv[3], stringDiv[4], stringDiv[5], stringDiv[6])

            #if count sequance error happens, above variables are replaced with the belows
            valueError1 = "4,1,0,0,0,0"  # total, count , temp, hum, ill, co2
            valueError2 = "4,2,0,0,0,0"  # total, count , ph, ec, soilTemp, soilHum
            valueError3 = "4,3,0,0,0,0"  # total, count , windDir, windVol , rainfall, custom1
            valueError4 = "4,4,0,0,0,0"  # total, count , custom2, custom3, custom4, sleep


            '''
              ST[ ] =
              nodeID, [4,1,0,0,0,0] [4,2,0,0,0,0] [4,3,0,0,0,0] [4,4,0,0,0,0]
              nodeID, [4,1,0,0,0,0] [4,2,0,0,0,0] [4,3,0,0,0,0] [4,4,0,0,0,0]
              ...
              nodeID, [4,1,0,0,0,0] [4,2,0,0,0,0] [4,3,0,0,0,0] [4,4,0,0,0,0]
            '''


            # Sensor Count = 1
            if stringDiv[2] == "1":
                #print "[SenderID = {}] Total = {} Count = {}".format(stringDiv[0], stringDiv[1], stringDiv[2])
                if len(st[nodeID]) > 0: # find existing data
                    print "[ID = {}] Data Removed".format(stringDiv[0])
                    print ""
                    del st[nodeID]            # old data removed
                    st[nodeID].append(value1) # new data inserted
                else:
                    st[nodeID].append(value1) # new data inserted

            # Sensor Count = 2
            elif stringDiv[2] == "2":
                #print "[SenderID = {}] Total = {} Count = {}".format(stringDiv[0], stringDiv[1], stringDiv[2])
                if st[nodeID][0][0] == "4" and st[nodeID][0][2] == "1":
                    st[nodeID].append(value2)
                    #print "[4][1] Included"
                else:
                    st[nodeID].append(valueError1)
                    print "[4][1] Not Included"

            # Sensor Count = 3
            elif stringDiv[2] == "3":
                #print "[SenderID = {}] Total = {} Count = {}".format(stringDiv[0], stringDiv[1], stringDiv[2])
                if st[nodeID][0][0] == "4" and st[nodeID][0][2] == "1":
                    if st[nodeID][1][0] == "4" and st[nodeID][1][2] == "2":
                        st[nodeID].append(value3)
                        #print "[4][2] Included"
                    else:
                        st[nodeID].append(valueError2)
                        print "[4][2] Not Included"
                else:
                    st[nodeID].append(valueError1)
                    print "[4][1] Not Included"
                    if st[nodeID][1][0] == "4" and st[nodeID][1][2] == "2":
                        st[nodeID].append(value3)
                        print "[4][2] Included"
                    else:
                        st[nodeID].append(valueError2)
                        print "[4][2] Not Included"


            # Sensor Count = 4
            elif stringDiv[2] == stringDiv[1]:
                #print "[SenderID = {}] Total = {} Count = {}".format(stringDiv[0], stringDiv[1], stringDiv[2])
                if st[nodeID][0][0] == "4" and st[nodeID][0][2] == "1":
                    if st[nodeID][1][0] == "4" and st[nodeID][1][2] == "2":
                        if st[nodeID][2][0] == "4" and st[nodeID][2][2] == "3":
                            st[nodeID].append(value4)
                            #print "[4][3] Included"
                        else:
                            st[nodeID].append(valueError3)
                            print "[4][3] Not Included"
                    else:
                        st[nodeID].append(valueError2)
                        print "[4][2] Not Included"
                        if st[nodeID][2][0] == "4" and st[nodeID][2][2] == "3":
                            st[nodeID].append(value4)
                            #print "[4][3] Included"
                        else:
                            st[nodeID].append(valueError3)
                            print "[4][3] Not Included"
                else:
                    st[nodeID].append(valueError1)
                    print "[4][1] Not Included"
                    if st[nodeID][1][0] == "4" and st[nodeID][1][2] == "2":
                        st[nodeID].append(value3)
                        #print "[4][2] Included"
                    else:
                        st[nodeID].append(valueError2)
                        print "[4][2] Not Included"
                        if st[nodeID][2][0] == "4" and st[nodeID][2][2] == "3":
                            st[nodeID].append(value4)
                            #print "[4][3] Included"
                        else:
                            st[nodeID].append(valueError3)
                            print "[4][3] Not Included"

                # Send data to HUB
                SendData2HUB(nodeID)

                print "[ID = {}] Data Removed".format(stringDiv[0])
                print ""
                del st[nodeID]

            if rfMod.ACKRequested():
                rfMod.sendACK()
                #print "rfMod.sendACK()"

        except IndexError as e:
            print "IndexError"

#############################################################################
def request2NODES():
    while True:

        for nodeID in range(len(SensorNodeIDs)):
            for testCount in range(4):
                testPrint = rfMod.sendWithRetry(SensorNodeIDs[nodeID],'A',3,3)
                time.sleep(10)
                print "[ID = {}] DataReturn = {}".format(SensorNodeIDs[nodeID],testPrint)

        '''
        for testCount in range(4):
            a1 = rfMod.sendWithRetry(3, 'A', 3, 3)
            print "[ID = 3] =",a1
            time.sleep(3)
        for testCount in range(1):
            a2 = rfMod.sendWithRetry(7, 'A', 3, 3)
            print "[ID = 7] =",a2
            time.sleep(5)
        for testCount in range(4):
            a3 = rfMod.sendWithRetry(12, 'A', 3, 3)
            print "[ID = 12] =",a3
            time.sleep(3)
        '''

        time.sleep(1)


#############################################################################
# Make data[] to a string
def SendData2HUB(_nodeID):

        # print "[ID] = ",stringDiv[0], " [Length] = ",len(st[_nodeID])," [Data] = ",st[_nodeID]

        dtString = ""
        dtString += MAC_ADDRESS + ","
        dtString += _nodeID + ","

        for i in range(len(st[_nodeID])):  # loop 4 count
            if i == len(st[_nodeID]) - 1:  # last list value
                dtString += st[_nodeID][i][4:]
            else:
                dtString += st[_nodeID][i][4:] + ","

        try:
            if len(st[_nodeID]) == 4:
                convertedString = Convert2Json(dtString)  # make JSON Format
                #print "TERM : ", convertedString

                Send2HUB(convertedString)
                #logger_Master_RFM69.info("[HTTP][Requests][Data] = %s" % convertedString)


                # print "[TEST] = ", aaaa
                # st.clear()
        except:
            # logger_Master_RFM69.info("[HTTP][Requests][Error] = Not Sending to Cloud")
            print "SendData2HUB ERROR"


#############################################################################
# Send Data to HUB
def Send2HUB(convertedString):
    try:
        client_connect.sendall(convertedString)
        #msg = client_connect.socket.recv(4096)
        print "SEND : ", convertedString

        #print "!!!!!!!!!!!",msg

    except socket.error:
        # logger_Master_RFM69.info("[HTTP][Requests][Error] = Sensor Value Error")
        # Send failed
        print 'Send failed'

#############################################################################
# Convert string data to json string
def Convert2Json(dtString):

    stringJson = dtString.split(',')
    #"custom1":"%s","custom2":"%s","custom3":"%s"
    convertedString = \
    '{"ptCd":"06","id":"%s"' \
    ',"temp":"%s","hum":"%s","ill":"%s","co2":"%s"' \
    ',"ph":"%s","ec":"%s","soilTemp":"%s","soilHum":"%s"' \
    ',"windDir":"%s","windVol":"%s","rainfall":"%s","custom1":"%s"' \
    ',"custom2":"%s","custom3":"%s","sleep":"%s"}'\
    %(\
        # mac
        #MAC_ADDRESS,\
        # id
        stringJson[1],\
        # temp
        stringJson[2],\
        # hum
        stringJson[3],\
        # ill
        stringJson[4],\
        # co2
        stringJson[5],\
        # ph
        stringJson[6],\
        # ec
        stringJson[7],\
        # soilTemp
        stringJson[8],\
        # soilHum
        stringJson[9],\
        # windDir
        stringJson[10],\
        # windVol
        stringJson[11],\
        # rainfall
        stringJson[12],\
        # custom1
        stringJson[13],\
        # custom2
        stringJson[14],\
        # custom3
        stringJson[15],\
        # custom4
        #stringJson[16],\
        # sleep
        stringJson[17])

    return convertedString

SensorNodeIDs=[]


#############################################################################
# Get Sensor Node ID from Web
def GetDial():
        url = "http://%s:%s/%s"% (http_host,http_port,http_getDialDir)
        payload = {
            'data' : '{"ptCd":"12", "rid":"%s"}'%(MAC_ADDRESS)
        }
        #logger_Master_RFM69.info("[HTTP][Requests][DialIds] = %s"% payload)
        r= requests.post(url, data = payload)
        #logger_Master_RFM69.info("[HTTP][Response][DialIds] = %s"% r.text)
        data = json.loads(r.text)
        for i in range(int(data["count"])):
            SensorNodeIDs.append(int(data["dialIds"][i]))


#############################################################################
def Send2Node():
    while True:
        for testCount in range(4):
            a3 = rfMod.sendWithRetry(3, 'A', 3, 3)
            print "[ID = 3] =",a3
            time.sleep(3)
        for testCount in range(4):
            a3 = rfMod.sendWithRetry(7, 'A', 3, 3)
            print "[ID = 7] =",a3
            time.sleep(3)
        for testCount in range(4):
            a3 = rfMod.sendWithRetry(12, 'A', 3, 3)
            print "[ID = 12] =",a3
            time.sleep(3)



#############################################################################
if "__main__" == __name__:    

    d = datetime.date.today()

    LogPath = '%s/RFM69_%s_%s_%s.log'%(logFile, d.year, d.month, d.day)

    logger_Master_RFM69 = logging.getLogger('Master_RFM69')

    logger_Master_RFM69.info("==================================")
    logger_Master_RFM69.info("      TinyfarmerMaster Start")
    logger_Master_RFM69.info("==================================")


    if rfModuleType == "RFM69":
        print "Starting RFM69 Sensor.............."

    # Thread Start
    thread.start_new_thread(GetDataFromNODE,())

    GetDial() # get registered IDs of nodes from Cloud

    try:
        client_connect.open()
        
        print "################### HUB Socket connection is successful ###################"
    except:
        client_connect.close()
        client_connect.reconnect()



    while True:
        d = datetime.date.today()

        setup_logger('Master_RFM69', '%s'%(LogPath))


        #for i in range(len(SensorNodeIDs)):
            #print "Sensor Node ID = ",SensorNodeIDs[i]
        """
        for nodeID in range(len(SensorNodeIDs)):
            for testCount in range(4):
                testPrint = rfMod.sendWithRetry(SensorNodeIDs[nodeID],'A',3,3)
                time.sleep(3)
                print "[ID = {}] DataReturn = {}".format(SensorNodeIDs[nodeID],testPrint)

        """
        """
        #for testCount in range(4):
            a1 = rfMod.sendWithRetry(3, 'A', 3, 3)
            print "[ID = 3] =",a1
            time.sleep(3)
        for testCount in range(1):
            a2 = rfMod.sendWithRetry(7, 'A', 3, 3)
            print "[ID = 7] =",a2
            time.sleep(5)
        for testCount in range(4):
            a3 = rfMod.sendWithRetry(12, 'A', 3, 3)
            print "[ID = 12] =",a3
            time.sleep(3)
        """
        
        time.sleep(1)

    print "shutting down"
    rfMod.shutdown()
