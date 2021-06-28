
#-----------------------------------------------------------------
# File Name  : dapps_wlst_create_PIA_domain.py
# Created on : 20210408
# Created by : Deena Senthilnathan
# Comments   : 
#-----------------------------------------------------------------

import os


##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def connect2admin_server():

  AdminURL = 't3://' + AdminHost +':' + AdminPorthttp

  LHostName= os.environ.get('HOSTNAME')

  #Connect to Admin Server
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print ' Connection Successful'
    return 0
  except:
    print 'connect with http failed and trying with HTTPS'

  AdminURL = 't3s://' + AdminHost +':' + AdminPorthttps
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print ' Connection Successful'
    return 0
  except:
    print 'connect with HTTPS also Failed '
    return -1


##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def isServerExists(param_Server):
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
           return -2
        if serverState == "RUNNING":
            print 'Server exists and status ' + serverState + ' '
            return 1
        elif serverState == "STARTING":
            print 'Server exists and status ' + serverState + ' '
            return 1
        elif serverState == "UNKNOWN":
            print 'Server exists and status ' + serverState + ' '
            return 1
        else:
            print 'Server exists and status ' + serverState + ' '
            return 1
    return -1
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

def CreatePIADomin():

  edit()
  startEdit()
  cd('/')
  #-----PIA server creation--------
  print " PIA server " + msrvr + "creation"
  cmo.createServer(msrvr)
  try:
    save()
    print ' PIA server created and saved  '
  except:
    print ' PIA server created but save Failed'
    return 104
  #--------------------------------------------------------------
  print ' Activation after PIA creation'

  try:
    activate()
    print ' Activation after PIA creation successful'
  except:
    print ' Activation after PIA creation Failed'
    return 201
  return 0
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
AdminHost=sys.argv[1]

AdminPorthttp=sys.argv[2]
AdminPorthttps=sys.argv[3]

AdminUserName=sys.argv[4]
AdminPswd=sys.argv[5]

msrvr=sys.argv[6]

#------------------------------------------------------

#Connect to Admin Server
iretcode=0
iretcode=connect2admin_server()

if iretcode == -1:
  exit(exitcode=101)

#find PIA is already exists or not
iretcode=isServerExists(msrvr)

##admin server error
if iretcode == -2:
  print ' FAILED : Admin server error  '
  exit(exitcode=102)

## PIA is already exists
if iretcode == 1:
  print 'PIA ALREADY_EXISTS message from python scripts  '
  exit(exitcode=103)

iretcode=CreatePIADomin()

if iretcode != 0:
  print ' FAILED : Falied during PIA creation. message from python scripts  '
  exit(str(iretcode))

#------------------------------------------------------
  
print ' PIA CREATED : message from python scripts  '

exit(exitcode=0)

