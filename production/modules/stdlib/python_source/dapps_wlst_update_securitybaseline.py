#-----------------------------------------------------------------
# File Name  : dapps_wlst_webconfig_updatesecuritybaseline.py
# Created on : 20210325
# Created by : Deena Senthilnathan
# Comments   : This program calls by dapps_wlst_webconfig_updatesecuritybaseline.bsh 
# During Peoplesoft web admin server creation, we have to update
# /AppDeployments/peoplesoft/SubDeployments "Target" value.
# This program is updating that "Target" value.
#-----------------------------------------------------------------
 
import os

AdminHost=sys.argv[1]
AdminPort=sys.argv[2]
AdminUserName=sys.argv[3]
AdminPswd=sys.argv[4]
#--------------------

LockoutDuration=sys.argv[5]
Lockout_resetDuration=sys.argv[6]
Lockput_Threshold=[7]

## we have set this value , but not sure where to update.
## keep it for referecnce
##Future_ID=
 
##
##connect('dappssystem','dapps$2020','t3s://doleldap001.bdc.ti.company.com:14083')
##

AdminURL='t3s://'+AdminHost:AdminPort' 

try:
  connect(AdminUserName,AdminPswd, AdminURL )
  print ' Connection Successful'
except:
   print ' Connection to admin server Failed '
   exit(exitcode=101)


edit()
startEdit()
domainName = cmo.getName()

#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
#1] configuration is enabling  default auditing features. Set WarningAuditSeverityEnabled to True

print 'DappsAudit  Creation Starts Here '

realm_path = '/SecurityConfiguration/'+domainName+'/Realms/'+'myrealm'

try:
   cd(realm_path+'/Auditors/DappsAudit')
   print 'Auditing DappsAudit already exists'
   print 'Not require to create DappsAudit'
except Exception, e:
   try:
      cd(realm_path+'/Auditors')
      cmo.createAuditor('DappsAudit','weblogic.security.providers.audit.DefaultAuditor')
      print 'DappsAudit has been added in domain : ' +  domainName
   except Exception, e:
           print e
           print 'DappsAudit  addition failed in domain : ' +  domainNamea + ' Programe continue...'
           undo( 'false', 'y')

try:
   cd(realm_path+'/Auditors/DappsAudit')
   set('WarningAuditSeverityEnabled' , Boolean(true)) 
   curBoolVal=get('WarningAuditSeverityEnabled') 
   print 'current value of WarningAuditSeverityEnabled in : DappsAudit ' + str(curBoolVal)
except Exception, e:
     print e
     print 'Reset value of WarningAuditSeverityEnabled Failed in : DappsAudit ' 
     undo( 'false', 'y')

#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
#2] Set 'Configuration Audit Type'  to 'Change Log and Audit'

print 'Configuration Audit Type parameter set value to [ Change Log and Audit ]'
try:
   cd ('/')
   set('ConfigurationAuditType' , 'logaudit')
   curStrVal=get('ConfigurationAuditType')
   print 'Current value ConfigurationAuditType : ' + curStrVal
except Exception, e:
     print e
     print 'Reset value of ConfigurationAuditType Failed ' 
     undo( 'false', 'y')

#set('ConfigurationAuditType' , 'none')

#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
#3] Configuration UserLockoutManager parameters [Duration,ResetDuration and Threshold ]

print 'Configuration UserLockoutManager parameters [Duration,ResetDuration and Threshold ] '
 
realm_path = '/SecurityConfiguration/'+domainName+'/Realms/'+'myrealm'
try: 
   cd(realm_path)
   cd ('UserLockoutManager/UserLockoutManager')
   set('LockoutDuration' , LockoutDuration)
   set('LockoutResetDuration' , Lockout_resetDuration )
   set('LockoutThreshold' , Lockput_Threshold )
   curNumVal1=get('LockoutDuration')
   curNumVal2=get('LockoutResetDuration')
   curNumVal3=get('LockoutThreshold')
   print 'Current value UserLockoutManager Duration | ResetDuration| Threshold : ' +  str(curNumVal1) + ' | ' +  str(curNumVal2)  + ' | ' +  str(curNumVal3)
except Exception, e:
     print e
     print 'Updation of UserLockoutManager Failed '
     undo( 'false', 'y')
#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
#4] Drop Defaults users  Admin, Deployer,Monitor and  Operator 

UsersList=[]
UsersList.append("Admin")
UsersList.append("Deployer")
UsersList.append("Monitor")
UsersList.append("Operator")

print 'Drop Defaults users   Admin, Deployer,Monitor and  Operator '
realm_path = '/SecurityConfiguration/'+domainName+'/Realms/'+'myrealm'
cd(realm_path)
cd ('AuthenticationProviders/DefaultAuthenticator')

for User2Delete in UsersList:
    #-------------------- User Deletion Begin --------------------
    try: 
       colBoolval1=cmo.userExists(User2Delete)
       print ' Default user ' + User2Delete + ' exists status : ' + str(colBoolval1)
       if colBoolval1 != 1:
          print ' Default user ' + User2Delete + ' already Deleted ' 
       else :
          try: 
             cmo.removeUser(User2Delete)
             print 'Default user ' + User2Delete + ' has been deleted '
          except Exception, e:
             print e
             print 'Default user ' + User2Delete + ' Deletion Failed'
             undo( 'false', 'y')
    except Exception, e:
      print e
      print ' Default user ' + User2Delete + ' : status Finding Failed and Program Continue  '  
      ##undo( 'false', 'y')
    #-------------------- User Deletion END --------------------

for Group2Delete in UsersList:
    #-------------------- Group Deletion Begin --------------------
    try: 
       colBoolval1=cmo.userExists(Group2Delete )
       print ' Default Group ' + Group2Delete + ' exists status : ' + str(colBoolval1)
       if colBoolval1 != 1:
          print ' Default Group ' + Group2Delete + ' already Deleted ' 
       else :
          try: 
             cmo.removeGroup(Group2Delete)
             print 'Default Group ' + Group2Delete + ' has been deleted '
          except Exception, e:
             print e
             print 'Default Group ' + Group2Delete + ' Deletion Failed'
             undo( 'false', 'y')
    except Exception, e:
      print e
      print ' Default Group ' + Group2Delete + ' : status Finding Failed and Program Continue  '  
    ##undo( 'false', 'y')
    #-------------------- Group Deletion END --------------------
#----------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------- 
#5] Enable Domain parameter 'Production Mode' . 
#
print ' Enable Domain parameter [Production Mode to True]' 

try: 
   cd('/')   
   set('ProductionModeEnabled', Boolean(true)) 
   curBoolVal=get('ProductionModeEnabled') 
   print 'current value of ProductionModeEnabled : ' + str(curBoolVal)
except Exception, e:
     print e
     print 'Reset value of ProductionModeEnabled is Failed ' 
     undo( 'false', 'y')
# 
#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------

try:
  save()
  print ' Security Baseline updation save Successful'
except:
  print ' Security Baseline updation save Failed'
  exit(exitcode=101)

try:
  activate()
  print ' activate Security Baseline updation Successful'
except:
  print ' activate Security Baseline updation Failed'
  exit(exitcode=101)

disconnect('true')

exit('y',0)
#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------

