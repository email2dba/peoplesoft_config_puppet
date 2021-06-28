
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
    print 'AdminServer https Connection Successful'
    return 0
  except:
    print 'AdminServer connect with HTTPS also Failed '
    return -1


##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

#-------------------------------------------------------------------
# get_jarray4ManagedServers 
#-------------------------------------------------------------------
def get_jarray4ManagedServers(TotalPIA):
     print 'Inside get_jarray4ManagedServers. '
     if TotalPIA == "1":
        print 'Total PIA =1 PIA is Target Component '
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)
     if TotalPIA == "2":
        print 'Total PIA =2 PIA, PIA1 are Target Component '
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == "3":
        print 'Total PIA =3 PIA,PIA1,PIA2 is Target Component '
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == "4":
        print 'Total PIA =4 PIA ... PIA3 is Target Component '
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)


     if TotalPIA == "5":
        print 'Total PIA =5 i maxPIA4 is Target Component '
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == "6":
        print 'Total PIA =6  PIA .. PIA5 is Target Component '
        return jarray.array([ObjectName('com.bea:Name=PIA,Type=Server'), 
                ObjectName('com.bea:Name=PIA1,Type=Server'), 
                ObjectName('com.bea:Name=PIA2,Type=Server'), 
                ObjectName('com.bea:Name=PIA3,Type=Server'), 
                ObjectName('com.bea:Name=PIA4,Type=Server'), 
                ObjectName('com.bea:Name=PIA5,Type=Server'), 
                ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'), 
                ObjectName('com.bea:Name=PSEMHUB,Type=Server'), 
                ObjectName('com.bea:Name=RPS,Type=Server')], ObjectName)

     if TotalPIA == "7":
        print 'Total PIA =7 PIA .. PIA 6 is Target Component '
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
    

     if TotalPIA == "8":
        print 'Total PIA =8 PIA . . PIA7 are Target Component '
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

     if TotalPIA == "9":
        print 'Total PIA =9 PIA is Target Component '
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

     if TotalPIA == "10":
        print 'Total PIA =10 PIA is Target Component '
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

     if TotalPIA == "11":
        print 'Total PIA =11 PIA is Target Component '
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

     if TotalPIA == "12":
        print 'Total PIA =12 PIA is Target Component '
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

     if TotalPIA == "13":
        print 'Total PIA =13 PIA is Target Component '
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

     if TotalPIA == "14":
        print 'Total PIA =14 PIA is Target Component '
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


     if TotalPIA == "15":
        print 'Total PIA =15 PIA is Target Component '
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


     if TotalPIA == "16":
        print 'Total PIA =16 PIA is Target Component '
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


     if TotalPIA == "17":
        print 'Total PIA =17 PIA is Target Component '
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


     if TotalPIA == "18":
        print 'Total PIA =18 PIA is Target Component '
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
AdminHost=sys.argv[1]

AdminPorthttp=sys.argv[2]
AdminPorthttps=sys.argv[3]

AdminUserName=sys.argv[4]
AdminPswd=sys.argv[5]
TotalPIA=sys.argv[6]

#-------------------------------

#Connect to Admin Server
iretcode=0
iretcode=connect2admin_server()

#connection fail then exists
if iretcode == -1:
  print ' ADMIN_SERVER_ERROR Failed to connect admin server'
  exit(exitcode=101)


#-------------------------------
#find Total PIA is matching with existing PIAs
# Otherwise we will get null Java Object and we will get error.
#
try:
  tot_PIA_num = int(TotalPIA)
  tot_PIA_num =  tot_PIA_num - 1
  PIAName = 'PIA' + str(tot_PIA_num)
  print ' Verify PIA :' + PIAName + 'exists or not ' 
except:
  print ' ADMIN_SERVER_ERROR Failed to convert Total PIAs integer'
  exit(exitcode=104)


#find PIA is already exists or not
iretcode=isServerExists(PIAName)

##admin server error
if iretcode == -2:
  print 'ADMIN_SERVER_ERROR2  message from Python scripts'
  exit(exitcode=102)

## PIA is NOT available so exit
if iretcode != 1:
  print 'PIA_NOT_AVAILABLE  message from Python scripts'
  exit(exitcode=103)

#-------------------------------
#start update Target components

serverConfig()
edit()
startEdit()
  

##print ' PIA1 is cloning into PIA4'
##readDomain('DAPPSSTG1_1')
##clone('PIA1','PIA4','Server')
##print ' Cloning Completed'

cd('/')
cd ('/AppDeployments/peoplesoft')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' peoplesoft Target Component Updated'
except:
  print ' ADMIN_SERVER_ERROR peoplesoft Target Component Updation Failed'
  exit(exitcode=105)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print 'SubDeployments Target Component Updated'
except:
  print ' ADMIN_SERVER_ERROR SubDeployments Target Component Updation Failed'
  exit(exitcode=106)

cd ('/AppDeployments/peoplesoft/SubDeployments/PORTAL.war')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' PORTAL.war Target Component Updated'
except:
  print ' ADMIN_SERVER_ERROR PSEMHUB Target Component Updation Failed'
  exit(exitcode=107)

##THIS IS updating SubDeployments Root dir
##Donot delete
##cd ('/AppDeployments/peoplesoft/SubDeployments/')
##cd ('\/')
##set('Targets',get_jarray4ManagedServers(TotalPIA))

##try:
##  save()
##  print 'SubDeployments Target Component Updated'
##except:
##  print ' ADMIN_SERVER_ERROR SubDeployments Target Component Updation Failed'
##  exit(exitcode=106)


cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSEMHUB')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' PSEMHUB Target Component Updated'
except:
  print ' ADMIN_SERVER_ERROR PSEMHUB Target Component Updation Failed'
  exit(exitcode=107)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSIGW')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' PSIGW Target Component Updated'
except:
  print 'ADMIN_SERVER_ERROR PSIGW Target Component Updation Failed'
  exit(exitcode=108)


cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/PSINTERLINKS')
set('Targets',get_jarray4ManagedServers(TotalPIA))

try:
  save()
  print ' PSINTERLINKS Target Component Updated'
except:
  print ' ADMIN_SERVER_ERROR  PSINTERLINKS Target Component Updation Failed'
  exit(exitcode=109)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/pspc')
set('Targets',get_jarray4ManagedServers(TotalPIA))


try:
  save()
  print ' PSPC Target Component Updated'
except:
  print ' ADMIN_SERVER_ERROR PSPC Target Component Updation Failed'
  exit(exitcode=110)

cd('/')
cd ('/AppDeployments/peoplesoft/SubDeployments/')
set('Targets',get_jarray4ManagedServers(TotalPIA))


try:
  save()
  print ' AppDeployments/peoplesoft/SubDeployments Target Component Updated'
except:
  print ' ADMIN_SERVER_ERROR AppDeployments/peoplesoft/SubDeployments Target Component Updation Failed'
  exit(exitcode=111)


try:
  activate()
  print ' UPDATE_SUCCESSFUL Activation after all Updation of Target Component successful'
except:
  print ' ADMIN_SERVER_ERROR Activation after all Updation of Target Component Failed'
  exit(exitcode=112)

exit(exitcode=0)


