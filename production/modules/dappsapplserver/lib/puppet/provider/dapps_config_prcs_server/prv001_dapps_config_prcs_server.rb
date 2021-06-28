
require 'fileutils'
require 'open3'

Puppet::Type.type(:dapps_config_prcs_server).provide(:prv001_dapps_config_prcs_server) do

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
   #make_create_attrib_str()
   #--------------------------------------------------
   def make_create_attrib_str()
       Puppet.alert(" begin : make_create_attrib_str")
       lcl_db_attr_arr      =  resource[:prcs_db_attrib]
       lcl_prcs_schd_arr    =  resource[:prcs_prcs_scheduler_attrib]
       lcl_pwd_attr_arr     =  resource[:prcs_pwd_attrib]

       lcl_pstools_attr_arr =  resource[:prcs_pstools_attrib]

       Puppet.debug(" begin : make_create_attrib_str 2 ")
       #DBNAME  DBTYPE
       out_str = get_value4key("dbname", lcl_db_attr_arr) + "," +  get_value4key("dbtype", lcl_db_attr_arr )
       Puppet.debug(" begin : make_create_attrib_str 3 ")

       #PRCSSERVER
       out_str += "," + get_value4key("prcsservername", lcl_prcs_schd_arr    )  
       Puppet.debug(" begin : make_create_attrib_str 4 ")

       #OPRID  OPRPWD
       out_str += "," + get_value4key("userid", lcl_db_attr_arr) + "," + get_decrypt_str(get_value4key2("pwd_userpswd", lcl_pwd_attr_arr ))
       Puppet.debug(" begin : make_create_attrib_str 5 ")

       #DB_CNCT_ID,DB_CNCT_PSWD,
       out_str += ","+ get_value4key("connectid",lcl_db_attr_arr) + "," +  get_decrypt_str(get_value4key2("pwd_connectpswd", lcl_pwd_attr_arr))

       Puppet.debug(" begin : make_create_attrib_str 8 ")
       #SERVER_NAME,
       out_str += "," + "_____"  

       #LOGOUTDIR,SQRBIN,
       out_str += "," + get_value4key("logoutdir",  resource[:prcs_msln_attrib]) +  ","  + get_value4key("sqrbin",  resource[:prcs_msln_attrib])

       #ADD_TO_PATH
       out_str += "," + get_value4key("addtopath",lcl_prcs_schd_arr )

       #DOM_CONN_PWD
       out_str += "," + get_value4key("prcssrvrdomain", lcl_prcs_schd_arr ) 

       #ENABLE_REMOTE_ADMIN,REMOTE_ADMIN_PORT,
       out_str += "," + get_value4key("enableremoteddmin",lcl_pstools_attr_arr) 
       out_str += "," +  get_value4key("remoteadminport",lcl_pstools_attr_arr)

       #REMOTE_ADMIN_USRID,REMOTE_ADMIN_PSWD,(NO)ENCRYPT
       out_str += "," +  get_value4key("remoteadminuserid",lcl_pstools_attr_arr)
       out_str += "," + get_decrypt_str(get_value4key2("pwd_remoteadminpwd", lcl_pwd_attr_arr)) + ","  + "ENCRYPT"

       Puppet.alert(" end : make_create_attrib_str")
       Puppet.debug(" make_create_attrib_str: #{out_str}")
       out_str
   end


   #--------------------------------------------------
   #make_config_attrib_str()
   #--------------------------------------------------

   def make_config_attrib_str()

        Puppet.alert(" begin make_config_attrib_str")

        lcl_db_attr_arr      =  resource[:prcs_db_attrib]
        lcl_prcs_schd_arr    =  resource[:prcs_prcs_scheduler_attrib]
        lcl_pwd_attr_arr     =  resource[:prcs_pwd_attrib]
        lcl_pstools_attr_arr =  resource[:prcs_pstools_attrib]

        Puppet.debug(" line02 make_config_attrib_str")
        out_str = " '"
        #[Domain Settings] Domain ID
        ## deena 20210401 : out_str += "[Process Scheduler]/PrcsServerName=" +  get_value4key("prcsservername", lcl_prcs_schd_arr) + "#"

        #[Security]/DomainConnectionPwd=
        ## deena 20210401 :out_str += "[Security]/DomainConnectionPwd=" + get_decrypt_str(get_value4key2("pwd_domainconnpwd", lcl_pwd_attr_arr)) + "#"

        #[Process Scheduler]/Allow Dynamic Changes=
        out_str += "[Process Scheduler]/Allow Dynamic Changes=" + get_value4key("allowdynamicchanges",lcl_prcs_schd_arr) + "#"

        #[Process Scheduler]/Max Reconnect Attempt
        out_str += "[Process Scheduler]/Max Reconnect Attempt=" + get_value4key("maxreconnectattempt",lcl_prcs_schd_arr) + "#"


        #[PSTOOLS]/Enable Remote Administration=
        out_str += "[PSTOOLS]/Enable Remote Administration=" + get_value4key("enableremoteddmin",lcl_pstools_attr_arr) + "#"

        #[PSTOOLS]/Remote Administration Port=
        out_str += "[PSTOOLS]/Remote Administration Port=" + get_value4key("remoteadminport",lcl_pstools_attr_arr) + "#"

        #[PSTOOLS]/Remote Administration UserId=
        out_str += "[PSTOOLS]/Remote Administration UserId=" + get_value4key("remoteadminuserid",lcl_pstools_attr_arr) + "#"

        #[PSTOOLS]/Remote Administration Password=
        out_str += "[PSTOOLS]/Remote Administration Password=" + get_decrypt_str(get_value4key2("pwd_remoteadminpwd", lcl_pwd_attr_arr)) + "#"

        #[PSTOOLS]/EnablePPM Agent=1
        out_str += "[PSTOOLS]/EnablePPM Agent=" + get_value4key("enableppmagent",lcl_pstools_attr_arr) + "#"

        #[PSTOOLS]/DbFlags=8
        out_str += "[PSTOOLS]/DbFlags=" + get_value4key("dbflags",lcl_pstools_attr_arr) + "#"

        #[PSDSTSRV]/Min Instances
        out_str += "[PSDSTSRV]/Min Instances=" + get_value4key("mininstances", resource[:prcs_psdstsrv_attrib] ) + "#"

        #[PSDSTSRV]/Max Instances
        out_str += "[PSDSTSRV]/Max Instances=" + get_value4key("maxinstances", resource[:prcs_psdstsrv_attrib] ) + "#"

        #[SQR]/PSSQR=
        out_str += "[SQR]/PSSQR=" + get_value4key("pssqr", resource[:prcs_sqr_attrib] ) + "#"

        #[Data Mover]/LastScriptsDir
        out_str += "[Data Mover]/LastScriptsDir=" + get_value4key("lastscriptsdir", resource[:prcs_datamover_attrib] ) + "#"

        #[PSMONITORSRV]/JavaVM Options
        out_str += "[PSMONITORSRV]/JavaVM Options=" + get_value4key("javavm_options", resource[:prcs_psmonitorsrv_attrib] ) + "#"

        #[PSAESRV]/Max Instances
        out_str += "[PSAESRV]/Max Instances=" + get_value4key("maxinstances", resource[:prcs_psaesrv_attrib] ) + "#"

        #[PSAESRV]/Recycle Count
        out_str += "[PSAESRV]/Recycle Count=" + get_value4key("recyclecount", resource[:prcs_psaesrv_attrib] ) + "#"

        #[PSAESRV]/Allowed Consec Service Failures
        out_str += "[PSAESRV]/Allowed Consec Service Failures=" + get_value4key("allowed_consec_service_failures", resource[:prcs_psaesrv_attrib] ) + "#"

        #[Database Options] EnableDBMonitoring
        out_str += "[Database Options]/EnableDBMonitoring=" + get_value4key("msln_dboptions_enabledbmonitoring", resource[:prcs_msln_attrib] ) + "#"

        #[SMTP Settings]  SMTPServer
        out_str += "[SMTP Settings]/SMTPServer=" + get_value4key("smtpserver", resource[:prcs_smtp_attrib] ) + "#"
        #[SMTP Settings] SMTPPort 
        out_str += "[SMTP Settings]/SMTPPort=" + get_value4key("smtpport", resource[:prcs_smtp_attrib] ) + "#"

        #[SMTP Settings]  SMTPSender
        out_str += "[SMTP Settings]/SMTPSender=" + get_value4key("smtpsender", resource[:prcs_smtp_attrib] ) + "#"
        #[SMTP Settings]  SMTPSourceMachine
        out_str += "[SMTP Settings]/SMTPSourceMachine=" + get_value4key("smtpsourcemachine", resource[:prcs_smtp_attrib] ) + "' "

        ##--------------------------------------------------
        Puppet.alert(" end : make_config_attrib_str")
        Puppet.debug("  make_config_attrib_str: #{out_str}")
        out_str
   end

   #--------------------------------------------------
   # make_feature_attrib_str
   #--------------------------------------------------
   def make_feature_attrib_str()
      out_str =  " '"+ resource[:prcs_feature_str] + "' "
      Puppet.debug(" make_feature_attrib_str: #{out_str}")
      out_str
   end
   #--------------------------------------------------
   # create_resource
   #--------------------------------------------------

   def create_resource
      Puppet.alert(" begin : create_resource")
      lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:scripts_location] )
      lcl_prcs_db_attr_arr   =  resource[:prcs_db_attrib]
      lcl_prcs_scheduler_attr_arr  =  resource[:prcs_prcs_scheduler_attrib]
      lcl_prcs_location_arr  =  resource[:prcs_location]
      Puppet.debug(" begin create_resource one")

      envir_name =  get_value4key("dbname", lcl_prcs_db_attr_arr).downcase
      domain_name =  get_value4key("prcssrvrdomain", lcl_prcs_scheduler_attr_arr).upcase


      Puppet.debug(" begin create_resource two")

      env_action_cmd  = lcl_bash_fle_location + "/psadmin_prcs_server_creation.bsh  "
      env_action_cmd += " " +  get_value4key("psft_env_sh_location",  resource[:scripts_location] )  +" " + envir_name
      env_action_cmd += " " + domain_name
      env_action_cmd += " " + make_create_attrib_str()
      Puppet.debug(" create_resource : env_action_cmd : #{env_action_cmd}")
      ##Puppet.alert(" create_resource : env_action_cmd : #{env_action_cmd}")
      command_output = execute_command(env_action_cmd, true)
      Puppet.alert(" create_resource: #{command_output}")

      command_output
   end

   #--------------------------------------------------
   # psadmin_prcs_server_config_updation
   #--------------------------------------------------
   def add_update_resource_attrib
       Puppet.alert(" begin add_update_resource_attrib custom configuration ")
       lcl_bash_fle_location  = get_value4key("bash_file_location",  resource[:scripts_location] )
       lcl_prcs_db_attr_arr   =  resource[:prcs_db_attrib]
       lcl_prcs_scheduler_attr_arr  =  resource[:prcs_prcs_scheduler_attrib]
       lcl_prcs_location_arr  = resource[:prcs_location]

       envir_name =  get_value4key("dbname", lcl_prcs_db_attr_arr).downcase
       domain_name =  get_value4key("prcssrvrdomain", lcl_prcs_scheduler_attr_arr).upcase

       env_action_cmd  = lcl_bash_fle_location + "/psadmin_prcs_server_config_updation.bsh  "
       env_action_cmd += " '" +  get_value4key("psft_env_sh_location",  resource[:scripts_location] )  +"' " + envir_name
       env_action_cmd += " " + domain_name
       env_action_cmd += " " + make_config_attrib_str()
       env_action_cmd += " " + make_feature_attrib_str()
       Puppet.debug(" add_update_resource_attrib env_action_cmd : #{env_action_cmd}")
       ##Puppet.alert(" add_update_resource_attrib env_action_cmd : #{env_action_cmd}")
       command_output = execute_command(env_action_cmd, true)
       Puppet.alert(" add_update_resource_attrib: #{command_output}")
       Puppet.alert(" end add_update_resource_attrib custom configuration")
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
   #--------------------------------------------------
   # psprcs.cfg configFileExists
   #--------------------------------------------------
   def configFileExists
      Puppet.debug("Begin : configFileExists ")
      lcl_prcs_scheduler_attr_arr  =  resource[:prcs_prcs_scheduler_attrib]
      domain_name = get_value4key("prcssrvrdomain", lcl_prcs_scheduler_attr_arr).upcase
      lprcs_app_srv_cfg_dir = get_value4key("ps_config_home", resource[:prcs_location] )  + "/appserv/prcs/" +  domain_name
      Puppet.debug(" configFileExists lprcs_app_srv_cfg_dir: #{lprcs_app_srv_cfg_dir}")

      File.exist?(lprcs_app_srv_cfg_dir)
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
      Puppet.debug("begin: destroy ")
      lcl_prcs_scheduler_attr_arr  =  resource[:prcs_prcs_scheduler_attrib]
      domain_name =  get_value4key("prcssrvrdomain", lcl_prcs_scheduler_attr_arr).upcase
      lprcs_app_srv_cfg_dir = get_value4key("ps_config_home", resource[:prcs_location] )  + "/appserv/prcs/" +  domain_name

      if File.exist?(lprcs_app_srv_cfg_dir)
         Puppet.debug("Removing apps server domain directory: #{lprcs_app_srv_cfg_dir}")
         FileUtils.rm_rf(lprcs_app_srv_cfg_dir)
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
      Puppet.alert("create: Domain alteady created by previous run, custom configuration starts ")
    else
      create_resource()
    end
    add_update_resource_attrib()
    ##@property_hash[:ensure] = :present
    ###@property_hash[:prcs_db_attrib] = get_psconfig_attribute("[Startup]", "dbnamedbtypeuseridconnectid")
    Puppet.debug("end: create ")
   end

   #--------------------------------------------------
   # get_psconfig_attribute to get prcs_db_attrib
   #--------------------------------------------------
   def get_psconfig_attribute(groupid, groupattriblist)
       Puppet.debug(" BEGIN get_psconfig_attribute: ")
       lcl_bash_fle_location  =  get_value4key("bash_file_location",  resource[:scripts_location] )
       lcl_prcs_db_attr_arr   =  resource[:prcs_db_attrib]
       lcl_prcs_scheduler_attr_arr  =  resource[:prcs_prcs_scheduler_attrib]
       lcl_prcs_location_arr    =  resource[:prcs_location]

       envir_name =  get_value4key("dbname", lcl_prcs_db_attr_arr).downcase
       domain_name =  get_value4key("prcssrvrdomain", lcl_prcs_scheduler_attr_arr).upcase

       env_action_cmd  = lcl_bash_fle_location + "/get_psconfig_attribute.bsh  "
       env_action_cmd += " " + get_value4key("ps_config_home",  resource[:prcs_location] ) +" " + envir_name
       env_action_cmd += " app " + domain_name + " " + groupid + " " + groupattriblist
       ##env_action_cmd += " [Startup] dbnamedbtypeuseridconnectid"
       command_output = execute_command(env_action_cmd, true)
       Puppet.debug(" END get_psconfig_attribute: #{command_output}")
       out_attrib_arr = command_output.split(",") 
       Puppet.debug(" END2 get_psconfig_attribute: #{out_attrib_arr}")

       return out_attrib_arr
   end
end


