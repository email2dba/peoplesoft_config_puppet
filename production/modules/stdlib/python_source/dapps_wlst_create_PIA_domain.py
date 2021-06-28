
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
    print 'PIA name : ' + param_Server + ' isServerExists : verification starts '
    serverConfig()
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
    print 'PIA name : ' + param_Server + ' not found '
    return -1
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def get_jarray4ManagedServers(tot_str_msrvr):

   ret_arry_out = []
 
   pia_srvr_list = tot_str_msrvr.split(",")

   print 'Inside get_jarray4ManagedServers. '

   ret_arry_out.append(ObjectName('com.bea:Name=PIA,Type=Server'))
   ret_arry_out.append(ObjectName('com.bea:Name=WebLogicAdmin,Type=Server'))

   for ii in range(len(pia_srvr_list)):
     msrvr = pia_srvr_list[ii]
     print  'PIA name : ' + msrvr + ' adding into deployment array'
     obj_str_text = "com.bea:Name=" + msrvr +",Type=Server"
     ret_arry_out.append(ObjectName(obj_str_text))

   print ' All PIAs are added into array'
   print ' PSEMHUB to be added here'
   ret_arry_out.append(ObjectName('com.bea:Name=PSEMHUB,Type=Server'))
   ret_arry_out.append(ObjectName('com.bea:Name=RPS,Type=Server'))

   print 'All Objects are added here now send jarary'

   return jarray.array(ret_arry_out, ObjectName)
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def UpdateDeploymentTargets():

  print 'before created java array'
  java_arr_target=get_jarray4ManagedServers(tot_str_msrvr)
  print 'after created java array'
  serverConfig()
  edit()
  startEdit()
  cd('/')
  cd ('/AppDeployments/peoplesoft')
  set('Targets',java_arr_target)

  cd('/AppDeployments/peoplesoft/SubDeployments/PORTAL.war')
  set('Targets',java_arr_target)

  cd('/AppDeployments/peoplesoft/SubDeployments/PSIGW')
  set('Targets',java_arr_target)

  cd('/AppDeployments/peoplesoft/SubDeployments/PSINTERLINKS')
  set('Targets',java_arr_target)

  cd('/AppDeployments/peoplesoft/SubDeployments/PSEMHUB')
  set('Targets',java_arr_target)

  cd('/AppDeployments/peoplesoft/SubDeployments/pspc')
  set('Targets',java_arr_target)

  try:
    save()
    print ' Update Deployment Targets saved  '
  except:
    print ' Update Deployment Targets save Failed'
    return 104
  ##--------------------------------------------------------------
  print ' Activation after PIA creation'

  try:
    activate()
    print ' Activation after Update Deployment Targets successful'
  except:
    print ' Activation after Update Deployment Targets Failed'
    return 201
  return 0

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def CreatePIADomin(msrvr):

  servername = msrvr
  logfilename1 = './logs/' + msrvr + '_weblogic.log'
  logfilename2 = './logs/' + msrvr + '_access.log'

  edit()
  startEdit()
  cd('/')
  #-----PIA server creation--------
  print " PIA server " + msrvr + " creation"
  ##cmo.createServer(msrvr)

  cmo.createServer(msrvr)

  print ' Default valus are setting for PS managed server'
  cd('/')
  cd('Servers')
  cd(servername)

  set('IIOPEnabled', 'false')
  set('GracefulShutdownTimeout',30)
  set('MSIFileReplicationEnabled', 'true')
  set('CustomIdentityKeyStoreType', 'JKS')
  set('CustomTrustKeyStoreType', 'JKS')
  set('StagingMode', 'nostage')
  set('UploadDirectoryName', './upload')
  set('StagingDirectoryName', './stage')
  set('CustomIdentityKeyStoreFileName', 'piaconfig/keystore/pskey')
  set('CustomTrustKeyStoreFileName', 'piaconfig/keystore/pskey')

  set('JavaCompiler', 'javac')
  set('ManagedServerIndependenceEnabled', 'true')
  set('InstrumentStackTraceEnabled', 'true')


  print ' SSL MBean creation for PS managed server'
  cd('/')
  cd('Servers')
  cd(servername)
  ##create(servername, 'SSL')

  print ' Log MBean creation for PS managed server'
  cd('/')
  cd('Servers')
  cd(servername)
  ##Logs=create(servername, 'Log')

  cd('Log')
  cd(servername)
  set('FileName', logfilename1)
  set('LogFileSeverity', 'Info')
  set('RedirectStdoutToServerLogEnabled', 'true')


  print ' WebServer MBean creation for PS managed server'

  cd('/')
  cd('Servers')
  cd(servername)
  ##create(servername, 'WebServer')
  cd('WebServer')
  cd(servername)
  set('HttpsKeepAliveSecs', 120)

  print ' WebServerLog MBean creation for PS managed server'

  cd('/')
  cd('Servers')
  cd(servername)
  cd('WebServer')
  cd(servername)
  ##create(servername, 'WebServerLog')
  cd('WebServerLog')
  cd(servername)
  set('FileName', logfilename2)

  print ' ExecuteQueues MBean creation for PS managed server'
  cd('/')
  cd('Servers')
  cd(servername)
  ##create(servername, 'ExecuteQueues')
  ##cd('ExecuteQueues')
  ##cd(servername)
  create('weblogic.kernel.Default', 'ExecuteQueues')
  cd('ExecuteQueues')
  cd('weblogic.kernel.Default')
  ##set('Name', 'default')
  set('ThreadCount', 50)


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

tot_str_msrvr=sys.argv[6]

#------------------------------------------------------
pia_srvr_list = tot_str_msrvr.split(",")


#Connect to Admin Server
iretcode=0
iretcode=connect2admin_server()

if iretcode == -1:
  exit(exitcode=101)

#------------------------------------------------------
# PIA Creation starts here
for ii in range(len(pia_srvr_list)):

  msrvr = pia_srvr_list[ii]
  #find PIA is already exists or not
  iretcode=isServerExists(msrvr)

  ##admin server error
  if iretcode == -2:
     print  'PIA name : ' + msrvr + ' FAILED : Admin server error during creation '
     exit(exitcode=102)

  ## PIA is already exists
  if iretcode == 1:
    print  'PIA name : ' + msrvr + 'PIA ALREADY_EXISTS message from python scripts  '
  else:
    print  'PIA name : ' + msrvr + ' creation method calls here  message from python scripts  '
    iretcode = 0
    iretcode=CreatePIADomin(msrvr)
    if iretcode != 0:
      print  'PIA name : ' + msrvr +  ' FAILED : Falied during PIA creation. message from python scripts  '
      exit(str(iretcode))
    else:
      print 'PIA name : ' + msrvr + ' CREATED successfully : message from python scripts  '

#------------------------------------------------------
# PIA Creation finished and we can set Deployments
# set Deployments Starts here

UpdateDeploymentTargets()

if iretcode !=0 :
  exit(exitcode=101)

##------------------------------------------------------------
##Do not delete this print CREATED message.
##it is expected in bash profile (parent program)
##------------------------------------------------------------
print ' PIA CREATED : message from python scripts  '

exit(exitcode=0)

