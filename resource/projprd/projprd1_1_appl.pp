/*
---------------------------------------------------------
Filename   : projprd1_1_appl.pp
Created by : Deenadayalan SENTHILNATHAN
Created on : 20210405
comments   :
---------------------------------------------------------
*/
## puppet module list   --confdir=./
##
#-------------Application server Domain information-----------

$environ_name= 'projprd'
$domain_name= 'projprd1_1'
#
#

node "poeldapm01.company.com" {
   class {dappsapplserver::dapps_ps_app_server:
         cfg_environ_name =>$environ_name,
         cfg_domain_name  =>$domain_name
   }
}
