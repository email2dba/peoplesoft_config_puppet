Puppet::Type.newtype(:dapps_config_web_server) do
   desc "Puppet type that do test dapps_config_web_server"

   ensurable

   newparam(:name, :namevar => true) do
      desc "web server name - currently must be 'friendly' name (e.g. DAPPSSTG1_1)"
   end

  newparam(:webdomain_attrib) do
      desc "webdomain_attrib"
  end

  newparam(:webport_attrib) do
      desc "webport_attrib"
  end

  newparam(:webadmin_server_attrib) do
      desc "webadmin_server_attrib"
  end

  newparam(:web_pwd_attrib) do
      desc "web_pwd_attrib"
  end

  newparam(:web_env_name_attrib) do
      desc "web_env_name_attrib"
  end

  newparam(:web_lockoutuser_attrib) do
      desc "web_lockoutuser_attrib"
  end

  newparam(:web_profile_attrib) do
      desc "web_profile_attrib"
  end

  newparam(:web_location_attrib) do
      desc "web_location_attrib"
  end

  newparam(:web_other_attrib) do
      desc "web_other_attrib"
  end

  newparam(:web_scripts_location) do
      desc "web_scripts_location"
  end


end

