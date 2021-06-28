#------------------------------------------------------------------
# File Name       : find_web_admin_server_status.py
# File Type       : python scripts
# Created on      : MAR-23-2021
# comments        : This scripts calls by bash program
# bash program calls by ruby code
#------------------------------------------------------------------
#
import os
import calendar
import sys, getopt

import smtplib

from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
  
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def getHealth(server):
   ##cd('/ServerRuntimes/' + server.getName())
   cd('/ServerRuntimes/' + server) 
   tState = cmo.getHealthState().getState()
   if (tState == 0):
     return 'OK'
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
 
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
##
##
GrandTotSessions=0 
AdminHost=sys.argv[1] 
AdminPort=sys.argv[2] 
AdminUserName=sys.argv[3] 
AdminPswd=sys.argv[4] 


LHostName= os.environ.get('HOSTNAME')

##AdminUserName =  'dappssystem'
##AdminPswd = 'dapps$2020'

##print "\n AdminPswd : " + AdminPswd + "\n"

AdminURL = 't3s://' + AdminHost +':' + AdminPort

try:
   #Connect to Admin Server
   connect(AdminUserName,AdminPswd, AdminURL )
   print 'RUNNING'
except:
   print 'DOWN'
   exit(exitcode=101)

##-------------------------------------------------------------------------


