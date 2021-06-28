

import os

#Please set eviroment before running this
#.  /psoft/pia/pia92/ndv/webserv/NDV_WEB11_1/bin/setEnv.sh 
#/apps/mwhome/weblogic/weblogic1213_dapps-web11/wlserver/common/bin/wlst.sh ./dapps_web_config_PIA_template.py
# 

##connect('websystem','dapps$2020','t3://dapps-web11.dev.amsd.company.com:14081')
connect('_ADMIN_ID_','_ADMIN_PWD_','_ADMIN_URL_')


edit()
startEdit()
cd('/')

cd ('/Servers/PIA')
set('ListenAddress','_LISTENADDR_')
set('ListenPortEnabled' , 'False') 

save()

cd('/Servers/PIA')

##cmo.setCustomIdentityKeyStore("piaconfig/keystore/pskey") 
##cmo.setCustomTrustKeyStore("piaconfig/keystore/pskey") 

set('CustomIdentityKeyStorePassPhrase', '_IDN_KEYSTORE_PWD_')
set('CustomTrustKeyStorePassPhrase', '_TRST_KEYSTORE_PWD_')

cmo.setKeyStores('CustomIdentityAndCustomTrust')

#cmo.setCustomIdentityKeyStoreType('JKS')
#cmo.setCustomTrustKeyStoreType('JKS') 

save()

cd('/Servers/PIA/SSL/PIA')
cmo.setServerPrivateKeyAlias('_PRVT_KEY_ALIAS_')
set('ServerPrivateKeyPassPhrase', '_PRVT_KEY_PWD_')

save()

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
save()

activate()
exit()

