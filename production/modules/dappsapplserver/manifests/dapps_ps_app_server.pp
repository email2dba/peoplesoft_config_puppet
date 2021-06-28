##
##
##

class dappsapplserver::dapps_ps_app_server ($cfg_environ_name, $cfg_domain_name) {

  #-------------Domain level setting-----------------------------
  $startup_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_environ_name, '_startup_attrib'), {value_type => Hash})   , '=')

  $domain_att_arr = join_keys_to_values( lookup(join2strings ($cfg_domain_name, '_domain_attrib'), {value_type => Hash}) , '=') +
                           join_keys_to_values(lookup('gbl_domain_attrib', {value_type => Hash}), '=')

  $pwd_att_arr = join_keys_to_values(  lookup(join2strings ($cfg_environ_name, '_pwd_attrib'), {value_type => Hash})   , '=')

  $port_att_arr     = join_keys_to_values(  lookup(join2strings ($cfg_domain_name, '_listeners_port'), {value_type => Hash}), '=')
  $psrensrv_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_psrensrv_attrib'), {value_type => Hash}), '=')

  $jolt_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_jolt_attrib'), {value_type => Hash}), '=')
  $workstation_att_arr =  join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_workstation_attrib'), {value_type => Hash}), '=')

  $psqrysrv_att_arr =  join_keys_to_values(  lookup(join2strings ($cfg_domain_name, '_psqrysrv_attrib'), {value_type => Hash}), '=')
  $psmonitorsrv_att_arr = join_keys_to_values( lookup(join2strings ($cfg_domain_name, '_psmonitorsrv_attrib'), {value_type => Hash}), '=')

###  $pssubhnd_cnfsub_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pssubhnd_cnfsub_attrib'), {value_type => Hash}), '=')
  #-------------IB setting  configuration Begin-------------------
  $psbrkdsp_dflt_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_psbrkdsp_dflt_attrib'), {value_type => Hash}), '=')
  $psbrkhnd_dflt_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_psbrkhnd_dflt_attrib'), {value_type => Hash}), '=')
  $pssubdsp_dflt_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pssubdsp_dflt_attrib'), {value_type => Hash}), '=')
  $pssubhnd_dflt_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pssubhnd_dflt_attrib'), {value_type => Hash}), '=')

  $pspubdsp_dflt_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pspubdsp_dflt_attrib'), {value_type => Hash}), '=')
  $pspubhnd_dflt_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pspubhnd_dflt_attrib'), {value_type => Hash}), '=')

  $psbrkdsp_cnfdsp_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_psbrkdsp_cnfdsp_attrib'), {value_type => Hash}), '=')
  $psbrkhnd_cnfdsp_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_psbrkhnd_cnfdsp_attrib'), {value_type => Hash}), '=')

  $pssubdsp_cnfsub_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pssubdsp_cnfsub_attrib'), {value_type => Hash}), '=')
  $pssubhnd_cnfsub_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pssubhnd_cnfsub_attrib'), {value_type => Hash}), '=')
  $psbrkdsp_mftdsp_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_psbrkdsp_mftdsp_attrib'), {value_type => Hash}), '=')
  $psbrkhnd_mftdsp_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_psbrkhnd_mftdsp_attrib'), {value_type => Hash}), '=')

  $pspubdsp_mftpub_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pspubdsp_mftpub_attrib'), {value_type => Hash}), '=')
  $pspubhnd_mftpub_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_pspubhnd_mftpub_attrib'), {value_type => Hash}), '=')

  #-------------IB setting  configuration End---------------------


  $domain_feature_str  = lookup( join2strings($cfg_domain_name, '_feature_str')  , {value_type => String})


  #-------------smtp setting--------------------------------------
  $smtp_att_arr     = join_keys_to_values( lookup('gbl_smtp', {value_type => Hash}) , '=') +
                            join_keys_to_values(lookup( join2strings ($cfg_domain_name, '_smtp'), {value_type => Hash}), '=')

  #-------------Environment level setting-------------------------
  $msln_att_arr = join_keys_to_values(  lookup(join2strings ($cfg_environ_name, '_msln_attrib'), {value_type => Hash}), '=') 
  $psappsrv_att_arr = join_keys_to_values(  lookup(join2strings ($cfg_environ_name, '_psappsrv_attrib'), {value_type => Hash}), '=') 
  $procs_att_arr    = join_keys_to_values(  lookup( join2strings ($cfg_environ_name, '_proccess'), {value_type => Hash}), '=') 

  $pstools_att_arr  = join_keys_to_values(  lookup('gbl_pstools_attrib', {value_type => Hash}), '=') 


