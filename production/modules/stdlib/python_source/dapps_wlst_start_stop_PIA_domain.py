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
def startmanagedservers(param_server):
   bean="/ServerLifeCycleRuntimes/" + param_server
   serverbean=getMBean(bean)
   srvr_status=serverbean.getState()
   if (srvr_status == 'RUNNING'):
      print "\n waited 0" + " seconds Server :" + param_server + " " + srvr_status
      print ' Waited 0 seconds. Server :' + param_server + ' ' + srvr_status
   else:
      try:
         ##print ' Before start'
         start(param_server)
      except:
         print " Please wait \n\n"
         print " Starting.\n" 
         systime.sleep(3)
      srvr_status=serverbean.getState()
      ii = 0
      while (srvr_status != 'RUNNING' and ii < 12):
         systime.sleep(5)
         srvr_status=serverbean.getState()
         ##print " " + str(ii) + ": \n"
         ii = ii + 1
      print "\n waited "+  str(ii * 5 ) +" seconds. Server :" + param_server + " " + srvr_status
      if (srvr_status != 'RUNNING'):
          return -1
   return 0

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

def stopmanagedservers(param_server):
   bean="/ServerLifeCycleRuntimes/" + param_server
   serverbean=getMBean(bean)
   srvr_status=serverbean.getState()
   if (srvr_status != 'RUNNING'):
      print '\n Msg0 Server :' + param_server + ' ' + srvr_status
   else:
      try:
         ##print ' Before stop'
         shutdown(param_server)
      except:
         print ' Domain shuting error out from node manager. Please wait for 1 minute and see the status'
         ##time.sleep(60)
         systime.sleep(60)
      srvr_status=serverbean.getState()
      print '\n Msg1 Server :' + param_server + ' ' + srvr_status
      if (srvr_status == 'RUNNING'):
          return -1
   return 0

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

def connect2admin_server():
  AdminURL = 't3://' + AdminHost +':' + AdminPorthttp

  LHostName= os.environ.get('HOSTNAME')

  #Connect to Admin Server
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print '  AdminServer http Connection Successful'
    return 0
  except:
    print ' AdminServer connect with http failed and trying with HTTPS'

  AdminURL = 't3s://' + AdminHost +':' + AdminPorthttps
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print '  AdminServer https Connection Successful'
    return 0
  except:
    print ' AdminServer connect with HTTPS also Failed '
    return -1

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
##
##
GrandTotSessions=0

AdminHost=sys.argv[1]
AdminPorthttp=sys.argv[2]
AdminPorthttps=sys.argv[3]
AdminUserName=sys.argv[4]
AdminPswd=sys.argv[5]

req_stat=sys.argv[6] 
msrvr=sys.argv[7] 


LHostName= os.environ.get('HOSTNAME')

iretcode=connect2admin_server()
if iretcode  == -1:
   exit(exitcode=101)


domainRuntime()
##print '------------------------------------------------------------'
iretcode=0
if (req_stat  == 'stop'):
   iretcode=stopmanagedservers(msrvr)
if (req_stat  == 'start'):
   iretcode=startmanagedservers(msrvr) 
if (req_stat  == 'status'):
   iretcode=getHealth(msrvr)
serverConfig()
disconnect()
print '\n -------------------'
##print '------------------------------------------------------------'
exit(str(iretcode))

##-------------------------------------------------------------------------
## END Program
##-------------------------------------------------------------------------

