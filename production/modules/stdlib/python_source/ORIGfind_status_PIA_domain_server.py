import os
import calendar
import sys, getopt
import time as systime
##import time
import smtplib


##from email.mime.multipart import MIMEMultipart
##from email.mime.text import MIMEText

from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText

#
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def getHealth(param_server):
   bean="/ServerLifeCycleRuntimes/" + param_server
   serverbean=getMBean(bean)
   srvr_status=serverbean.getState()
   print "\n Server Status : " + srvr_status + "\n" 
   if (srvr_status == 'RUNNING'):
     return 0
   return -1
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

AdminHost=sys.argv[1]
AdminPortType=sys.argv[2]
AdminPort=sys.argv[3]
AdminUserName=sys.argv[4]
AdminPswd=sys.argv[5]

msrvr=sys.argv[6] 
if AdminPortType =='http' :
  AdminURL = 't3://' + AdminHost +':' + AdminPort
else:
  AdminURL = 't3s://' + AdminHost +':' + AdminPort

LHostName= os.environ.get('HOSTNAME')

#Connect to Admin Server
try:
  connect(AdminUserName,AdminPswd, AdminURL )
  print ' Connection Successful'
except:
   print 'DOWN'
   exit(exitcode=101)


domainRuntime()
iretcode=0
iretcode=getHealth(msrvr)
serverConfig()
disconnect()
exit(str(iretcode))

##-------------------------------------------------------------------------
## END Program
##-------------------------------------------------------------------------

