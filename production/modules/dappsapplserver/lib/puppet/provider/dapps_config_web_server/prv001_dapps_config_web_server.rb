
require 'fileutils'
require 'open3'

Puppet::Type.type(:dapps_config_web_server).provide(:prv001_dapps_config_web_server) do

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
   # stopweblogicadmin
   #--------------------------------------------------
   def stopweblogicadmin
     Puppet.alert(" begin :  stopweblogicadmin ")

     lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
     lcl_ps_location_arr    =  resource[:web_location_attrib]

     env_action_cmd  = lcl_bash_fle_location + "/start_stop_web_admin_server.bsh  "

     env_action_cmd += " " + get_value4key("ps_config_home",  resource[:web_location_attrib])
     env_action_cmd += " " + get_value4key("webdomainname",  resource[:webdomain_attrib])

     env_action_cmd += " stop "

     command_output = execute_command(env_action_cmd, true)
     Puppet.alert(" startweblogicadmin : #{command_output}")
     sleep 30
     if find_web_admin_server_status() == true
       Puppet.alert(" stopweblogicadmin : Admin server Still up running ")
       return false
     else
       Puppet.alert(" stopweblogicadmin : Admin server Down ")
       return true
     end
   end


   #--------------------------------------------------
   # find_web_admin_server_status
   # calling get_by_port_status_web_admin_server 
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
       Puppet.alert(" begin :  get_by_port_status_web_admin_server : #{param_http_type} ")
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

       Puppet.debug(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" find_web_admin_server_status : #{command_output}")
       if command_output.include? "RUNNING"
          return true
       else
          return false
       end
   end

   #--------------------------------------------------
   # wlst_update_admin_ssl_attrib
   #  calling wlst_update_admin_ssl_attrib
   #--------------------------------------------------

   def wlst_update_admin_ssl_attrib
       Puppet.alert(" begin :  wlst_update_admin_ssl_attrib ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/dapps_wlst_update_admin_ssl_attrib.bsh   "

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
       env_action_cmd += " '" + get_value4key("pia_listen_address",  resource[:webdomain_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("webadminserverhttp",   resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("webadminserverhttps",  resource[:webadmin_server_attrib])+ "' "

       env_action_cmd += " '" + get_decrypt_str( get_value4key2("pia_iden_keystorepswd",  resource[:web_pwd_attrib])) + "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("pia_trust_keystore_pswd",  resource[:web_pwd_attrib])) + "' "

       env_action_cmd += " '" + get_value4key("pia_private_key_alias",  resource[:webdomain_attrib])+ "' "

       env_action_cmd += " '" + get_decrypt_str( get_value4key2("piaprivatekeypswd",  resource[:web_pwd_attrib])) + "' "

       #--End updation values are here.--
       Puppet.debug(" env_action_cmd: #{env_action_cmd}")
       Puppet.alert(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" wlst_update_ssl_attributes : #{command_output}")

       if command_output.include? "UPDATION_NOT_REQUIRE"
          return true
       end
       if command_output.include? "UPDATION_SUCCESSFUL"
          return true
       else
          return false
       end
   end
   
   #--------------------------------------------------
   # wlst_create_PIA_domain
   #     call dapps_wlst_create_PIA_domain.bsh file
   #--------------------------------------------------

   def wlst_create_PIA_domain
       Puppet.alert(" begin :  wlst_create_PIA_domain")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/dapps_wlst_create_PIA_domain.bsh  "

       env_action_cmd += " '" + get_value4key("pythonbinpath",  resource[:web_scripts_location]) + "' "
       env_action_cmd += " '" + get_value4key("python_file_location",  resource[:web_scripts_location]) + "' "

       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("webdomainname",  resource[:webdomain_attrib])+ "' "
       ## we are sending all PIA name to create /clone all PIAxx 
       env_action_cmd += " '" + get_value4key("all_pia_names",  resource[:webadmin_server_attrib])+ "' "

       env_action_cmd += " '" + get_value4key("webadminserverhost",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " " + get_value4key("webadminserverhttp",  resource[:webadmin_server_attrib])
       env_action_cmd += " " + get_value4key("webadminserverhttps",  resource[:webadmin_server_attrib])
       env_action_cmd += " '" + get_value4key("webadminloginid",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webadminloginpwd",  resource[:web_pwd_attrib])) + "' "

       Puppet.debug(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" dapps_start_stop_PIA_domain  : #{command_output}")
       if command_output.include? "ALREADY_EXISTS"
          return true
       end 
       if command_output.include? "CREATED"
          return true
       else
          return false
       end
       
   end
   #--------------------------------------------------
   # start_PIA_domain
   #--------------------------------------------------

   def start_PIA_domain
       Puppet.alert(" begin :  start_PIA_domain ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/start_stop_PIA_domain_server.bsh  "

       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib]) +"' "
       env_action_cmd += " '" + get_value4key("webdomainname",  resource[:webdomain_attrib]) +"' "

       env_action_cmd += " 'start' " + " '" + get_value4key("pia_name",  resource[:webdomain_attrib]) +"' "
       Puppet.alert(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" start_PIA_domain  : #{command_output}")
       ##command_output
       sleep 30
       if find_status_PIA_domain_server() == true
         Puppet.alert(" start_PIA_domain: PIA domain server Started ")
         return true
       else
         Puppet.alert(" start_PIA_domain : PIA domain server Failed to start ")
         return false
       end 
   end
  
   #--------------------------------------------------
   # find_status_PIA_domain_server
   # calling find_status_PIA_domain_server.bsh
   #--------------------------------------------------
   def find_status_PIA_domain_server
       Puppet.alert(" begin :  find_status_PIA_domain_server ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/find_status_PIA_domain_server.bsh " 
       env_action_cmd += " '" + get_value4key("pythonbinpath",  resource[:web_scripts_location]) + "' "
       env_action_cmd += " '" + get_value4key("python_file_location",  resource[:web_scripts_location]) + "' "

       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("webdomainname",  resource[:webdomain_attrib])+ "' "

       env_action_cmd += " '" + get_value4key("webadminserverhost",  resource[:webadmin_server_attrib])+ "' "

       env_action_cmd += " " + get_value4key("webadminserverhttp",  resource[:webadmin_server_attrib])
       env_action_cmd += " " + get_value4key("webadminserverhttps",  resource[:webadmin_server_attrib])
       env_action_cmd += " '" + get_value4key("webadminloginid",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webadminloginpwd",  resource[:web_pwd_attrib])) + "' "
       env_action_cmd += "  " + get_value4key("pia_name",  resource[:webdomain_attrib]) 

       Puppet.debug(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" find_status_PIA_domain_server : #{command_output}")

       if command_output.include? "RUNNING"
          return true
       else
          return false
       end
   end
 
   #--------------------------------------------------
   # wlst_update_ssl_attributes
   #  calling dapps_wlst_update_ssl_attributes
   #--------------------------------------------------

   def wlst_update_ssl_attributes
       Puppet.alert(" begin :  wlst_update_ssl_attributes ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/dapps_wlst_update_ssl_attributes.bsh   "
 
       env_action_cmd += " '" + get_value4key("pythonbinpath",  resource[:web_scripts_location]) + "' "
       env_action_cmd += " '" + get_value4key("python_file_location",  resource[:web_scripts_location]) + "' "

       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("webdomainname",  resource[:webdomain_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("pia_name",  resource[:webdomain_attrib])+ "' "

       env_action_cmd += " '" + get_value4key("webadminserverhost",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " " + get_value4key("webadminserverhttp",  resource[:webadmin_server_attrib])
       env_action_cmd += " " + get_value4key("webadminserverhttps",  resource[:webadmin_server_attrib])
       env_action_cmd += " '" + get_value4key("webadminloginid",  resource[:webadmin_server_attrib])+ "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webadminloginpwd",  resource[:web_pwd_attrib])) + "' "

       #--Begin updation values are here.--
       env_action_cmd += " '" + get_value4key("pia_listen_address",  resource[:webdomain_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("http_port",  resource[:webport_attrib])+ "' "
       env_action_cmd += " '" + get_value4key("https_port",  resource[:webport_attrib])+ "' "

       env_action_cmd += " '" + get_decrypt_str( get_value4key2("pia_iden_keystorepswd",  resource[:web_pwd_attrib])) + "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("pia_trust_keystore_pswd",  resource[:web_pwd_attrib])) + "' "

       env_action_cmd += " '" + get_value4key("pia_private_key_alias",  resource[:webdomain_attrib])+ "' "

       env_action_cmd += " '" + get_decrypt_str( get_value4key2("piaprivatekeypswd",  resource[:web_pwd_attrib])) + "' "

       #--End updation values are here.--

       Puppet.debug(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" wlst_update_ssl_attributes : #{command_output}")

       if command_output.include? "UPDATION_NOT_REQUIRE"
          return true
       end 
       if command_output.include? "UPDATION_SUCCESSFUL"
          return true
       else
          return false
       end       
   end


   #--------------------------------------------------
   # web_copy_boot_prop_file
   # call web_copy_boot_prop_file.bsh file
   #--------------------------------------------------
   #
   def web_copy_boot_prop_file
       Puppet.alert(" begin :  web_copy_boot_prop_file.bsh ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    =  resource[:web_location_attrib]
       env_action_cmd  = lcl_bash_fle_location + "/web_copy_boot_prop_file.bsh  "


       ##Even if SOURCE_HOST and TARGET_HOST are same then copy boot properties
       ##PS_CONFIG_HOME
       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib])+ "' "

       ##SOURCE_HOST
       env_action_cmd += " '" + get_value4key("webadminserverhost",  resource[:webadmin_server_attrib])+ "' "

       ##SOURCE_DOMAIN
       ##env_action_cmd += " '" + (get_value4key("websitename",  resource[:webadmin_server_attrib])).upcase  + "1_1' "
       env_action_cmd += " '" + get_value4key("webadmindomainname",  resource[:webadmin_server_attrib]) + "' "
       ##TARGET_DOMAIN
       env_action_cmd += " '" + get_value4key("webdomainname",  resource[:webdomain_attrib])+ "' "
       ##DOMAIN_ADMIN_USER
       env_action_cmd += " '" + get_value4key("webadminloginid",  resource[:webadmin_server_attrib]) + "' "
       ##DOMAIN_ADMIN_PWD
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webadminloginpwd",  resource[:web_pwd_attrib])) + "' "

       ##Puppet.debug(" env_action_cmd: #{env_action_cmd}")
       Puppet.alert(" env_action_cmd: #{env_action_cmd}")

       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" dapps_start_stop_PIA_domain  : #{command_output}")
       if command_output.include? "COPY"
          return true
       else
          return false
       end
       return true      
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
      #Puppet.debug(" configFileExists file_name : #{file_name}")
      #Puppet.alert(" Domain already exists  ")
      File.exist?(file_name)
   end

   #--------------------------------------------------
   # exists
   #--------------------------------------------------

   def exists?
      Puppet.debug("Method : exists? ")
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
     configure_PIA_server()
     Puppet.alert("end: create")
   end


   #--------------------------------------------------
   # configure_PIA_server
   #--------------------------------------------------
   def configure_PIA_server
     Puppet.alert("begin: configure_PIA_server")

     if (configFileExists() == false)
       Puppet.alert("Method : PIA Creation method did not executed and configuration not require at this time ")
       return false
     end
     #--------------------------------------------------------------------------------
     # check Admin Server Status
     # if it is PIAserver='PIA' and admin server down then bring admin server.
     # Also, If AdminServer down, then PIA configration not possible so simpley exit
     #--------------------------------------------------------------------------------
     Puppet.alert(" Configuration : Verifying AdminServer status   ")
     if find_web_admin_server_status() == false
         if  get_value4key("pia_name",  resource[:webdomain_attrib]) == 'PIA'
             Puppet.alert(" Configuration : calling startweblogicadmin to bring up admin server ")
             if startweblogicadmin() == false
                Puppet.alert(" Configuration : AdminServer Down. PIA Confgiuration not possible at this time ")
                return false    
             end
         else 
           Puppet.alert(" Configuration : AdminServer Down. PIA Confgiuration not possible at this time ")
           return false
         end
     end

     #--------------------------------------------------------------------------------
     #This program creates all Managed servers and also sets Depolyment Target for peoplesoft
     #This should called only one time so we are calling this during "PIA" creation not require to 
     #call other  PIAxx creation 
     #--------------------------------------------------------------------------------
     if  get_value4key("pia_name",  resource[:webdomain_attrib]) == 'PIA'
       Puppet.alert(" Configuration : calling wlst_create_PIA_domain to create PIA domain server in console ")       
       if wlst_create_PIA_domain() == false
         Puppet.alert(" Configuration : wlst PIA Creation Failed and SSL configuration not possible at this time ")       
         return false
       end 
     end

     ##NOTE: All PIAx creation in console happened during "PIA" creation
     #However custom value like ssl port , keystore password are setting up now
     #Also, it is getting set only for the current PIA which we are creating. 
     ##Setting SSL keys for PIA server which we are creating
     Puppet.alert(" Configuration : calling wlst_update_ssl_attributes to config PIA SSL ")       
     if wlst_update_ssl_attributes() == false
       Puppet.alert(" Configuration : wlst PIA SSL Configuration Failed at this time ")       
       return false
     end 
     Puppet.alert(" Configuration : wlst PIA SSL  Configuration Successful ") 

     ##Setting SSL keys for WebLogicAdmin server
     if  get_value4key("pia_name",  resource[:webdomain_attrib]) == 'PIA' || get_value4key("pia_name",  resource[:webdomain_attrib]) == 'PIA11' 
        Puppet.alert(" Configuration : calling wlst_update_admin_ssl_attrib to config WeblogicAdmin SSL ")
        if wlst_update_admin_ssl_attrib() == false
          Puppet.alert(" Configuration : wlst WeblogicAdmin SSL Configuration Failed at this time ")
        else
          Puppet.alert(" Configuration : wlst WeblogicAdmin SSL Configuration completed ")
          ## now, we can stop admin and restart admin again  using SSL port
          ## 20210512 code added begin
          Puppet.alert(" Configuration : AdminServer : Trying to shutdown ")
          if stopweblogicadmin() == false
             Puppet.alert(" Configuration : AdminServer Failed to shutdown. PIA Confgiuration not possible at this time ")
             return false
          else
             Puppet.alert(" Configuration : AdminServer : We try to bring in SSL Mode")
             if startweblogicadmin() == false
               Puppet.alert(" Configuration : AdminServer Down after SSL configured. PIA Confgiuration not possible at this time ")
               return false
             end
          end
          ##20210512 code added END
        end
     end

     ## After SSL has been set we can copy boot properties and config.xml
     ## file into local server if WebLogicAdmin is in remote or local server.
     Puppet.alert(" Configuration : copy boot properties method calling ")
     if  get_value4key("pia_name",  resource[:webdomain_attrib]) != 'PIA' and get_value4key("pia_name",  resource[:webdomain_attrib]) != 'PIA11'
       if web_copy_boot_prop_file() == false
         Puppet.alert(" Configuration : web_copy_boot_prop_file Failed")
         return false
       end
       Puppet.alert(" Configuration : copy boot properties method compleed ")
     end
     if find_status_PIA_domain_server() == false
       Puppet.alert(" Configuration : wlst PIA is not up now. ")
       if start_PIA_domain() == false
         Puppet.alert(" Configuration : wlst PIA startup Failed ")
         return false
       else
         Puppet.alert(" Configuration : wlst PIA started ")
       end
     else
        Puppet.alert("PIA domain server already started and up/running ")
        return false
     end

     Puppet.alert("end: configure_PIA_server ")
   end
end
##
##============================================================================================
##============================================================================================

