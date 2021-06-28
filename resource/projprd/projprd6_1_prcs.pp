##To execute use this command
##
##puppet apply projprd6_1_prcs.pp  --confdir=./  --debug >./logs/pslog.log
##
##
#-------------Process Server Information-----------------------
$environ_name= 'projprd'
$domain_name= 'projprd6_1'


#------------- END value assignemnt-----------------------------

node "poeldapm06.company.com" {
   class {dappsapplserver::dapps_ps_prcs_server:
         cfg_environ_name =>$environ_name,
         cfg_domain_name  =>$domain_name
   }
}
