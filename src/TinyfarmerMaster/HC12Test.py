import sys
import serial
import RPi.GPIO as GPIO
import time

HC12_SETUP_PIN  = 7  # GPIO
LED1_REQUEST = 11
LED2_SEND_OK = 13
LED3_ALIVE   = 15

# when your code ends, the last line before the program exits would be...
#GPIO.cleanup()
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD) ## board numbering
GPIO.setup(HC12_SETUP_PIN, GPIO.OUT)
GPIO.setup(LED1_REQUEST, GPIO.OUT)
GPIO.setup(LED2_SEND_OK, GPIO.OUT)
GPIO.setup(LED3_ALIVE, GPIO.OUT)

ser = serial.Serial('/dev/ttyAMA0','9600',timeout=1)

####################################################################
def setup_HC12():

    GPIO.output(HC12_SETUP_PIN, 0)
    time.sleep(1)


    stringConfig = "AT+RX\r\n"

    ser.write(stringConfig)
    
    time.sleep(0.2)

    # receive data from a sensor node
    if (ser.inWaiting > 0):
        response = ser.readline()
        print "response = ", response

    time.sleep(1)

    GPIO.output(HC12_SETUP_PIN, 1)




setup_HC12()  # HC12 setup



