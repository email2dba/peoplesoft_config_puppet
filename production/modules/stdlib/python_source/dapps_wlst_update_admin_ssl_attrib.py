
#-----------------------------------------------------------------
# File Name  : dapps_wlst_webconfig_update4mangedserver.py
# Created on : 20210325
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
    print ' AdminServer http Connection Successful'
    return 0
  except:
    print 'AdminServer connect with http failed and trying with HTTPS'

  AdminURL = 't3s://' + AdminHost +':' + AdminPorthttps
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print ' AdminServer https Connection Successful'
    return 0
  except:
    print 'AdminServer connect with HTTPS also Failed '
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
def get_ssl_attrib_status(msrvr):
  try:
    ##serverRuntime()
    serverConfig()
    cd('/Servers/'+msrvr)
    tmp_key_store = get('KeyStores')

    ##cd('/Servers/'+msrvr+'/SSL/'+msrvr)
    ##tmp_https_port = get('ListenPort')
    ##print 'current https port : ' + str(tmp_https_port) + ' message from python scripts'
    print 'current key store location  value found in admin server message from python scripts'
    print 'current key store location  : ' + tmp_key_store + ' message from python scripts'

    ##if tmp_https_port != int(https_port):
    if tmp_key_store != "CustomIdentityAndCustomTrust":
      ##print 'https port not matching with catalog value, so we should configure now'
      print 'Current value in console ' + tmp_key_store + ' but expected CustomIdentityAndCustomTrust '
      print 'CustomIdentityAndCustomTrust NOT Set, so we should configure now'
      return -1
    else:
      print 'CustomIdentityAndCustomTrust Set, so Configuration Not Require'
      return 0
  except:
    print ' May Be Null so we should configure now'
    return -1
  return 0

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def ssl_attrib_updation(msrvr):
  # start in edit mode
  edit()
  startEdit()
  cd('/')
  #-----PIA server location---------
  cd ('/Servers/'+msrvr)

  #-----update default values-------


  print 'KeyStores = CustomIdentityAndCustomTrust'
  cmo.setKeyStores('CustomIdentityAndCustomTrust')

  print 'CustomIdentityKeyStoreType = JKS'
  set('CustomIdentityKeyStoreType' , 'JKS')

  print 'CustomTrustKeyStoreType = JKS'
  set('CustomTrustKeyStoreType' , 'JKS')


  print 'CustomTrustKeyStoreFileName = piaconfig/keystore/pskey'
  set('CustomTrustKeyStoreFileName', 'piaconfig/keystore/pskey')

  print 'CustomIdentityKeyStoreFileName = piaconfig/keystore/pskey'
  set('CustomIdentityKeyStoreFileName', 'piaconfig/keystore/pskey')

  ##set('VirtualMachineName' , 'DAPPSSTG1_1_PIA')

  #-----update custom values-------

  print 'ListenAddress updation'
  set('ListenAddress',ListenerAddr)

  print 'ListenPort  updation '
  set('ListenPort', http_port)

  print 'ListenPortEnabled updation'
  set('ListenPortEnabled' , 'True')

  try:
    save()
    print ' Listener Updated'
  except:
    print ' Listener Updation Failed'
    return 102

  print 'CustomIdentityKeyStore password updation'
  set('CustomIdentityKeyStorePassPhrase', IdentityKeyStorePwd)

  print 'CustomTrustKeyStore password updation'
  set('CustomTrustKeyStorePassPhrase', TrustKeyStorePwd)

  try:
    save()
    print ' CustomIdentity and CustomTrust Keystore password Updated'
  except:
    print ' CustomIdentity and CustomTrust Keystore password Updation Failed'
    return 103

  print 'PrivateKeyAlias updation'

  cd('/Servers/'+msrvr+'/SSL/'+msrvr)
  set('Enabled', 'True')
  set('ListenPort', https_port)

  cmo.setServerPrivateKeyAlias(PrivateKeyAlias)
  set('ServerPrivateKeyPassPhrase', PrivateKeyPwd)

  try:
    save()
    print 'PIA server Private Key alias Updated'
  except:
    print ' PIA server Private Key alias Updation Failed'
    return 104
  #--------------------------------------------------------------
  print ' Activation after all Updation'

  try:
    activate()
    print ' Activation after all Updation successful'
  except:
    print ' Activation after all Updation Failed'
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

ListenerAddr=sys.argv[7]
http_port=sys.argv[8]
https_port=sys.argv[9]

IdentityKeyStorePwd=sys.argv[10]
TrustKeyStorePwd=sys.argv[11]

PrivateKeyAlias=sys.argv[12]
PrivateKeyPwd=sys.argv[13]

print ' PIA NAME : ' + msrvr + ' . Configuration script invoked. Message from pythonscript'

print ' ListenerAddr=       ' + ListenerAddr
print ' http_port=          ' + http_port
print ' https_port=         ' + https_port

print ' IdentityKeyStorePwd=' + IdentityKeyStorePwd
print ' TrustKeyStorePwd=   ' + TrustKeyStorePwd

print ' PrivateKeyAlias=    ' + PrivateKeyAlias
print ' PrivateKeyPwd=      ' + PrivateKeyPwd

#-------------------------------

#Connect to Admin Server
iretcode=0
iretcode=connect2admin_server()

#connection fail then exists
if iretcode == -1:
  print 'ADMIN_SERVER_ERROR1  message from Python scripts'
  exit(exitcode=101)

#-------------------------------
##verify Config require or not

iretcode=get_ssl_attrib_status(msrvr)
if iretcode == 0:
  print 'UPDATION_NOT_REQUIRE  message from Python scripts'
  exit(exitcode=0)

#update PIA SSL attributes
iretcode=ssl_attrib_updation(msrvr)

## error during updation
if iretcode != 0:
  print 'UPDATION_FAILED  message from Python scripts'
  exit(exitcode=104)

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
print 'UPDATION_SUCCESSFUL: message from Python scripts'
exit(exitcode=0)

