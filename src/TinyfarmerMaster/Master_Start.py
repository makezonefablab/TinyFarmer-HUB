#-*- coding: utf-8 -*-
#!/usr/bin/python
import sys
import ConfigParser
import os
import StringIO
import operator
import itertools


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

props = read_properties_file('/home/mediaflow/TinyfarmerHub/classes/config/config.properties')
rfModuleType = props['rfmod.type']

if rfModuleType == "RFM69":
    os.system("sudo python /home/mediaflow/TinyfarmerMaster/Master_RFM69.py &")
    print "RFM69"
else:
    os.system("sudo python /home/mediaflow/TinyfarmerMaster/Master_HC12.py &")
    print "HC12"



