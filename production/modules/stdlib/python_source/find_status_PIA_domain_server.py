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
def OLDgetHealthOLD(param_server):
   bean="/ServerLifeCycleRuntimes/" + param_server
   serverbean=getMBean(bean)
   srvr_status=serverbean.getState()
   print "\n Server Status : " + srvr_status + "\n" 
   if (srvr_status == 'RUNNING'):
     return 0
   return -1
##-------------------------------------------------------------------------

def getHealth(param_Server):
    serverNames = cmo.getServers()
    try:
       domainRuntime()
       print 'domain runtime now'
    except:
       print 'Failed to execute domain runtime now '
    for name in serverNames:
      if (name.getName()).strip() == param_Server:
        try:
           cd("/ServerLifeCycleRuntimes/" + name.getName())
           serverState = cmo.getState()
           print 'Server name : ' + name.getName() 
        except:
           print 'Failed to execute cmo.getState '
        if serverState == "RUNNING":
            print 'Server ' + name.getName() + ' is :' + serverState + ' message from python scripts '
            return 500  
        elif serverState == "STARTING":
            print 'Server ' + name.getName() + ' is :' + serverState + ' message from python scripts '
            return -3  
        elif serverState == "UNKNOWN":
            print 'Server ' + name.getName() + ' is :' + serverState + '  message from python scripts'
            return -3  
        else:
            print 'Server ' + name.getName() + ' is :' + serverState + ' message from python scripts'
            return -4  
      else:
         print 'From else condition Server name :' + name.getName() + "==" + param_Server + "."

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def connect2admin_server():
  AdminURL = 't3://' + AdminHost +':' + AdminPorthttp

  LHostName= os.environ.get('HOSTNAME')

  #Connect to Admin Server
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print ' AdminServer http Connection Successful'
    return 0
  except:
    print 'AdminServer connect with http failed and trying with HTTPS'

  AdminURL = 't3s://' + AdminHost +':' + AdminPorthttps
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print ' AdminServer  Connection Successful'
    return 0
  except:
    print 'AdminServer connect with HTTPS also Failed '
    return -1

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

AdminHost=sys.argv[1]

AdminPorthttp=sys.argv[2]
AdminPorthttps=sys.argv[3]

AdminUserName=sys.argv[4]
AdminPswd=sys.argv[5]
msrvr=sys.argv[6] 

print "msrvr value in main code :" + msrvr

iretcode=0
iretcode=connect2admin_server()

if iretcode== -1:
   exit(exitcode=101)

##domainRuntime()
iretcode=0
iretcode=getHealth(msrvr)
serverConfig()
disconnect()
exit(str(iretcode))

##-------------------------------------------------------------------------
## END Program
##-------------------------------------------------------------------------