###  $gbl_feature_str  = lookup('gbl_feature_str', {value_type => String})

  $gbl_scripts_loc_arr  = join_keys_to_values(  lookup('scripts_file_location', {value_type => Hash}), '=')

  $ps_location_arr = join_keys_to_values( lookup(join2strings ($cfg_environ_name, '_ps_location'), {value_type => Hash}), '=')

  #------------- END value assignemnt-----------------------------

  
  #notify {"dappsndm1_1_psbrkhnd_cnfdsp_attrib   ${psbrkhnd_cnfdsp_att_arr[0]}":}
  #notify {"dappsndm1_1_psbrkhnd_cnfdsp_attrib   ${psbrkhnd_cnfdsp_att_arr[1]}":}
  

  ##notify {"local Array0    ${psrensrv_att_arr[0]}":}
  ##notify {"gbl_feature_str ${gbl_feature_str}":}

  dapps_config_app_server{ $cfg_domain_name: 
       ensure               => present,
       startup_attrib       => $startup_att_arr,
       domain_attrib        => $domain_att_arr,
       listeners_port       => $port_att_arr,
       pwd_attrib           => $pwd_att_arr,
       psappsrv_attrib      => $psappsrv_att_arr,
       psrensrv_attrib      => $psrensrv_att_arr,
       pstools_attrib       => $pstools_att_arr,
       procs_attrib         => $procs_att_arr,
       smtp_attrib          => $smtp_att_arr,
       jolt_attrib            => $jolt_att_arr,
       workstation_attrib     => $workstation_att_arr,
       psqrysrv_attrib        => $psqrysrv_att_arr,
       psmonitorsrv_attrib    => $psmonitorsrv_att_arr,
       psbrkdsp_dflt_attrib    => $psbrkdsp_dflt_att_arr,
       psbrkhnd_dflt_attrib    => $psbrkhnd_dflt_att_arr,
       pssubdsp_dflt_attrib    => $pssubdsp_dflt_att_arr,
       pssubhnd_dflt_attrib    => $pssubhnd_dflt_att_arr,
       pspubdsp_dflt_attrib    => $pspubdsp_dflt_att_arr,
       pspubhnd_dflt_attrib    => $pspubhnd_dflt_att_arr,
       psbrkdsp_cnfdsp_attrib  => $psbrkdsp_cnfdsp_att_arr,
       psbrkhnd_cnfdsp_attrib  => $psbrkhnd_cnfdsp_att_arr,
       pssubdsp_cnfsub_attrib  => $pssubdsp_cnfsub_att_arr,
       pssubhnd_cnfsub_attrib  => $pssubhnd_cnfsub_att_arr,
       psbrkdsp_mftdsp_attrib  => $psbrkdsp_mftdsp_att_arr,
       psbrkhnd_mftdsp_attrib  => $psbrkhnd_mftdsp_att_arr,
       pspubdsp_mftpub_attrib  => $pspubdsp_mftpub_att_arr,
       pspubhnd_mftpub_attrib  => $pspubhnd_mftpub_att_arr,
       msln_attrib          => $msln_att_arr,
       feature_settings_str => $domain_feature_str,
       scripts_location     => $gbl_scripts_loc_arr,
       ps_location          => $ps_location_arr,
  }
}

