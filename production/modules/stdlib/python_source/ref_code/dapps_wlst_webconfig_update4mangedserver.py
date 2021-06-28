
#-----------------------------------------------------------------
# File Name  : dapps_wlst_webconfig_update4mangedserver.py
# Created on : 20210325
# Created by : Deena Senthilnathan
# Comments   : This program calls by dapps_wlst_webconfig_update4mangedserver.bsh
# During Peoplesoft web admin server creation, we have to update 
# /AppDeployments/peoplesoft/SubDeployments "Target" value.
# This program is updating that "Target" value.
#-----------------------------------------------------------------

import os

AdminHost=sys.argv[1]
AdminPort=sys.argv[2]
AdminUserName=sys.argv[3]
AdminPswd=sys.argv[4]

msrvr=sys.argv[5]

ListenerAddr=sys.argv[6]

IdentityKeyStorePwd=sys.argv[7]
TrustKeyStorePwd=sys.argv[8]

PrivateKeyAlias=sys.argv[9]
PrivateKeyPwd=sys.argv[10]
TotalPIA=sys.argv[11]

#-------------------------------------------------------------------
# get_jarray4ManagedServers 
#-------------------------------------------------------------------
def get_jarray4ManagedServers(TotalPIA):
     if TotalPIA == 1 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)
     if TotalPIA == 2 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 3 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 4 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)


     if TotalPIA == 5 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 6 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 7 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)
    

     if TotalPIA == 8 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 9 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 10 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 11 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 12 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=PIA11,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 13 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=PIA11,Type=Server'), 
                ObjectName('com.bea:Name=PIA12,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == 14 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=PIA11,Type=Server'), 
                ObjectName('com.bea:Name=PIA12,Type=Server'), 
                ObjectName('com.bea:Name=PIA13,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)


     if TotalPIA == 15 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=PIA11,Type=Server'), 
                ObjectName('com.bea:Name=PIA12,Type=Server'), 
                ObjectName('com.bea:Name=PIA13,Type=Server'), 
                ObjectName('com.bea:Name=PIA14,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)


     if TotalPIA == 16 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=PIA11,Type=Server'), 
                ObjectName('com.bea:Name=PIA12,Type=Server'), 
                ObjectName('com.bea:Name=PIA13,Type=Server'), 
                ObjectName('com.bea:Name=PIA14,Type=Server'), 
                ObjectName('com.bea:Name=PIA15,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)


     if TotalPIA == 17 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=PIA11,Type=Server'), 
                ObjectName('com.bea:Name=PIA12,Type=Server'), 
                ObjectName('com.bea:Name=PIA13,Type=Server'), 
                ObjectName('com.bea:Name=PIA14,Type=Server'), 
                ObjectName('com.bea:Name=PIA15,Type=Server'), 
                ObjectName('com.bea:Name=PIA16,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)


     if TotalPIA == 18 :
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=PIA6,Type=Server'), 
                ObjectName('com.bea:Name=PIA7,Type=Server'), 
                ObjectName('com.bea:Name=PIA8,Type=Server'), 
                ObjectName('com.bea:Name=PIA9,Type=Server'), 
                ObjectName('com.bea:Name=PIA10,Type=Server'), 
                ObjectName('com.bea:Name=PIA11,Type=Server'), 
                ObjectName('com.bea:Name=PIA12,Type=Server'), 
                ObjectName('com.bea:Name=PIA13,Type=Server'), 
                ObjectName('com.bea:Name=PIA14,Type=Server'), 
                ObjectName('com.bea:Name=PIA15,Type=Server'), 
                ObjectName('com.bea:Name=PIA16,Type=Server'), 
                ObjectName('com.bea:Name=PIA17,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
             ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
             ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
             ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

#-------------------------------------------------------------------

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

cd ('/Servers/'+msrvr)
set('ListenAddress',ListenerAddr)
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

set('CustomIdentityKeyStorePassPhrase', IdentityKeyStorePwd)
set('CustomTrustKeyStorePassPhrase', TrustKeyStorePwd)

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
cmo.setServerPrivateKeyAlias(PrivateKeyAlias)
set('ServerPrivateKeyPassPhrase', PrivateKeyPwd)

try:
  save()
  print ' Private Key alias Updated'
except:
  print ' Private Key alias Updation Failed'
  exit(exitcode=104)

cd('/')
cd ('/AppDeployments/peoplesoft')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=105)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=106)


cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSEMHUB')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=107)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSIGW')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=108)


cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSINTERLINKS')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=109)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/pspc')
set('Targets',get_jarray4ManagedServers(TotalPIA))


try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=110)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/')
set('Targets',get_jarray4ManagedServers(TotalPIA))


try:
  save()
  print ' Target Component Updated'
except:
  print ' Target Component Updation Failed'
  exit(exitcode=111)


try:
  activate()
  print ' Activation after all Updation successful'
except:
  print ' Activation after all Updation Failed'
  exit(exitcode=112)

exit(exitcode=0)


