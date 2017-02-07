import subprocess
import os

args = subprocess.check_output("ps -ef|grep 'Master_RFM69.py'|grep -v grep|awk '{print $2}'", shell=True)
cmd = args.split()

for data in range(len(cmd)):
	os.system("sudo kill -9 %s"%cmd[data])


args = subprocess.check_output("ps -ef|grep 'Master_HC12.py'|grep -v grep|awk '{print $2}'", shell=True)
cmd = args.split()

for data in range(len(cmd)):
	os.system("sudo kill -9 %s"%cmd[data])
	