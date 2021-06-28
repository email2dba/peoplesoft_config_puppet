Puppet::Type.newtype(:dapps_config_prcs_server) do
   desc "Puppet type that do test dapps_config_prcs_server"

   ensurable

   newparam(:name, :namevar => true) do
      desc "prcs server name - currently must be 'friendly' name (e.g. DAPPSSTG1_1)"
   end

   newparam(:prcs_prcs_scheduler_attrib) do
      desc "prcs_prcs_scheduler_attrib"
   end

   newparam(:prcs_db_attrib) do
      desc "prcs_db_attrib"
   end
   newparam(:prcs_pwd_attrib) do
      desc "prcs_pwd_attrib"
   end

   newparam(:prcs_pstools_attrib) do
      desc "prcs_pstools_attrib"
   end
   newparam(:prcs_psdstsrv_attrib) do
      desc "prcs_psdstsrv_attrib"
   end

   newparam(:prcs_psaesrv_attrib) do
      desc "prcs_psaesrv_attrib"
   end

   newparam(:prcs_sqr_attrib) do
      desc "prcs_sqr_attrib"
   end

   newparam(:prcs_datamover_attrib) do
      desc "prcs_datamover_attrib"
   end

   newparam(:prcs_psmonitorsrv_attrib) do
      desc "prcs_psmonitorsrv_attrib"
   end

   newparam(:prcs_smtp_attrib) do
      desc "prcs_smtp_attrib"
   end

   newparam(:prcs_msln_attrib) do
      desc "prcs_msln_attrib"
   end

   newparam(:prcs_feature_str) do
      desc "prcs_feature_str"
   end
 
   newparam(:scripts_location) do
      desc "scripts_location bash files and python files"
   end
 
   newparam(:prcs_location) do
      desc "prcs_location"
   end

end
