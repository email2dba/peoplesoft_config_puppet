
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
    print ' Connection Successful' + "\n"  
    return 0
  except:
    print 'connect with http failed and trying with HTTPS'  + "\n"

  AdminURL = 't3s://' + AdminHost +':' + AdminPorthttps
  try:
    connect(AdminUserName,AdminPswd, AdminURL )
    print ' Connection Successful' + "\n"
    return 0
  except:
    print 'connect with HTTPS also Failed ' + "\n"
    return -1


##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

def beanExists( path, name):
  print "Checking if bean: '" + name + "' exists in path: '" + path + "'" + "\n"
  try:
     print "Path : " +path + "  verify" + "\n"
     cd(path)
  except:
     print "Path : " +path + "Doesnot exist" + "\n"
     return false
  setShowLSResult(0)
  beans = ls('c', 'false', 'c')
  setShowLSResult(1)
  if (beans.find(name) != -1):
    print "Exists" + "\n"
    return true
  else:
    print "Does not exist " + "\n"
    return false

##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
def DisplayProperties(originalBeanName, originalBeanPath,ignoredProperties):
  srcPath = originalBeanPath + "/" + originalBeanName
  print " properties from " + srcPath +" "  + "\n"
  try:
     print "MAIN CODE srcPath : " + srcPath + "  verify" + "\n"
     cd(srcPath)
     setShowLSResult(0)
     attributes = ls('a', 'true', 'a')
     children = ls('c', 'true', 'c')
     setShowLSResult(1)
     for entry in attributes.entrySet(): 
       k = entry.key
       v = entry.value  
       if not(k in ignoredProperties) and not(v is None) and not(v == '') and not(v == 'null '):
         print "Setting property " + str(k) + "=" + str(v) + "   " + "\n"
     for k in children:
       if not(k in ignoredProperties):
         srcBN = srcPath + "/" + k    
         print "Displaying bean " + srcBN + "/" + originalBeanName + "'" + "\n"
         print "Detected bean type as " + k + " " + "\n"
         if beanExists(srcBN, "NO_NAME_0"):      
           print "Changing to NO_NAME_0" + "\n"
           originalBeanName = "NO_NAME_0"
         DisplayProperties(originalBeanName, srcBN,ignoredProperties)
  except:
     print "MAIN CODE srcPath : " + srcPath + " Doesnot exist" + "\n"
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


##admin server error
if iretcode == -2:
  print ' FAILED : Admin server error  '
  exit(exitcode=102)

serverConfig()
iretcode=DisplayProperties(msrvr, '/Servers',['SSL'])

exit(exitcode=0)


