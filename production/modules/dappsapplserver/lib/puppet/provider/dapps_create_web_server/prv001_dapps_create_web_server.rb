
require 'fileutils'
require 'open3'

Puppet::Type.type(:dapps_create_web_server).provide(:prv001_dapps_create_web_server) do
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
       return command_output 
   end
   #--------------------------------------------------
   # create_resource
   #--------------------------------------------------

   def create_resource
       Puppet.alert(" begin create_resource:  ")
       lcl_bash_fle_location  = get_value4key("bash_file_location",  resource[:web_scripts_location] )
       lcl_ps_location_arr    = resource[:web_location_attrib]

       env_action_cmd  = lcl_bash_fle_location + "/psadmin_web_server_creation.bsh  "
       env_action_cmd += " '" + resource[:web_env_name_attrib] + "' "

       env_action_cmd += " '" + get_value4key("psft_env_sh_location",  resource[:web_scripts_location] )  + "' "
       env_action_cmd += " '" + get_value4key("ps_config_home",  resource[:web_location_attrib]) + "' "
       env_action_cmd += " '" + get_value4key("ps_app_home",     resource[:web_location_attrib]) + "' "
       env_action_cmd += " '" + get_value4key("webdomainname",   resource[:webdomain_attrib]) + "' "
       env_action_cmd += " '" + get_value4key("weblogicserverhomedir",  resource[:web_other_attrib]) + "' "

       env_action_cmd += " '" + get_value4key("webadminloginid",  resource[:webadmin_server_attrib]) + "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webadminloginpwd",  resource[:web_pwd_attrib]))+"' "

       env_action_cmd += " CREATE_NEW_DOMAIN "
       env_action_cmd += " NEW_DOMAIN "
       env_action_cmd += " MULTI_SERVER_INSTALLATION "
       ##if get_value4key("pia_name",  resource[:webdomain_attrib]) == 'PIA'
            ##env_action_cmd += " MULTI_SERVER_INSTALLATION "
       ##else
            ##env_action_cmd += " DISTRIBUTED_SERVER_INSTALLATION "
       ##end
       env_action_cmd += " " + get_value4key("websitename",  resource[:webadmin_server_attrib])
       env_action_cmd += " '" + get_value4key("appserverhost",  resource[:webdomain_attrib]) + "' "

       if get_value4key("psserver",  resource[:webdomain_attrib]) == "zzz"
          env_action_cmd += " '" + get_value4key("psserver",  resource[:webdomain_attrib]) + "' "
       else
          env_action_cmd += " '" + get_value4key("psserver",  resource[:webadmin_server_attrib]) + "' "
       end

       env_action_cmd += " '" + get_value4key("jslport",  resource[:webport_attrib]) + "' "

       env_action_cmd += " '" + get_value4key("http_port",  resource[:webport_attrib]) + "' "
       env_action_cmd += " '" + get_value4key("https_port",  resource[:webport_attrib]) + "' "
       env_action_cmd += " '" + get_value4key("authenticationtokendomain",  resource[:web_other_attrib]) + "' "

       env_action_cmd += " '" + get_value4key("webprofile",  resource[:web_profile_attrib]) + "' "

       env_action_cmd += " '" + get_decrypt_str( get_value4key2("webProfuserpwd",  resource[:web_pwd_attrib])) + "' "

       env_action_cmd += " '" + get_value4key("intgatewayid",  resource[:webadmin_server_attrib]) + "' "
       env_action_cmd += " '" + get_decrypt_str( get_value4key2("intgatewaypwd",  resource[:web_pwd_attrib])) + "' " 

       env_action_cmd += " '" + get_decrypt_str( get_value4key2("appsrvdomconnpwd",  resource[:web_pwd_attrib])) + "' "
       env_action_cmd += " '" +  get_value4key("reportrepositorypath",  resource[:web_other_attrib]) + "' "

       Puppet.debug("env_action_cmd: #{env_action_cmd}")
       ##Puppet.alert("env_action_cmd: #{env_action_cmd}")
       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" create_resource: #{command_output}")

       command_output
   end
 
   #--------------------------------------------------
   # update setEnv.sh File
   # update_setEnv_scripts
   #--------------------------------------------------
   def update_setEnv_scripts
     Puppet.alert(" begin :  update_setEnv_scripts ")
     file_name =  get_value4key("ps_config_home",  resource[:web_location_attrib]) + "/webserv/"
     file_name += get_value4key("webdomainname",  resource[:webdomain_attrib])  + "/bin/setEnv.sh"

     Puppet.debug(" update_setEnv_scripts : #{file_name} ")

     text = File.read(file_name)
     Puppet.debug(" update_setEnv_scripts 1 : #{file_name} ")
     httpsport =  get_value4key("webadminserverhttps", resource[:webadmin_server_attrib] )

     Puppet.debug(" update_setEnv_scripts 1A : #{httpsport} ")
     ##new_contents   = text.gsub(/443/, get_value4key("webadminserverhttps", resource[:webadmin_server_attrib]  ) )

     Puppet.debug(" update_setEnv_scripts 2 : #{file_name} ")
     new_contents1  = text.gsub(/9999/, get_value4key("webadminserverhttp", resource[:webadmin_server_attrib]  ) )

     Puppet.debug(" update_setEnv_scripts 3 : #{file_name} ")
     jvm_small_size1= "-Xms2048m"
     jvm_max_size2= "-Xmx2048m"
     jvm_small_size2= "-Xms1024m"
     jvm_max_size2= "-Xmx1024m"

     ####new_contents   = new_contents1.gsub(/-Xms256m/, jvm_max_size )
     ####new_contents1  = new_contents.gsub(/-Xmx256m/, jvm_max_size )


     new_contents   = new_contents1.gsub("-server -Xms512m -Xmx512m", "-server -Xms2048m -Xmx2048m"  )
     new_contents1  = new_contents.gsub("-server -Xms256m -Xmx256m", "-server -Xms1024m -Xmx1024m" )

     Puppet.debug(" update_setEnv_scripts updating ADMINSERVER_HOSTNAME : #{file_name} ")
     oldstr="ADMINSERVER_HOSTNAME=" + get_value4key("appserverhost",   resource[:webdomain_attrib])
     newstr="ADMINSERVER_HOSTNAME=" + get_value4key("webadminserverhost", resource[:webadmin_server_attrib] )

     new_contents2  = new_contents1.gsub(oldstr, newstr )


     new_contents   = new_contents2.gsub(/-XX:MaxPermSize=128m/, "-XX:MaxPermSize=256m" )
     File.open(file_name, "w") {|file| file.puts new_contents }
     Puppet.alert(" end :  update_setEnv_scripts ")
   end

   #--------------------------------------------------
   # update config.xml File
   # update_config_xml_File
   #--------------------------------------------------
   def update_config_xml_File
     Puppet.alert(" begin: update_config_xml_File ")
     file_name =  get_value4key("ps_config_home",  resource[:web_location_attrib]) + "/webserv/"
     file_name += get_value4key("webdomainname",  resource[:webdomain_attrib])  + "/config/config.xml"
     text = File.read(file_name)
     ##new_contents   = text.gsub(/listen-port>443/, "listen-port>" + get_value4key("webadminserverhttps", resource[:webadmin_server_attrib] ) )
     new_contents1  = text.gsub(/9999/, get_value4key("webadminserverhttp", resource[:webadmin_server_attrib] ) )

     File.open(file_name, "w") {|file| file.puts new_contents1 }
     Puppet.alert(" end : update_config_xml_File ")
   end
   #----------------------------------------------------------------------------------------------- 
   #----------------------------------------------------------------------------------------------- 
   #----------------------------------------------------------------------------------------------- 
   

   #--------------------------------------------------
   # config.xml configFileExists
   #--------------------------------------------------
   def configFileExists
      file_name = get_value4key("ps_config_home",  resource[:web_location_attrib]) + "/webserv/"
      file_name +=  get_value4key("webdomainname",  resource[:webdomain_attrib])  + "/config/config.xml"
      ##Puppet.alert(" configFileExists method to find : file_name : #{file_name}")
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
      lcl_domain_attr_arr  =  resource[:domain_attrib]
      domain_name =  get_value4key("domainid", lcl_domain_attr_arr).upcase
      lps_app_srv_cfg_dir = get_value4key("ps_config_home", resource[:ps_location] )  + "/webserv/" +  domain_name

      lps_web_srv_cfg_dir = i get_value4key("ps_config_home",  resource[:web_location_attrib]) + "/webserv/"
      lps_web_srv_cfg_dir += get_value4key("webdomainname",  resource[:webdomain_attrib])

      if File.exist?(lps_web_srv_cfg_dir)
         Puppet.debug("Removing apps server domain directory: #{lps_web_srv_cfg_dir}")
         FileUtils.rm_rf(lps_web_srv_cfg_dir)
      end
      @property_hash[:ensure] = :absent
      ###@property_flush.clear
      Puppet.alert("end: destroy ")
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
   # create
   #--------------------------------------------------
   def create
    Puppet.alert("begin: create method")
    if (configFileExists())
      Puppet.alert("create : CREATE method already executed in previous run config.xml file exists ")
    else
      Puppet.alert("create : Domain Creation starting ....")
      create_resource()
    end
    Puppet.alert("create : setEnv script updation starting ....")
    update_setEnv_scripts()
    Puppet.alert("create : config File updation starting ....")
    update_config_xml_File()
    Puppet.alert("create : config File updation completed")

    @property_hash[:ensure] = :present
    Puppet.alert("end: create ")
   end

end
##
##============================================================================================
##============================================================================================

