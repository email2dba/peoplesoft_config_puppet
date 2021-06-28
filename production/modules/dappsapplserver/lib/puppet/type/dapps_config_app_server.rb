Puppet::Type.newtype(:dapps_config_app_server) do
   desc "Puppet type that do test dapps_config_app_server"

   ensurable

   newparam(:name, :namevar => true) do
      desc "apps server name - currently must be 'friendly' name (e.g. DAPPSSTG1_1)"
   end

   newproperty(:startup_attrib, :array_matching => :all) do
      desc "startup_attrib Apps server domain main parameter needed to create "
      def insync?(is)
        ((is.sort).join).downcase == ((should.sort).join).downcase
      end
   end

   newproperty(:listeners_port, :array_matching => :all) do
      desc "Ports details for Apps server domain main parameter needed to create "
      def insync?(is)
        is.sort == should.sort
      end
   end

  newparam(:domain_attrib) do
      desc "pwd_attrib"
  end

  newparam(:pwd_attrib) do
      desc "pwd_attrib"
  end

  newparam(:psappsrv_attrib) do
      desc "psappsrv_attrib"
  end

  newparam(:psrensrv_attrib) do
      desc "psrensrv_attrib"
  end

  newparam(:pstools_attrib) do
      desc "pstools_attrib"
  end

  newparam(:procs_attrib) do
      desc "procs_attrib"
  end

  newparam(:jolt_attrib) do
      desc "jolt_attrib"
  end

  newparam(:workstation_attrib) do
      desc "workstation_attrib"
  end

  newparam(:psqrysrv_attrib) do
      desc "psqrysrv_attrib"
  end

  newparam(:psmonitorsrv_attrib) do
      desc "psmonitorsrv_attrib"
  end

 
  newparam(:psbrkdsp_dflt_attrib) do
      desc "psbrkdsp_dflt_attrib"
  end
 
  newparam(:psbrkhnd_dflt_attrib) do
      desc "psbrkhnd_dflt_attrib"
  end
 
  newparam(:pssubdsp_dflt_attrib) do
      desc "pssubdsp_dflt_attrib"
  end
 
  newparam(:pssubhnd_dflt_attrib) do
      desc "pssubhnd_dflt_attrib"
  end
 
  newparam(:pspubdsp_dflt_attrib) do
      desc "pspubdsp_dflt_attrib"
  end
 
  newparam(:pspubhnd_dflt_attrib) do
      desc "pspubhnd_dflt_attrib"
  end
 
  newparam(:psbrkdsp_cnfdsp_attrib) do
      desc "psbrkdsp_cnfdsp_attrib"
  end
 
  newparam(:psbrkhnd_cnfdsp_attrib) do
      desc "psbrkhnd_cnfdsp_attrib"
  end
 
  newparam(:pssubdsp_cnfsub_attrib) do
      desc "pssubdsp_cnfsub_attrib"
  end
 
  newparam(:pssubhnd_cnfsub_attrib) do
      desc "pssubhnd_cnfsub_attrib"
  end
 
  newparam(:psbrkdsp_mftdsp_attrib) do
      desc "psbrkdsp_mftdsp_attrib"
  end
 
  newparam(:psbrkhnd_mftdsp_attrib) do
      desc "psbrkhnd_mftdsp_attrib"
  end
 
  newparam(:pspubdsp_mftpub_attrib) do
      desc "pspubdsp_mftpub_attrib"
  end
 
  newparam(:pspubhnd_mftpub_attrib) do
      desc "pspubhnd_mftpub_attrib"
  end

  newparam(:smtp_attrib) do
      desc "smtp_attrib"
  end

  newparam(:msln_attrib) do
      desc "msln_attrib"
  end
  newparam(:feature_settings_str) do
    desc "feature_settings_str"
  end

  newparam(:scripts_location) do
    desc "scripts_location bash files and python files"
  end

  newparam(:ps_location) do
    desc "ps_location"
  end
end
