# -*- coding: utf8 -*-

"""
    
    Project : Tiny Farmer
    SubProject : Tinyfarmer HUB Master for HC12
    
    Since : 2017.01.11
    Author : Lee Sung Mo (Mediaflow)
    URL : www.tinyfarmer.com  / www.mediaflow.kr
    e-mail : iot@mediaflow.kr
    
    - HC12 RF module
    - RF moddule via UART interface
    
    modification (2017.01.24)
    - JAVA module Communication added
    - HC12 Configuration following property file

    modification (2017.02.03)
    - getIP(): added
    - http_host, http_port get from config.properties file
    - add HC12 trasmit power config in setup_HC12(_ch, _baud)
    
    modification (2017.02.06)
    - hub_port = int(props['port']) modified
    
"""

from socket import *
from select import select
import sys
import re, uuid
import serial
import RPi.GPIO as GPIO
import time
import requests
import thread
import json
import ConfigParser
import StringIO
import os
import logging
import logging.handlers
import datetime
import socket
from netcat import *
from subprocess import *

EachSensorDelay = 2  #delay 2 senconds
HC12_SETUP_PIN  = 7  # GPIO
LED1_REQUEST = 11
LED2_SEND_OK = 13
LED3_ALIVE   = 15

dataList=[]
SensorNodeIDs=[]

logFile = "/home/mediaflow/TinyfarmerMaster/log"
logDir = os.path.dirname(logFile)

if not os.path.exists(logDir):
    os.makedirs(logDir)



# when your code ends, the last line before the program exits would be...
#GPIO.cleanup()
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD) ## board numbering
GPIO.setup(HC12_SETUP_PIN, GPIO.OUT)
GPIO.setup(LED1_REQUEST, GPIO.OUT)
GPIO.setup(LED2_SEND_OK, GPIO.OUT)
GPIO.setup(LED3_ALIVE, GPIO.OUT)



####################################################################
def setup_logger(logger_name, log_file, level=logging.INFO):
    l = logging.getLogger(logger_name)
    formatter = logging.Formatter('%(asctime)s[%(levelname)s] - %(message)s')
    fileHandler = logging.FileHandler(log_file)
    fileHandler.setFormatter(formatter)
    l.setLevel(level)
    l.addHandler(fileHandler)


####################################################################
def read_properties_file(file_path):
    with open(file_path) as f:
        config = StringIO.StringIO()
        config.write('[dummy_section]\n')
        config.write(f.read().replace('%', '%%'))
        config.seek(0, os.SEEK_SET)

        cp = ConfigParser.SafeConfigParser()
        cp.readfp(config)

        return dict(cp.items('dummy_section'))


####################################################################
def getIP():
    cmd = "ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1"
    p = Popen(cmd, shell=True, stdout=PIPE)
    output = p.communicate()[0]
    print 'GET IP: ' + output
    return output



props = read_properties_file('/home/mediaflow/TinyfarmerHub/classes/config/config.properties')
baud = props['baudrate']
ch = props['channel']
data_delay = int(props['data.delay'])

http_host = props['server.host'] #'106.240.234.11'   # Redefine to thr right URL later
http_port = int(props['server.http.port']) #9052

hub_host = getIP()
hub_port = int(props['port'])

http_dir = 'protocol/sensor'
http_getDialDir = 'protocol/dialIds'
MAC_ADDRESS = ''.join(re.findall('..', '%012x' % uuid.getnode()))




ser = serial.Serial('/dev/ttyAMA0',baud,timeout=1)


try:
    # create an AF_INET, STREAM socket (TCP)
    client_connect = NetCat(hub_host, hub_port)
except socket.error, msg:
    print 'Failed to create socket. Error code: ' + str(msg[0]) + ' , Error message : ' + msg[1]
    sys.exit();

print 'Socket Created'

GPIO.output(HC12_SETUP_PIN, 1)
GPIO.output(LED1_REQUEST, 1)
GPIO.output(LED2_SEND_OK, 1)
GPIO.output(LED3_ALIVE, 1)








####################################################################
def setup_HC12(_ch, _baud):

    GPIO.output(HC12_SETUP_PIN, 0)
    time.sleep(1)

    stringConfig = "AT+B" + _baud + "\r\n"

    ser.write(stringConfig)
    time.sleep(1)



    stringConfig = "AT+P8\r\n"

    ser.write(stringConfig)
    time.sleep(1)



    stringConfig = "AT+C" + _ch.zfill(3) + "\r\n"

    ser.write(stringConfig)
    time.sleep(1)

    GPIO.output(HC12_SETUP_PIN, 1)



####################################################################
def fixup(adict, k, v):
    for key in adict.keys():
        if key == k:
            adict[key] = v
        elif type(adict[key]) is dict:
            fixup(adict[key],k,v)

################ Replace data from Sensor Node to Protocol Format
def fixAll(adict1, adict2):
    for key1 in adict1.keys():
        for key2 in adict2.keys():
            if key1 == key2:
                adict1[key1] = adict2[key2]
            elif type(adict1[key1]) is dict:
                fixup(adict1[key1],adict2[key2])


################ Change To Tinyfarmer Sensor Node Protocol Format
def JsonProtocol(args):

    replaceJson = args

    jsonString = \
    '{"ptCd": "0", "rid": "0", "id": "0" \
    , "temp": "0.00", "hum": "0.00", "ill": "10", "co2": "0"\
    , "ph": "0", "ec": "0", "soilTemp": "0", "soilHum": "0"\
    , "windDir": "0", "windVol": "0", "rainfall": "0", "custom1": "0"\
    , "custom2": "0", "custom3": "0", "sleep": "1"}'

    jsonLoad = json.loads(jsonString)
    fixAll(jsonLoad, replaceJson)

    return jsonLoad




