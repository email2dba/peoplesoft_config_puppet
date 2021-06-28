##
##----------------------------------------------------
## File name  : prv001_dapps_config_app_server.rb
## Created on : 20210407 
## Created by : Deenadayalan SENTHILNATHAN
## comments   : 
##----------------------------------------------------
require 'fileutils'
require 'open3'

Puppet::Type.type(:dapps_config_app_server).provide(:prv001_dapps_config_app_server) do

   commands :dapps_psadmin => 'echo'
   commands :getlist       => 'grep'
   commands :fileremove    => 'rm'

   mk_resource_methods

   #--------------------------------------------------
   #get_value4key()
   #--------------------------------------------------
   def get_value4key(keyname, key_val_arr )
     for keyval_str in key_val_arr do
        attrib_arr = keyval_str.split("=")
        if attrib_arr[0] == keyname
             return attrib_arr[1]
        end
      end
      return "zzz"
   end
   #--------------------------------------------------
   #get_value4keyx2()
   #--------------------------------------------------
   def get_value4key2(keyname, key_val_arr )
     #key_val_arr.length()
     last_char="x"
     for keyval_str in key_val_arr do
        Puppet.debug(" keyval_str : #{keyval_str}")
        strlen = keyval_str.size
        lastposch= keyval_str[-1..-1]

        Puppet.debug(" lastposch : #{lastposch}")
        if keyval_str[-1..-1] == "="
          last_char="z"
        end
        attrib_arr = keyval_str.split("=")
        if attrib_arr[0] == keyname
          if last_char == "x"
             Puppet.debug(" RETURN   keyval_str : #{keyval_str}")
             return attrib_arr[1]
          else
             retstr = attrib_arr[1] + "="
             Puppet.debug(" RETURN 2  keyval_str : #{keyval_str}")
             return retstr
          end
        end
      end
      return "zzz"
   end
   
   #--------------------------------------------------
   # get_decrypt_str(encr_string)
   #--------------------------------------------------
   def get_decrypt_str(encr_string)
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:scripts_location] )

       env_action_cmd  = lcl_bash_fle_location + "/get_decrypt_str.bsh \"" +  encr_string + "\" "
       command_output = execute_command(env_action_cmd, true)
       Puppet.debug(" get_decrypt_str output: #{command_output}")
       command_output
   end



   #--------------------------------------------------
   #make_startup_attrib_str()
   #--------------------------------------------------
   def make_startup_attrib_str()
       Puppet.alert(" make_startup_attrib_str:  attribute string creation begin")
       lcl_startup_attr_arr =  resource[:startup_attrib]
       lcl_domain_attr_arr  =  resource[:domain_attrib]
       lcl_pwd_attr_arr     =  resource[:pwd_attrib]

       #DBNAME  DBTYPE
       out_str = " '" + get_value4key("dbname", lcl_startup_attr_arr) + "%" +  get_value4key("dbtype", lcl_startup_attr_arr)
       #OPRID  OPRPWD
       out_str += "%" + get_value4key("userid", lcl_startup_attr_arr) + "%" + get_decrypt_str(get_value4key2("pwd_userpswd", lcl_pwd_attr_arr))
       #DomainID  Add_to_path

       out_str += "%" + get_value4key("domainid", lcl_domain_attr_arr) +  "%"  + get_value4key("addtopath", lcl_domain_attr_arr)

       #DBConnectID  DB_CNCT_PASSWORD
       attrib_arr = lcl_pwd_attr_arr[2].split("=")
       out_str += "%"+ get_value4key("connectid", lcl_startup_attr_arr) + "%" +  get_decrypt_str(get_value4key2("pwd_connectpswd", lcl_pwd_attr_arr))

       #servername  domain connection pwd
       out_str += "%"+"_____" + "%"+ get_decrypt_str( get_value4key2("pwd_domainconnectionpwd", lcl_pwd_attr_arr))

       #SEC_principal_password     ENABLE_REMOTE_ADMIN
       out_str += "%%1"
       # REMOTE_ADMIN_PORT REMOTE_ADMIN_USRID   REMOTE_ADMIN_PSWD
       out_str += "%" +  get_value4key("remoteadminport", resource[:pstools_attrib] )  + "%" +  get_value4key("remoteadminuserid", resource[:pstools_attrib] ) 
       #   REMOTE_ADMIN_PSWD
       out_str += "%" + get_decrypt_str( get_value4key2("remoteadminpassword", resource[:pstools_attrib]  ))
       #ENCRYPT
       out_str += "%"+"ENCRYPT" + "' "
       Puppet.debug(" make_startup_attrib_str: #{out_str}")
       Puppet.alert(" make_startup_attrib_str:  attribute string creation end")
       out_str
   end


   #------------------------------------
   #make_config_attrib_str()
   #--------------------------------------------------

   def make_config_attrib_str()
        Puppet.alert(" make_config_attrib_str:  attribute string creation begin")

        lcl_startup_attr_arr  =  resource[:startup_attrib]
        lcl_domain_attr_arr   =  resource[:domain_attrib]
        lcl_pwd_attr_arr      =  resource[:pwd_attrib]
        lcl_psappsrv_attr_arr =  resource[:psappsrv_attrib]
        lcl_port_attr_arr =  resource[:listeners_port]

        out_str = " '"
        #[Domain Settings] Domain ID
        out_str += "[Domain Settings]/Domain ID=" +  get_value4key("domainid", lcl_domain_attr_arr) + "#"

        #[Domain Settings] Allow Dynamic Changes
        out_str += "[Domain Settings]/Allow Dynamic Changes=" + get_value4key("allowdynamicchanges", lcl_domain_attr_arr ) + "#"

        #PSAPPSRV min instances
        #out_str += "PSAPPSRV]/Min Insances=" + get_value4key("mininstances", lcl_psappsrv_attr_arr) + "#"

        #PSAPPSRV max instances
        #out_str += "[PSAPPSRV]/Max Insances=" + get_value4key("maxinstances", lcl_psappsrv_attr_arr) + "#"

        #PSAPPSRV Max Fetch Size
        #out_str += "[PSAPPSRV]/Max Fetch Size=" + get_value4key("maxfetchsize", lcl_psappsrv_attr_arr) + "#"

        #JOLT Listener
        ##commented by deena out_str += "[JOLT Listener]/Port=" + get_value4key("joltlistener_jslport", lcl_port_attr_arr) + "#"

        #JOLT Address
        ##keep Default value : out_str += "[JOLT Listener]/Address=" + "0.0.0.0"+ "#"

        #JOLT Min Handlers
        out_str += "[JOLT Listener]/Min Handlers=" + get_value4key("minhandlers",  resource[:jolt_attrib]  ) + "#" 

        #JOLT Max Handlers
        out_str += "[JOLT Listener]/Max Handlers=" + get_value4key("maxhandlers",  resource[:jolt_attrib]  ) + "#" 

        #[Workstation Listener]Min Handlers
        out_str += "[Workstation Listener]/Min Handlers=" + get_value4key("minhandlers",  resource[:workstation_attrib]  ) + "#" 

        #[Workstation Listener] Miax Handlers
        out_str += "[Workstation Listener]/Max Handlers=" + get_value4key("maxhandlers",  resource[:workstation_attrib]  ) + "#" 

        #PSTOOLS DbFlags
        out_str += "[PSTOOLS]/DbFlags=" + get_value4key("dbflags", resource[:pstools_attrib] ) + "#"
        #PSTOOLS :EnablePPM Agent=1
        out_str += "[PSTOOLS]/EnablePPM Agent=" + get_value4key("enableppmagent", resource[:pstools_attrib] ) + "#"

        #[PSSAMSRV] Min Instances
        out_str += "[PSSAMSRV]/Min Instances=" + get_value4key("pssamsrv_mininstances", resource[:procs_attrib] ) + "#"
        #[PSSAMSRV] Min Instances
        out_str += "[PSSAMSRV]/Max Instances=" + get_value4key("pssamsrv_maxinstances", resource[:procs_attrib] ) + "#"

        #[PSQCKSRV] Min Instances
        out_str += "[PSQCKSRV]/Min Instances=" + get_value4key("psqcksrv_mininstances", resource[:procs_attrib] ) + "#"
        #[PSQCKSRV] Min Instances
        out_str += "[PSQCKSRV]/Max Instances=" + get_value4key("psqcksrv_maxinstances", resource[:procs_attrib] ) + "#"

        #[PSQRYSRV] Min Instances
        out_str += "[PSQRYSRV]/Min Instances=" + get_value4key("mininstances", resource[:psqrysrv_attrib] ) + "#"
        #[PSQCKSRV] Max Instances
        out_str += "[PSQRYSRV]/Max Instances=" + get_value4key("maxinstances", resource[:psqrysrv_attrib] ) + "#"

        #[PSMONITORSRV] JVM Options
        out_str += "[PSMONITORSRV]/JavaVM Options=" + get_value4key("javavmoptions", resource[:psmonitorsrv_attrib] ) + "#"


        #[PSRENSRV]  default_http_port
        out_str += "[PSRENSRV]/default_http_port=" + get_value4key("default_http_port", resource[:psrensrv_attrib] ) + "#"
        #[PSRENSRV]   default_https_port
        out_str += "[PSRENSRV]/default_https_port=" + get_value4key("default_https_port", resource[:psrensrv_attrib] ) + "#"
        #[PSRENSRV]   default_auth_token
        out_str += "[PSRENSRV]/default_auth_token=" + get_value4key("default_auth_token", resource[:psrensrv_attrib] ) + "#"

        #[Database Options] EnableDBMonitoring
        out_str += "[Database Options]/EnableDBMonitoring=" + get_value4key("msln_dboptions_enabledbmonitoring", resource[:msln_attrib] ) + "#"

        ###-----------------IB config Begining----------------------------------------
        ###--------------psbrkdsp_dflt_attrib----------1------------------------------
        if get_value4key("recyclecount", resource[:psbrkdsp_dflt_attrib] ) != "zzz"

           Puppet.debug('[PSBRKDSP_dflt] Begin')
           #[PSBRKDSP_dflt]/Recycle Count
           out_str += "[PSBRKDSP_dflt]/Recycle Count=" + get_value4key("recyclecount", resource[:psbrkdsp_dflt_attrib] ) + "#"

           #[PSBRKDSP_dflt]/Allowed Consec Service Failures
           out_str += "[PSBRKDSP_dflt]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:psbrkdsp_dflt_attrib] ) + "#"

           #[PSBRKDSP_dflt]/Dispatch List Multiplier
           out_str += "[PSBRKDSP_dflt]/Dispatch List Multiplier=" + get_value4key("dispatch_list_multiplier", resource[:psbrkdsp_dflt_attrib] ) + "#"

           #[PSBRKDSP_dflt]/Scan Interval
           out_str += "[PSBRKDSP_dflt]/Scan Interval=" + get_value4key("scan_interval", resource[:psbrkdsp_dflt_attrib] ) + "#"

           #[PSBRKDSP_dflt]/Dispatcher Queue Max Queue Size
           out_str += "[PSBRKDSP_dflt]/Dispatcher Queue Max Queue Size=" + get_value4key("dispatcher_queue_max_queue_size", resource[:psbrkdsp_dflt_attrib] ) + "#"

           #[PSBRKDSP_dflt]/Memory Queue Refresh rate
           out_str += "[PSBRKDSP_dflt]/Memory Queue Refresh rate=" + get_value4key("memory_queue_refresh_rate", resource[:psbrkdsp_dflt_attrib] ) + "#"

           #[PSBRKDSP_dflt]/Restart Period
           out_str += "[PSBRKDSP_dflt]/Restart Period=" + get_value4key("restart_period", resource[:psbrkdsp_dflt_attrib] ) + "#"
        else
           Puppet.debug('[PSBRKDSP_dflt] no information found')
        end
        ###-----------------psbrkhnd_dflt_attrib---------2------------------------------
        if get_value4key("maxinstances", resource[:psbrkhnd_dflt_attrib] ) != "zzz"
           Puppet.debug('[PSBRKHND_dflt] Begin')
           #[PSBRKHND_dflt]/Min Instances
           out_str += "[PSBRKHND_dflt]/Min Instances=" + get_value4key("mininstances", resource[:psbrkhnd_dflt_attrib] ) + "#"

           #[PSBRKHND_dflt]/Max Instances
           out_str += "[PSBRKHND_dflt]/Max Instances=" + get_value4key("maxinstances", resource[:psbrkhnd_dflt_attrib] ) + "#"

           #[PSBRKHND_dflt]/Service Timeout
           out_str += "[PSBRKHND_dflt]/Service Timeout=" + get_value4key("servicetimeout", resource[:psbrkhnd_dflt_attrib] ) + "#"

           #[PSBRKHND_dflt]/Recycle Count
           out_str += "[PSBRKHND_dflt]/Recycle Count=" + get_value4key("recyclecount", resource[:psbrkhnd_dflt_attrib] ) + "#"

           #[PSBRKHND_dflt]/Allowed Consec Service Failures
           out_str += "[PSBRKHND_dflt]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:psbrkhnd_dflt_attrib] ) + "#"

           #[PSBRKHND_dflt]/Max Retries
           out_str += "[PSBRKHND_dflt]/Max Retries=" + get_value4key("maxretries", resource[:psbrkhnd_dflt_attrib] ) + "#"
        else
           Puppet.debug('[PSBRKHND_dflt] no information found')
        end

        ###------------------pssubdsp_dflt---------3------------------------------
        if get_value4key("recyclecount", resource[:pssubdsp_dflt_attrib] ) != "zzz"
           Puppet.debug('[PSSUBDSP_dflt] Begin')
           #[PSSUBDSP_dflt]/Recycle Count
           out_str += "[PSSUBDSP_dflt]/Recycle Count=" + get_value4key("recyclecount", resource[:pssubdsp_dflt_attrib] ) + "#"

           #[PSSUBDSP_dflt]/Allowed Consec Service Failures
           out_str += "[PSSUBDSP_dflt]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pssubdsp_dflt_attrib] ) + "#"

           #[PSSUBDSP_dflt]/Dispatch List Multiplier
           out_str += "[PSSUBDSP_dflt]/Dispatch List Multiplier=" + get_value4key("dispatch_list_multiplier", resource[:pssubdsp_dflt_attrib] ) + "#"

           #[PSSUBDSP_dflt]/Scan Interval
           out_str += "[PSSUBDSP_dflt]/Scan Interval=" + get_value4key("scan_interval", resource[:pssubdsp_dflt_attrib] ) + "#"

           #[PSSUBDSP_dflt]/Dispatcher Queue Max Queue Size
           out_str += "[PSSUBDSP_dflt]/Dispatcher Queue Max Queue Size=" + get_value4key("dispatcher_queue_max_queue_size", resource[:pssubdsp_dflt_attrib] ) + "#"

           #[PSSUBDSP_dflt]/Memory Queue Refresh rate
           out_str += "[PSSUBDSP_dflt]/Memory Queue Refresh rate=" + get_value4key("memory_queue_refresh_rate", resource[:pssubdsp_dflt_attrib] ) + "#"

           #[PSSUBDSP_dflt]/Restart Period
           out_str += "[PSSUBDSP_dflt]/Restart Period=" + get_value4key("restart_period", resource[:pssubdsp_dflt_attrib] ) + "#"
        else
           Puppet.debug('[PSSUBDSP_dflt] no information found')
        end

        ###-----------------pssubhnd_dflt_attrib---------4------------------------------
        if get_value4key("maxinstances", resource[:pssubhnd_dflt_attrib] ) != "zzz"
           Puppet.debug('[PSSUBHND_dflt] Begin')
           #[PSSUBHND_dflt]/Min Instances
           out_str += "[PSSUBHND_dflt]/Min Instances=" + get_value4key("mininstances", resource[:pssubhnd_dflt_attrib] ) + "#"

           #[PSSUBHND_dflt]/Max Instances
           out_str += "[PSSUBHND_dflt]/Max Instances=" + get_value4key("maxinstances", resource[:pssubhnd_dflt_attrib] ) + "#"

           #[PSSUBHND_dflt]/Service Timeout
           ##out_str += "[PSSUBHND_dflt]/Service Timeout=" + get_value4key("servicetimeout", resource[:pssubhnd_dflt_attrib] ) + "#"

           #[PSSUBHND_dflt]/Recycle Count
           ##out_str += "[PSSUBHND_dflt]/Recycle Count=" + get_value4key("recyclecount", resource[:pssubhnd_dflt_attrib] ) + "#"

           #[PSSUBHND_dflt]/Allowed Consec Service Failures
           ##out_str += "[PSSUBHND_dflt]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pssubhnd_dflt_attrib] ) + "#"

           #[PSSUBHND_dflt]/Max Retries
           ##out_str += "[PSSUBHND_dflt]/Max Retries=" + get_value4key("maxretries", resource[:pssubhnd_dflt_attrib] ) + "#"
        else
           Puppet.debug('[PSSUBHND_dflt] no information found')
        end
        ###------------------pssubdsp_dflt---------5------------------------------
        if get_value4key("recyclecount", resource[:pspubdsp_dflt_attrib] ) != "zzz"
           Puppet.alert('[PSPUBDSP_dflt] Begin')
           #[PSPUBDSP_dflt]/Recycle Count
           out_str += "[PSPUBDSP_dflt]/Recycle Count=" + get_value4key("recyclecount", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Allowed Consec Service Failures
           out_str += "[PSPUBDSP_dflt]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Dispatch List Multiplier
           out_str += "[PSPUBDSP_dflt]/Dispatch List Multiplier=" + get_value4key("dispatch_list_multiplier", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Scan Interval
           out_str += "[PSPUBDSP_dflt]/Scan Interval=" + get_value4key("scan_interval", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Ping Rate
           out_str += "[PSPUBDSP_dflt]/Ping Rate=" + get_value4key("ping_rate", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Maximum Ping Interval
           out_str += "[PSPUBDSP_dflt]/Maximum Ping Interval=" + get_value4key("maximum_ping_interval", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Dispatcher Queue Max Queue Size
           out_str += "[PSPUBDSP_dflt]/Dispatcher Queue Max Queue Size=" + get_value4key("dispatcher_queue_max_queue_size", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Memory Queue Refresh rate
           out_str += "[PSPUBDSP_dflt]/Memory Queue Refresh rate=" + get_value4key("memory_queue_refresh_rate", resource[:pspubdsp_dflt_attrib] ) + "#"

           #[PSPUBDSP_dflt]/Restart Period
           out_str += "[PSPUBDSP_dflt]/Restart Period=" + get_value4key("restart_period", resource[:pspubdsp_dflt_attrib] ) + "#"
        else
           Puppet.debug('[PSPUBDSP_dflt] no information found')
        end

        ###-----------------pspubhnd_dflt_attrib---------6------------------------------
        if get_value4key("maxinstances", resource[:pspubhnd_dflt_attrib] ) != "zzz"
           Puppet.debug('[PSPUBHND_dflt] Begin')
           #[PSPUBHND_dflt]/Min Instances
           out_str += "[PSPUBHND_dflt]/Min Instances=" + get_value4key("mininstances", resource[:pspubhnd_dflt_attrib] ) + "#"

           #[PSPUBHND_dflt]/Max Instances
           out_str += "[PSPUBHND_dflt]/Max Instances=" + get_value4key("maxinstances", resource[:pspubhnd_dflt_attrib] ) + "#"

           #[PSPUBHND_dflt]/Service Timeout
           out_str += "[PSPUBHND_dflt]/Service Timeout=" + get_value4key("servicetimeout", resource[:pspubhnd_dflt_attrib] ) + "#"

           #[PSPUBHND_dflt]/Recycle Count
           out_str += "[PSPUBHND_dflt]/Recycle Count=" + get_value4key("recyclecount", resource[:pspubhnd_dflt_attrib] ) + "#"

           #[PSPUBHND_dflt]/Allowed Consec Service Failures
           out_str += "[PSPUBHND_dflt]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pspubhnd_dflt_attrib] ) + "#"

           #[PSPUBHND_dflt]/Thread Pool Size
           out_str += "[PSPUBHND_dflt]/Thread Pool Size=" + get_value4key("thread_pool_size", resource[:pspubhnd_dflt_attrib] ) + "#"


           #[PSPUBHND_dflt]/Max Retries
           out_str += "[PSPUBHND_dflt]/Max Retries=" + get_value4key("maxretries", resource[:pspubhnd_dflt_attrib] ) + "#"
        else
           Puppet.debug('[PSPUBHND_dflt] no information found')
        end

        ###------------------psbrkdsp_cnfdsp_attrib---------7------------------------------
        if get_value4key("recyclecount", resource[:psbrkdsp_cnfdsp_attrib] ) != "zzz"
           Puppet.debug('[PSBRKDSP_CNFDSP] Begin')
           #[PSBRKDSP_CNFDSP]/Recycle Count
           out_str += "[PSBRKDSP_CNFDSP]/Recycle Count=" + get_value4key("recyclecount", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"

           #[PSBRKDSP_CNFDSP]/Allowed Consec Service Failures
           out_str += "[PSBRKDSP_CNFDSP]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"

           #[PSBRKDSP_CNFDSP]/Dispatch List Multiplier
           out_str += "[PSBRKDSP_CNFDSP]/Dispatch List Multiplier=" + get_value4key("dispatch_list_multiplier", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"

           #[PSBRKDSP_CNFDSP]/Scan Interval
           out_str += "[PSBRKDSP_CNFDSP]/Scan Interval=" + get_value4key("scan_interval", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"

           #[PSBRKDSP_CNFDSP]/Dispatcher Queue Max Queue Size
           out_str += "[PSBRKDSP_CNFDSP]/Dispatcher Queue Max Queue Size=" + get_value4key("dispatcher_queue_max_queue_size", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"

           #[PSBRKDSP_CNFDSP]/Memory Queue Refresh rate
           out_str += "[PSBRKDSP_CNFDSP]/Memory Queue Refresh rate=" + get_value4key("memory_queue_refresh_rate", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"

           #[PSBRKDSP_CNFDSP]/Restart Period
           out_str += "[PSBRKDSP_CNFDSP]/Restart Period=" + get_value4key("restart_period", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"

           #[PSBRKDSP_CNFDSP]/Queues
           out_str += "[PSBRKDSP_CNFDSP]/Queues=" + get_value4key("queues", resource[:psbrkdsp_cnfdsp_attrib] ) + "#"
        else
           Puppet.debug('[PSBRKDSP_CNFDSP] no information found')
        end

        ###-----------------psbrkhnd_cnfdsp_attrib---------8------------------------------

        Puppet.alert('[PSBRKHND_CNFDSP] BEFORE  Begin')
        
        if get_value4key("maxinstances", resource[:psbrkhnd_cnfdsp_attrib] ) != "zzz"
           Puppet.debug('[PSBRKHND_CNFDSP] Begin')
           #[PSBRKHND_CNFDSP]/Min Instances
           out_str += "[PSBRKHND_CNFDSP]/Min Instances=" + get_value4key("mininstances", resource[:psbrkhnd_cnfdsp_attrib] ) + "#"

           #[PSBRKHND_CNFDSP]/Max Instances
           out_str += "[PSBRKHND_CNFDSP]/Max Instances=" + get_value4key("maxinstances", resource[:psbrkhnd_cnfdsp_attrib] ) + "#"

           #[PSBRKHND_CNFDSP]/Service Timeout
           out_str += "[PSBRKHND_CNFDSP]/Service Timeout=" + get_value4key("servicetimeout", resource[:psbrkhnd_cnfdsp_attrib] ) + "#"

           #[PSBRKHND_CNFDSP]/Recycle Count
           out_str += "[PSBRKHND_CNFDSP]/Recycle Count=" + get_value4key("recyclecount", resource[:psbrkhnd_cnfdsp_attrib] ) + "#"

           #[PSBRKHND_CNFDSP]/Allowed Consec Service Failures
           out_str += "[PSBRKHND_CNFDSP]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:psbrkhnd_cnfdsp_attrib] ) + "#"

           #[PSBRKHND_CNFDSP]/Max Retries
           out_str += "[PSBRKHND_CNFDSP]/Max Retries=" + get_value4key("maxretries", resource[:psbrkhnd_cnfdsp_attrib] ) + "#"
        else
           Puppet.alert('[PSBRKHND_CNFDSP] no information found')
        end
        ###------------------pssubdsp_cnfsub_attrib---------9------------------------------
        if get_value4key("recyclecount", resource[:pssubdsp_cnfsub_attrib] ) != "zzz"
           Puppet.debug('[PSSUBDSP_CNFSUB] Begin')
           #[PSSUBDSP_CNFSUB]/Recycle Count
           out_str += "[PSSUBDSP_CNFSUB]/Recycle Count=" + get_value4key("recyclecount", resource[:pssubdsp_cnfsub_attrib] ) + "#"

           #[PSSUBDSP_CNFSUB]/Allowed Consec Service Failures
           out_str += "[PSSUBDSP_CNFSUB]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pssubdsp_cnfsub_attrib] ) + "#"

           #[PSSUBDSP_CNFSUB]/Dispatch List Multiplier
           out_str += "[PSSUBDSP_CNFSUB]/Dispatch List Multiplier=" + get_value4key("dispatch_list_multiplier", resource[:pssubdsp_cnfsub_attrib] ) + "#"

           #[PSSUBDSP_CNFSUB]/Scan Interval
           out_str += "[PSSUBDSP_CNFSUB]/Scan Interval=" + get_value4key("scan_interval", resource[:pssubdsp_cnfsub_attrib] ) + "#"

           #[PSSUBDSP_CNFSUB]/Dispatcher Queue Max Queue Size
           out_str += "[PSSUBDSP_CNFSUB]/Dispatcher Queue Max Queue Size=" + get_value4key("dispatcher_queue_max_queue_size", resource[:pssubdsp_cnfsub_attrib] ) + "#"

           #[PSSUBDSP_CNFSUB]/Memory Queue Refresh rate
           out_str += "[PSSUBDSP_CNFSUB]/Memory Queue Refresh rate=" + get_value4key("memory_queue_refresh_rate", resource[:pssubdsp_cnfsub_attrib] ) + "#"

           #[PSSUBDSP_CNFSUB]/Restart Period
           out_str += "[PSSUBDSP_CNFSUB]/Restart Period=" + get_value4key("restart_period", resource[:pssubdsp_cnfsub_attrib] ) + "#"

           #[PSSUBDSP_CNFSUB]/Queues
           out_str += "[PSSUBDSP_CNFSUB]/Queues=" + get_value4key("queues", resource[:pssubdsp_cnfsub_attrib] ) + "#"
        else
           Puppet.alert('[PSSUBDSP_CNFSUB] no information found')
        end

        ###-----------------pssubhnd_cnfsub_attrib---------10-----------------------------
        if get_value4key("maxinstances", resource[:pssubhnd_cnfsub_attrib] ) != "zzz"
           Puppet.debug('[PSSUBHND_CNFSUB] Begin')
           #[PSSUBHND_CNFSUB]/Min Instances
           out_str += "[PSSUBHND_CNFSUB]/Min Instances=" + get_value4key("mininstances", resource[:pssubhnd_cnfsub_attrib] ) + "#"

           #[PSSUBHND_CNFSUB]/Max Instances
           out_str += "[PSSUBHND_CNFSUB]/Max Instances=" + get_value4key("maxinstances", resource[:pssubhnd_cnfsub_attrib] ) + "#"

           #[PSSUBHND_CNFSUB]/Service Timeout
           ##out_str += "[PSSUBHND_CNFSUB]/Service Timeout=" + get_value4key("servicetimeout", resource[:pssubhnd_cnfsub_attrib] ) + "#"

           #[PSSUBHND_CNFSUB]/Recycle Count
           ##out_str += "[PSSUBHND_CNFSUB]/Recycle Count=" + get_value4key("recyclecount", resource[:pssubhnd_cnfsub_attrib] ) + "#"

           #[PSSUBHND_CNFSUB]/Allowed Consec Service Failures
           ##out_str += "[PSSUBHND_CNFSUB]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pssubhnd_cnfsub_attrib] ) + "#"

           #[PSSUBHND_CNFSUB]/Max Retries
           ##out_str += "[PSSUBHND_CNFSUB]/Max Retries=" + get_value4key("maxretries", resource[:pssubhnd_cnfsub_attrib] ) + "#"
        else
           Puppet.alert('[PSSUBHND_CNDSUB] no information found')
        end
        ###------------------psbrkdsp_mftdsp_attrib---------11------------------------------
        if get_value4key("recyclecount", resource[:psbrkdsp_mftdsp_attrib] ) != "zzz"
           Puppet.debug('[PSBRKDSP_MFTDSP] Begin')
           #[PSBRKDSP_MFTDSP]/Recycle Count
           out_str += "[PSBRKDSP_MFTDSP]/Recycle Count=" + get_value4key("recyclecount", resource[:psbrkdsp_mftdsp_attrib] ) + "#"

           #[PSBRKDSP_MFTDSP]/Allowed Consec Service Failures
           out_str += "[PSBRKDSP_MFTDSP]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:psbrkdsp_mftdsp_attrib] ) + "#"

           #[PSBRKDSP_MFTDSP]/Dispatch List Multiplier
           out_str += "[PSBRKDSP_MFTDSP]/Dispatch List Multiplier=" + get_value4key("dispatch_list_multiplier", resource[:psbrkdsp_mftdsp_attrib] ) + "#"

           #[PSBRKDSP_MFTDSP]/Scan Interval
           out_str += "[PSBRKDSP_MFTDSP]/Scan Interval=" + get_value4key("scan_interval", resource[:psbrkdsp_mftdsp_attrib] ) + "#"

           #[PSBRKDSP_MFTDSP]/Dispatcher Queue Max Queue Size
           out_str += "[PSBRKDSP_MFTDSP]/Dispatcher Queue Max Queue Size=" + get_value4key("dispatcher_queue_max_queue_size", resource[:psbrkdsp_mftdsp_attrib] ) + "#"

           #[PSBRKDSP_MFTDSP]/Memory Queue Refresh rate
           out_str += "[PSBRKDSP_MFTDSP]/Memory Queue Refresh rate=" + get_value4key("memory_queue_refresh_rate", resource[:psbrkdsp_mftdsp_attrib] ) + "#"

           #[PSBRKDSP_MFTDSP]/Restart Period
           out_str += "[PSBRKDSP_MFTDSP]/Restart Period=" + get_value4key("restart_period", resource[:psbrkdsp_mftdsp_attrib] ) + "#"

           #[PSBRKDSP_MFTDSP]/Queues
           out_str += "[PSBRKDSP_MFTDSP]/Queues=" + get_value4key("queues", resource[:psbrkdsp_mftdsp_attrib] ) + "#"
        else
           Puppet.alert('[PSBRKDSP_MFTDSP] no information found')
        end
        ###-----------------psbrkhnd_mftdsp_attrib---------12-----------------------------
        if get_value4key("maxinstances", resource[:psbrkhnd_mftdsp_attrib] ) != "zzz"
           Puppet.debug('[PSBRKHND_MFTDSP] Begin')
           #[PSBRKHND_MFTDSP]/Min Instances
           out_str += "[PSBRKHND_MFTDSP]/Min Instances=" + get_value4key("mininstances", resource[:psbrkhnd_mftdsp_attrib] ) + "#"

           #[PSBRKHND_MFTDSP]/Max Instances
           out_str += "[PSBRKHND_MFTDSP]/Max Instances=" + get_value4key("maxinstances", resource[:psbrkhnd_mftdsp_attrib] ) + "#"

           #[PSBRKHND_MFTDSP]/Service Timeout
           out_str += "[PSBRKHND_MFTDSP]/Service Timeout=" + get_value4key("servicetimeout", resource[:psbrkhnd_mftdsp_attrib] ) + "#"

           #[PSBRKHND_MFTDSP]/Recycle Count
           out_str += "[PSBRKHND_MFTDSP]/Recycle Count=" + get_value4key("recyclecount", resource[:psbrkhnd_mftdsp_attrib] ) + "#"

           #[PSBRKHND_MFTDSP]/Allowed Consec Service Failures
           out_str += "[PSBRKHND_MFTDSP]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:psbrkhnd_mftdsp_attrib] ) + "#"

           #[PSBRKHND_MFTDSP]/Max Retries
           out_str += "[PSBRKHND_MFTDSP]/Max Retries=" + get_value4key("maxretries", resource[:psbrkhnd_mftdsp_attrib] ) + "#"
        else
           Puppet.alert('[PSBRKHND_MFTDSP] no information found')
        end

        ###------------------pspubdsp_mftpub_attrib---------13------------------------------
        if get_value4key("recyclecount", resource[:pspubdsp_mftpub_attrib] ) != "zzz"
           Puppet.debug('[PSPUBDSP_MFTPUB] Begin')
           #[PSPUBDSP_MFTPUB]/Recycle Count
           out_str += "[PSPUBDSP_MFTPUB]/Recycle Count=" + get_value4key("recyclecount", resource[:pspubdsp_mftpub_attrib] ) + "#"

           #[PSPUBDSP_MFTPUB]/Allowed Consec Service Failures
           out_str += "[PSPUBDSP_MFTPUB]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pspubdsp_mftpub_attrib] ) + "#"

           #[PSPUBDSP_MFTPUB]/Dispatch List Multiplier
           out_str += "[PSPUBDSP_MFTPUB]/Dispatch List Multiplier=" + get_value4key("dispatch_list_multiplier", resource[:pspubdsp_mftpub_attrib] ) + "#"

           #[PSPUBDSP_MFTPUB]/Scan Interval
           out_str += "[PSPUBDSP_MFTPUB]/Scan Interval=" + get_value4key("scan_interval", resource[:pspubdsp_mftpub_attrib] ) + "#"

           #[PSPUBDSP_MFTPUB]/Dispatcher Queue Max Queue Size
           out_str += "[PSPUBDSP_MFTPUB]/Dispatcher Queue Max Queue Size=" + get_value4key("dispatcher_queue_max_queue_size", resource[:pspubdsp_mftpub_attrib] ) + "#"

           #[PSPUBDSP_MFTPUB]/Memory Queue Refresh rate
           out_str += "[PSPUBDSP_MFTPUB]/Memory Queue Refresh rate=" + get_value4key("memory_queue_refresh_rate", resource[:pspubdsp_mftpub_attrib] ) + "#"

           #[PSPUBDSP_MFTPUB]/Restart Period
           out_str += "[PSPUBDSP_MFTPUB]/Restart Period=" + get_value4key("restart_period", resource[:pspubdsp_mftpub_attrib] ) + "#"

           #[PSPUBDSP_MFTPUB]/Queues
           out_str += "[PSPUBDSP_MFTPUB]/Queues=" + get_value4key("queues", resource[:pspubdsp_mftpub_attrib] ) + "#"
        else
           Puppet.alert('[PSPUBDSP_MFTPUB] no information found')
        end

        ###-----------------pspubhnd_mftpub_attrib---------14-----------------------------
        if get_value4key("maxinstances", resource[:pspubhnd_mftpub_attrib] ) != "zzz"
           Puppet.debug('[PSPUBHND_MFTPUB] Begin')
           #[PSPUBHND_MFTPUB]/Min Instances
           out_str += "[PSPUBHND_MFTPUB]/Min Instances=" + get_value4key("mininstances", resource[:pspubhnd_mftpub_attrib] ) + "#"

           #[PSPUBHND_MFTPUB]/Max Instances
           out_str += "[PSPUBHND_MFTPUB]/Max Instances=" + get_value4key("maxinstances", resource[:pspubhnd_mftpub_attrib] ) + "#"

           #[PSPUBHND_MFTPUB]/Service Timeout
           out_str += "[PSPUBHND_MFTPUB]/Service Timeout=" + get_value4key("servicetimeout", resource[:pspubhnd_mftpub_attrib] ) + "#"

           #[PSPUBHND_MFTPUB]/Recycle Count
           out_str += "[PSPUBHND_MFTPUB]/Recycle Count=" + get_value4key("recyclecount", resource[:pspubhnd_mftpub_attrib] ) + "#"

           #[PSPUBHND_MFTPUB]/Allowed Consec Service Failures
           out_str += "[PSPUBHND_MFTPUB]/Allowed Consec Service Failures=" + get_value4key("allowedconsecservicefailures", resource[:pspubhnd_mftpub_attrib] ) + "#"

           #[PSPUBHND_MFTPUB]/Max Retries
           out_str += "[PSPUBHND_MFTPUB]/Max Retries=" + get_value4key("maxretries", resource[:pspubhnd_mftpub_attrib] ) + "#"

           #[PSPUBHND_MFTPUB]/Thread Pool Size
           out_str += "[PSPUBHND_MFTPUB]/Thread Pool Size=" + get_value4key("thread_pool_size", resource[:pspubhnd_mftpub_attrib] ) + "#"
        else
           Puppet.alert('[PSPUBHND_MFTPUB] no information found')
        end

        ###-----------------IB config Finished-------------------------

        ###--------------smtp_attrib----------1------------------------------
        #[SMTP Settings]  SMTPServer
        out_str += "[SMTP Settings]/SMTPServer=" + get_value4key("smtpserver", resource[:smtp_attrib] ) + "#"
        #[SMTP Settings] SMTPPort 
        out_str += "[SMTP Settings]/SMTPPort=" + get_value4key("smtpport", resource[:smtp_attrib] ) + "#"

        #[SMTP Settings]  SMTPSender
        out_str += "[SMTP Settings]/SMTPSender=" + get_value4key("smtpsender", resource[:smtp_attrib] ) + "#"
        #[SMTP Settings]  SMTPSourceMachine
        out_str += "[SMTP Settings]/SMTPSourceMachine=" + get_value4key("smtpsourcemachine", resource[:smtp_attrib] )  

        ###-----------------ALL config Finished-------------------------
        out_str += "' "
        Puppet.alert(" make_config_attrib_str:  attribute string creation End")

        Puppet.debug("  make_config_attrib_str: #{out_str}")
        out_str
   end

   #--------------------------------------------------
   # make_port_attrib_str
   #--------------------------------------------------
   def make_port_attrib_str()
      Puppet.alert(" make_port_attrib_str:  attribute string creation begin")
      lcl_port_attr_arr      =  resource[:listeners_port]
      #WSL Port
      out_str =  get_value4key("workstation_listenerport", lcl_port_attr_arr)  + "%"
      #JSL Port
      out_str +=  get_value4key("joltlistener_jslport", lcl_port_attr_arr) + "%"

      #JRAD Port
      out_str +=  get_value4key("joltrelayadapter_listenerport", lcl_port_attr_arr)
      Puppet.debug("  make_port_attrib_str: #{out_str}")
      Puppet.alert(" make_config_attrib_str:  attribute string creation end")
      out_str
   end

   #--------------------------------------------------
   # make_feature_attrib_str
   #--------------------------------------------------
   def make_feature_attrib_str()
      out_str =  " '"+ resource[:feature_settings_str] + "' "
      Puppet.debug(" make_feature_attrib_str: #{out_str}")
      out_str
   end
   #--------------------------------------------------
   # create_resource
   #--------------------------------------------------

   def create_resource
       Puppet.alert(" create_resource: application server creation started")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:scripts_location] )
       lcl_startup_attr_arr   =  resource[:startup_attrib]
       lcl_domain_attr_arr    =  resource[:domain_attrib]
       lcl_ps_location_arr    =  resource[:ps_location]

       envir_name =  get_value4key("dbname", lcl_startup_attr_arr).downcase
       domain_name =  get_value4key("domainname", lcl_domain_attr_arr).upcase

       env_action_cmd  = lcl_bash_fle_location + "/psadmin_app_server_creation.bsh  "
       env_action_cmd += " '" +  get_value4key("psft_env_sh_location",  resource[:scripts_location] )  +"' " + envir_name
       env_action_cmd += " " + domain_name
       env_action_cmd += " " + get_value4key("msln_template", resource[:msln_attrib] )
       env_action_cmd += " " + make_startup_attrib_str()
       env_action_cmd += " " + make_port_attrib_str()
       command_output = execute_command(env_action_cmd, true)
       Puppet.debug(" create_resource: #{command_output}")
       Puppet.alert(" create_resource:  application server creation end")
       command_output
   end

   #--------------------------------------------------
   # psadmin_app_server_config_updation
   #--------------------------------------------------
   def add_update_resource_attrib
       Puppet.alert(" add_update_resource_attrib:  appserver custom configuration begin")
       lcl_bash_fle_location  = get_value4key("bash_file_location",  resource[:scripts_location] )
       lcl_startup_attr_arr   = resource[:startup_attrib]
       lcl_domain_attr_arr    = resource[:domain_attrib]
       lcl_ps_location_arr    = resource[:ps_location]

       envir_name =  get_value4key("dbname", lcl_startup_attr_arr).downcase
       domain_name =  get_value4key("domainname", lcl_domain_attr_arr).upcase

       env_action_cmd  = lcl_bash_fle_location + "/psadmin_app_server_config_updation.bsh  "
       env_action_cmd += " '" +  get_value4key("psft_env_sh_location",  resource[:scripts_location] )  +"' " + envir_name
       env_action_cmd += " " + domain_name
       env_action_cmd += " " + make_config_attrib_str()
       env_action_cmd += " " + make_feature_attrib_str()
       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" add_update_resource_attrib: #{command_output}")
       Puppet.alert(" add_update_resource_attrib:  appserver custom configuration end")
       command_output
   end

   #--------------------------------------------------
   # get_dbname_from_psappssrv_cfg_file
   #--------------------------------------------------
   def get_dbname_from_psappssrv_cfg_file
     outstr = " "
     begin
     lcl_domain_attr_arr  =  resource[:domain_attrib]
     domain_name =  get_value4key("domainname", lcl_domain_attr_arr).upcase
     lps_app_srv_cfg_fle =   get_value4key("ps_config_home",  resource[:ps_location] )   + "/appserv/" + domain_name + "/psappsrv.cfg"
     outstr = getlist(['-E', 'DBName', lps_app_srv_cfg_fle])
     rescue Puppet::ExecutionFailure => e
        Puppet.debug("errorin get list file  -> #{e.inspect}")
        return nil
     else
     Puppet.debug("db_name found: #{outstr}")
     end
     Puppet.debug("END get_dbname_from_psappssrv_cfg_file: #{outstr}")
     return outstr
   end

   #--------------------------------------------------
   # execute_command
   #--------------------------------------------------

   def execute_command(command, mask_pwd = false)
     Puppet.debug("Executing command: #{command}")
     out_str = ''
     error_str = ''
     begin
       Open3.popen3(command) do |stdin, out, err|
         stdin.close
         error_str = err.read
         out_str = out.read
         out_str = out_str + '' + error_str
         if mask_pwd
           Puppet.debug('Command executed successfully')
         else
           Puppet.debug("Command executed successfully output  #{out_str}, Error: #{error_str}")
         end
       end
     rescue Exception => e
          raise Puppet::ExecutionFailure, "Command execution failed, error: #{e.message} "
     end
     return out_str
   end
   #--------------------------------------------------
   # psappsrv.cfg configFileExists
   #--------------------------------------------------
   def configFileExists
      Puppet.debug('configFileExists Begin')
      lcl_domain_attr_arr  =  resource[:domain_attrib]
      domain_name =  get_value4key("domainname", lcl_domain_attr_arr).upcase
      lps_app_srv_cfg_dir = get_value4key("ps_config_home", resource[:ps_location] )  + "/appserv/" +  domain_name

      File.exist?(lps_app_srv_cfg_dir)
   end
   #--------------------------------------------------
   # exists
   #--------------------------------------------------

   def exists?
      Puppet.debug("Method : exists? ")
      #configFileExists()
      return false
   end

   #--------------------------------------------------
   # destroy
   #--------------------------------------------------

   def destroy
      Puppet.debug("begin: destroy ")
      lcl_domain_attr_arr  =  resource[:domain_attrib]
      domain_name =  get_value4key("domainname", lcl_domain_attr_arr).upcase
      lps_app_srv_cfg_dir = get_value4key("ps_config_home", resource[:ps_location] )  + "/appserv/" +  domain_name

      if File.exist?(lps_app_srv_cfg_dir)
         Puppet.debug("Removing apps server domain directory: #{lps_app_srv_cfg_dir}")
         FileUtils.rm_rf(lps_app_srv_cfg_dir)
      end
      @property_hash[:ensure] = :absent
      ###@property_flush.clear
      Puppet.debug("end: destroy ")
   end


   #--------------------------------------------------
   # create
   #--------------------------------------------------

   def create
    Puppet.debug("begin: create ")
    if (configFileExists())
      Puppet.debug("Method : CREATE method already executed in previous run ")
    else
      create_resource()
    end
    add_update_resource_attrib()
    @property_hash[:ensure] = :present
    ##@property_hash[:startup_attrib] = get_psconfig_attribute("[Startup]", "dbnamedbtypeuseridconnectid")
    ##@property_hash[:startup_attrib] = get_psconfig_attribute()
    Puppet.debug("end: create ")
   end

   #--------------------------------------------------
   # get_psconfig_attribute to get startup_attrib
   #--------------------------------------------------
   def get_psconfig_attribute(groupid, groupattriblist)
       Puppet.debug(" BEGIN get_psconfig_attribute: ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:scripts_location] )
       lcl_startup_attr_arr   =  resource[:startup_attrib]
       lcl_domain_attr_arr    =  resource[:domain_attrib]
       lcl_ps_location_arr    =  resource[:ps_location]

       envir_name =  get_value4key("dbname", lcl_startup_attr_arr).downcase
       domain_name =  get_value4key("domainname", lcl_domain_attr_arr).upcase

       env_action_cmd  = lcl_bash_fle_location + "/get_psconfig_attribute.bsh  "
       env_action_cmd += " " + get_value4key("ps_config_home",  resource[:ps_location] ) +" " + envir_name
       env_action_cmd += " app " + domain_name + " " + groupid + " " + groupattriblist
       ##env_action_cmd += " [Startup] dbnamedbtypeuseridconnectid"
       command_output = execute_command(env_action_cmd, true)
       Puppet.debug(" END get_psconfig_attribute: #{command_output}")
       out_attrib_arr = command_output.split(",") 
       Puppet.debug(" END2 get_psconfig_attribute: #{out_attrib_arr}")

       return out_attrib_arr
   end

   #--------------------------------------------------
   # startup_attrib property Getter
   #--------------------------------------------------

   def startup_attrib
      Puppet.debug("begin: startup_attrib property Getter ")
      if (configFileExists())
         get_psconfig_attribute("[Startup]", "dbnamedbtypeuseridconnectid")
      end
   end

   #--------------------------------------------------
   # startup_attrib property Setter
   #--------------------------------------------------
   def startup_attrib=(value)
      Puppet.debug("begin startup_attrib property Setter ")
      ##create_resource()
      add_update_resource_attrib()
      ##@property_hash[:startup_attrib] = get_psconfig_attribute("[Startup]", "dbnamedbtypeuseridconnectid")
      Puppet.debug("End startup_attrib property Setter ")
   end

   #--------------------------------------------------
   # listeners_port property Getter
   #--------------------------------------------------

   def listeners_port
      Puppet.debug("begin: listeners_port property Getter ")
      if (configFileExists)
        portone = get_psconfig_attribute("\"[Workstation Listener]\"","port")
        attrib_arr = portone[0].split("=")
        portstr = "workstation_listenerport=" + attrib_arr[1] + ","   

        portone = get_psconfig_attribute("\"[JOLT Listener]\"","port")
        attrib_arr = portone[0].split("=")
        portstr += "joltlistener_jslport=" + attrib_arr[1]  + "," 

        portone = get_psconfig_attribute("\"[JOLT Relay Adapter]\"","listenerport" )
        attrib_arr = portone[0].split("=")
        portstr += "joltrelayadapter_listenerport=" + attrib_arr[1]  
        portarr = portstr.split(",") 
        Puppet.debug("end: listeners_port property Getter: : #{ portarr} ")
      end 
      portarr
   end

   #--------------------------------------------------
   # listeners_port property Setter
   #--------------------------------------------------
   def listeners_port=(value)
      Puppet.debug("begin listeners_port property Setter ")
      ##create_resource()
      ##add_update_resource_attrib()
      Puppet.debug("end listeners_port property Setter ")
   end
end

##----------------------------------------------------
##----------------------------------------------------

