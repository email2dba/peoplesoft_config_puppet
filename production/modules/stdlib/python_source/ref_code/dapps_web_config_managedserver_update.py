

import os

#Please set eviroment before running this
#.  /psoft/pia/pia92/ndv/webserv/NDV_WEB11_1/bin/setEnv.sh 
#/apps/mwhome/weblogic/weblogic1213_dapps-web11/wlserver/common/bin/wlst.sh ./dapps_web_config_PIA_template.py
# 

AdminHost=sys.argv[1]
AdminPort=sys.argv[2]
AdminUserName=sys.argv[3]
AdminPswd=sys.argv[4]

msrvr=sys.argv[5]

connect('_ADMIN_ID_','_ADMIN_PWD_','_ADMIN_URL_')

#Connect to Admin Server
try:
  connect(AdminUserName,AdminPswd, AdminURL )
  print ' Connection Successful'
except:
   print ' Connection to admin server Failed '
   exit(exitcode=101)


edit()
startEdit()
cd('/')

cd ('/Servers/PIA')
set('ListenAddress','_LISTENADDR_')
set('ListenPortEnabled' , 'False') 

try:
  save()
  print ' Listener Updated'
except:
  print ' Listener Updation Failed'
  exit(exitcode=102)

cd('/Servers/'+msrvr)

##cmo.setCustomIdentityKeyStore("piaconfig/keystore/pskey") 
##cmo.setCustomTrustKeyStore("piaconfig/keystore/pskey") 

set('CustomIdentityKeyStorePassPhrase', '_IDN_KEYSTORE_PWD_')
set('CustomTrustKeyStorePassPhrase', '_TRST_KEYSTORE_PWD_')

cmo.setKeyStores('CustomIdentityAndCustomTrust')

#cmo.setCustomIdentityKeyStoreType('JKS')
#cmo.setCustomTrustKeyStoreType('JKS') 

try:
  save()
  print ' Keystore password Updated'
except:
  print ' Keystore password Updation Failed'
  exit(exitcode=103)

cd('/Servers/'+msrvr+'/SSL/'+msrvr)
cmo.setServerPrivateKeyAlias('_PRVT_KEY_ALIAS_')
set('ServerPrivateKeyPassPhrase', '_PRVT_KEY_PWD_')

try:
  save()
  print ' Private Key alias Updated'
except:
  print ' Private Key alias Updation Failed'
  exit(exitcode=103)

cd('/')
cd ('/AppDeployments/peoplesoft')
set('Targets',jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), ObjectName('com.bea:Name=PSEMHUB,Type=Server'), ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName))
save()

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments')
set('Targets',jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), ObjectName('com.bea:Name=PSEMHUB,Type=Server'), ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName))
save()


cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSEMHUB')
set('Targets',jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), ObjectName('com.bea:Name=PSEMHUB,Type=Server'), ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName))
save()

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSIGW')
set('Targets',jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), ObjectName('com.bea:Name=PSEMHUB,Type=Server'), ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName))
save()


cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSINTERLINKS')
set('Targets',jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), ObjectName('com.bea:Name=PSEMHUB,Type=Server'), ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName))
save()

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/pspc')
set('Targets',jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), ObjectName('com.bea:Name=PSEMHUB,Type=Server'), ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName))
save()

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/')
set('Targets',jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), ObjectName('com.bea:Name=PSEMHUB,Type=Server'), ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName))

try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=104)


try:
  activate()
  print ' Activation after all Updation successful'
except:
  print ' Activation after all Updation Failed'
  exit(exitcode=105)

exit()