#############################################################################
# Make data[] to a string
def SendData2Node(dataSend):

    logger_TinyfarmerMaster_Serial.info("[SerialProtocol][Send][Data] = %s" % dataSend)
    print "Request = ", dataSend
    ser.write(dataSend)
    GPIO.output(LED1_REQUEST, 0)
    time.sleep(1)

    # receive data from a sensor node
    if (ser.inWaiting > 0):
        response = ser.readline()
        print "len(response) = ", len(response)
        print "response = ", response

        if (response == ""):
            logger_TinyfarmerMaster_Serial.info("[SerialProtocol][Receive][Data] = NULL")
            print "[SerialProtocol][Receive][Data] = NULL"
            GPIO.output(LED1_REQUEST, 1)
            return 1
        else:
            logger_TinyfarmerMaster_Serial.info("[SerialProtocol][Receive][Data] = %s" % response)
            print "[SerialProtocol][Receive][Data] = %s", response

    if len(response) > 0:
        try:
            Send2HUB(response)
        except ValueError:
            print "SendData2Node Error"

    GPIO.output(LED1_REQUEST, 1)
    #elif len(response) == 0:
    #    try:


    #    except ValueError:
    #        print "SendData2Node Error"



#############################################################################
# Send Data to HUB
def Send2HUB(convertedString):
    try:
        GPIO.output(LED2_SEND_OK, 0)
        client_connect.sendall(convertedString)
        # msg = client_connect.socket.recv(4096)
        print "SEND : ", convertedString
        time.sleep(.500)
        GPIO.output(LED2_SEND_OK, 1)

        # print "!!!!!!!!!!!",msg

    except socket.error:
        # logger_Master_RFM69.info("[HTTP][Requests][Error] = Sensor Value Error")
        # Send failed
        print 'Send failed'



####################################################################
def GetDial():
        url = "http://%s:%s/%s"% (http_host,http_port,http_getDialDir)
        payload = {
            'data' : '{"ptCd":"12", "rid":"%s"}'%(MAC_ADDRESS)
        }
        logger_TinyfarmerMaster_Http.info("[HTTP][Requests][DialIds] = %s"% payload)
        r= requests.post(url, data = payload)
        logger_TinyfarmerMaster_Http.info("[HTTP][Response][DialIds] = %s"% r.text)
        data = json.loads(r.text)
        for i in range(int(data["count"])):
            SensorNodeIDs.append(int(data["dialIds"][i]))
        

####################################################################
if "__main__" == __name__:

    d = datetime.date.today()

    folder_Dir = '%s/%s/%s/%s/' %(logFile, d.year, d.month, d.day)

    Serial_Dir = '%s/[Serial]TinyfarmerMaster_%s_%s_%s.log'%(folder_Dir, d.year, d.month, d.day)
    Http_Dir = '%s/[Http]TinyfarmerMaster_%s_%s_%s.log'%(folder_Dir, d.year, d.month, d.day)

    logger_TinyfarmerMaster_Serial = logging.getLogger('TinyfarmerMaster_Serial')
    logger_TinyfarmerMaster_Http = logging.getLogger('TinyfarmerMaster_Http')

    logger_TinyfarmerMaster_Serial.info("==================================")
    logger_TinyfarmerMaster_Serial.info("      TinyfarmerMaster Start")
    logger_TinyfarmerMaster_Serial.info("==================================")

    logger_TinyfarmerMaster_Http.info("==================================")
    logger_TinyfarmerMaster_Http.info("      TinyfarmerMaster Start")
    logger_TinyfarmerMaster_Http.info("==================================")

    GetDial() # received client's ID from server

    setup_HC12(ch, baud); # HC12 setup

    try:
        client_connect.open()

        print "################### HUB Socket connection is successful ###################"
    except:
        client_connect.close()
        client_connect.reconnect()
    
    while True:
        try:
            d = datetime.date.today()
            
            if not os.path.exists(folder_Dir):
                print "No folder_DIR"
                os.makedirs(folder_Dir)

            if not os.path.isfile(Serial_Dir):
                print "No Serial_DIR"
                setup_logger('TinyfarmerMaster_Serial', '%s/[Serial]TinyfarmerMaster_%s_%s_%s.log'%(folder_Dir, d.year, d.month, d.day))

            if not os.path.isfile(Http_Dir):
                print "No Http_DIR"
                setup_logger('TinyfarmerMaster_Http', '%s/[Http]TinyfarmerMaster_%s_%s_%s.log'%(folder_Dir, d.year, d.month, d.day))



            for i in range(len(SensorNodeIDs)):
                #print SensorNodeIDs[i]
                dt = datetime.datetime.now()
                Result_data = SendData2Node('{"id":"%s","ch":"%s","req":"1"}' % (SensorNodeIDs[i], ch))
                dt = datetime.datetime.now()
                
                if(Result_data == 1):
                    print "Sending one more.........."
                    time.sleep(EachSensorDelay)  # delay 2 seconds
                    SendData2Node('{"id":"%s","ch":"%s","req":"1"}' % (SensorNodeIDs[i], ch))
                
                time.sleep(EachSensorDelay) #delay 2 seconds

            GPIO.output(LED3_ALIVE, 0) # ON
            time.sleep(data_delay)     # Delay Time
            GPIO.output(LED3_ALIVE, 1) # OFF

        except KeyboardInterrupt:
            sys.exit()
            GPIO.cleanup()
