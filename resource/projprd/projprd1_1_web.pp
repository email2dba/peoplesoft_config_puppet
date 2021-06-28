


$environ_name= 'projprd'
$domain_name= 'projprd1_1'
#
#

node "poeldapm01.company.com" {

   class {dappsapplserver::dapps_ps_web_server_creation:
         cfg_environ_name =>$environ_name,
         cfg_domain_name  =>$domain_name
   }

   class {dappsapplserver::dapps_ps_web_sslkey_copy:
         cfg_environ_name =>$environ_name,
         cfg_domain_name  =>$domain_name
   }

   class {dappsapplserver::dapps_ps_pia_configuration:
         cfg_environ_name =>$environ_name,
         cfg_domain_name  =>$domain_name
   }

##   class {dappsapplserver::dapps_ps_web_target_update:
##         cfg_environ_name =>$environ_name,
##         cfg_domain_name  =>$domain_name
##   }

}
