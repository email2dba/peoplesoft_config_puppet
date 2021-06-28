
require 'fileutils'
require 'open3'

Puppet::Type.type(:dapps_target_update_web_server).provide(:prv001_dapps_target_update_server) do

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
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )

       env_action_cmd  = lcl_bash_fle_location + "/get_decrypt_str.bsh \"" +  encr_string + "\" "
       command_output = execute_command(env_action_cmd, true)
       Puppet.debug(" get_decrypt_str output: #{command_output}")
       command_output
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

   #----------------------------------------------------------------------------------------
   #----------------------------------------------------------------------------------------
   #---------------------------------------------------------------------------------------- 
 
   #--------------------------------------------------
   # startweblogicadmin
   #--------------------------------------------------
   def startweblogicadmin
     Puppet.alert(" begin :  startweblogicadmin ")

     lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
     lcl_ps_location_arr    =  resource[:web_location_attrib]

     env_action_cmd  = lcl_bash_fle_location + "/start_stop_web_admin_server.bsh  "

     env_action_cmd += " " + get_value4key("ps_config_home",  resource[:web_location_attrib])
     env_action_cmd += " " + get_value4key("webdomainname",  resource[:webdomain_attrib])

     env_action_cmd += " start "

     command_output = execute_command(env_action_cmd, true)
     Puppet.alert(" startweblogicadmin : #{command_output}")
     sleep 30
     if find_web_admin_server_status() == true
       Puppet.alert(" startweblogicadmin : Admin server Started ")
       return true
     else
       Puppet.alert(" startweblogicadmin : Admin server Failed to start ")
       return false
     end 
   end

   #--------------------------------------------------
   # find_status_web_admin_server
   # calling find_status_web_admin_server
   #--------------------------------------------------
   def find_web_admin_server_status
       Puppet.alert(" begin :  find_web_admin_server_status using http port")
       if get_by_port_status_web_admin_server("http") == true
          return true
       end
       Puppet.alert(" begin :  find_web_admin_server_status using HTTPS port")
       if get_by_port_status_web_admin_server("https") == true
          return true
       end
       return false
   end

   #--------------------------------------------------
   # get_by_port_status_web_admin_server
   # calling find_status_web_admin_server.bsh
   #--------------------------------------------------
   
   def get_by_port_status_web_admin_server(param_http_type)
       Puppet.alert(" begin :  find_web_admin_server_status ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/find_status_web_admin_server.bsh  " 
       env_action_cmd += " '" + get_value4key("pythonbinpath",  resource[:web_scripts_location]) + "' "
       env_action_cmd += " '" + get_value4key("python_file_location",  resource[:web_scripts_location]) + "' "

       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("webdomainname",  resource[:webdomain_attrib])+ "' "

       env_action_cmd += " '" + get_value4key("webadminserverhost",  resource[:webadmin_server_attrib])+ "' "

       if param_http_type == "http"
         env_action_cmd += " 'http' "
         env_action_cmd += " " + get_value4key("webadminserverhttp",  resource[:webadmin_server_attrib])
       else
         env_action_cmd += " 'https' "
         env_action_cmd += " " + get_value4key("webadminserverhttps",  resource[:webadmin_server_attrib])
       end

       env_action_cmd += " '" + get_value4key("webadminloginid",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webadminloginpwd",  resource[:web_pwd_attrib])) + "' "

       Puppet.alert(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" find_web_admin_server_status : #{command_output}")
       if command_output.include? "RUNNING"
          return true
       else
          return false
       end
   end


   
   #--------------------------------------------------
   # wlst_update_target_components
   #  calling dapps_wlst_update_target_components
   #--------------------------------------------------

   def wlst_update_target_components
       Puppet.alert(" begin :  wlst_update_ssl_attributes ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/dapps_wlst_update_target_components.bsh   "
 
       env_action_cmd += " '" + get_value4key("pythonbinpath",  resource[:web_scripts_location]) + "' "
       env_action_cmd += " '" + get_value4key("python_file_location",  resource[:web_scripts_location]) + "' "

       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("webdomainname",  resource[:webdomain_attrib])+ "' "
  

       env_action_cmd += " '" + get_value4key("webadminserverhost",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " " + get_value4key("webadminserverhttp",  resource[:webadmin_server_attrib])
       env_action_cmd += " " + get_value4key("webadminserverhttps",  resource[:webadmin_server_attrib])
       env_action_cmd += " '" + get_value4key("webadminloginid",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webadminloginpwd",  resource[:web_pwd_attrib])) + "' "

       #--Begin updation values are here.--
       env_action_cmd += " '" + get_value4key("total_pia_count",  resource[:webadmin_server_attrib])+ "' "
 
       #--End updation values are here.--

       Puppet.debug(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" wlst_update_ssl_attributes : #{command_output}")

       if command_output.include? "PIA_NOT_AVAILABLE"
          Puppet.alert(" Configuration :All PIAs are not created yet. Total Count PIAs MisMatching ")       
          return true
       end 
       if command_output.include? "UPDATE_SUCCESSFUL"
          return true
       else
          return false
       end       
   end

   #----------------------------------------------------------------------------------------
   #----------------------------------------------------------------------------------------
   #---------------------------------------------------------------------------------------- 
 
   #--------------------------------------------------
   # config.xml configFileExists
   #--------------------------------------------------
   def configFileExists
      file_name = get_value4key("ps_config_home",  resource[:web_location_attrib]) + "/webserv/"
      file_name +=  get_value4key("webdomainname",  resource[:webdomain_attrib])  + "/config/config.xml"
      Puppet.alert(" configFileExists file_name : #{file_name}")
      File.exist?(file_name)
   end

   #--------------------------------------------------
   # exists
   #--------------------------------------------------

   def exists?
      Puppet.alert("Method : exists? ")
      ##configFileExists()
      return false
   end

   #--------------------------------------------------
   # destroy
   #--------------------------------------------------

   def destroy
      Puppet.alert("begin: destroy ")
      Puppet.alert("end: destroy ")
   end


   #--------------------------------------------------
   # create
   #--------------------------------------------------
   def create
     Puppet.alert("begin: create")
     update_deployment_target()
     Puppet.alert("end: create")
   end


   #--------------------------------------------------
   # update_deployment_target
   #--------------------------------------------------
   def update_deployment_target
     Puppet.alert("begin: update_deployment_target")

     if (configFileExists() == false)
       Puppet.alert("Method : PIA Creation method did not executed and configuration not require at this time ")
       return false
     end
     #--------------------------------------------------------------------------------
     # check Admin Server Status
     # if it is PIAserver='PIA' and admin server down then bring admin server.
     # Also, If AdminServer down, then PIA configration not possible so simpley exit
     #--------------------------------------------------------------------------------
     if find_web_admin_server_status() == false
         if  get_value4key("pia_name",  resource[:webdomain_attrib]) == 'PIA'
             if startweblogicadmin() == false
                Puppet.alert(" Configuration : AdminServer Down. PIA Confgiuration not possible at this time ")
                return false    
             end
         else 
           Puppet.alert(" Configuration : AdminServer Down. PIA Confgiuration not possible at this time ")
           return false
         end
     end

     if wlst_update_target_components() == false
       Puppet.alert(" Configuration : wlst PIA SSL Configuration Failed at this time ")       
       return false
     end   

 
     Puppet.alert("end: configure  deployment_target Completed ")
   end
end
##
##============================================================================================
##============================================================================================


