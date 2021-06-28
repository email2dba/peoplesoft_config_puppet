##
##
##
#
class dappsapplserver::dapps_ps_prcs_server($cfg_environ_name,$cfg_domain_name ) {

  #-------------Domain level setting-----------------------------
  $prcs_prcs_scheduler_arr = join_keys_to_values(lookup(join2strings ($cfg_domain_name, '_prcs_process_scheduler'), {value_type => Hash}), '=') +
                           join_keys_to_values(lookup(join2strings ($cfg_environ_name, '_prcs_process_scheduler'), {value_type => Hash}), '=')

  $prcs_pwd_att_arr        = join_keys_to_values(  lookup(join2strings ($cfg_environ_name, '_prcs_pwd_attrib'), {value_type => Hash}) , '=')

  $prcs_db_att_arr         = join_keys_to_values(  lookup(join2strings ($cfg_environ_name, '_prcs_db_attrib'), {value_type => Hash}) , '=')

  #-------------smtp setting--------------------------------------
  $smtp_att_arr     = join_keys_to_values( lookup('gbl_prcs_smtp', {value_type => Hash}) , '=') +
                            join_keys_to_values(lookup(join2strings ($cfg_domain_name, '_prcs_smtp'), {value_type => Hash}), '=')

  #-------------Environment level setting-------------------------

  $prcs_pstools_arr      = join_keys_to_values( lookup(join2strings ($cfg_environ_name, '_prcs_pstools'), {value_type => Hash}), '=') 
  $prcs_psdstsrv_arr     = join_keys_to_values( lookup(join2strings ($cfg_environ_name, '_prcs_psdstsrv'), {value_type => Hash}), '=') 
  $prcs_psaesrv_arr      = join_keys_to_values( lookup(join2strings ($cfg_environ_name, '_prcs_psaesrv'), {value_type => Hash}), '=') 

  $prcs_msln_arr         = join_keys_to_values( lookup('gbl_prcs_msln_attrib', {value_type => Hash}), '=')
  $prcs_sqr_arr          = join_keys_to_values( lookup('gbl_prcs_sqr', {value_type => Hash}), '=')
  $prcs_datamover_arr    = join_keys_to_values( lookup('gbl_prcs_datamover', {value_type => Hash}), '=')
  $prcs_psmonitorsrv_arr = join_keys_to_values( lookup('gbl_prcs_psmonitorsrv', {value_type => Hash}), '=')

  $prcs_feature_str      = lookup('gbl_prcs_feature_str', {value_type => String})
  $prcs_gbl_scripts_loc_arr = join_keys_to_values(  lookup('gbl_prcs_scripts_file_location', {value_type => Hash}), '=')
  $prcs_ps_location_arr  = join_keys_to_values( lookup(join2strings ($cfg_environ_name, '_prcs_ps_location'), {value_type => Hash}), '=')

  #------------- END value assignemnt-----------------------------
  ##notify {"local Array0  ${prcs_prcs_scheduler_arr[0]}":}

  dapps_config_prcs_server{ $cfg_domain_name:
         ensure                     =>present,
         prcs_prcs_scheduler_attrib =>$prcs_prcs_scheduler_arr,
         prcs_db_attrib             =>$prcs_db_att_arr, 
         prcs_pwd_attrib            =>$prcs_pwd_att_arr,
         prcs_pstools_attrib        =>$prcs_pstools_arr, 
         prcs_psdstsrv_attrib       =>$prcs_psdstsrv_arr, 
         prcs_psaesrv_attrib        =>$prcs_psaesrv_arr, 
         prcs_msln_attrib           =>$prcs_msln_arr, 
         prcs_sqr_attrib            =>$prcs_sqr_arr,
         prcs_datamover_attrib      =>$prcs_datamover_arr,
         prcs_psmonitorsrv_attrib   =>$prcs_psmonitorsrv_arr,
         prcs_smtp_attrib           =>$smtp_att_arr,   
         prcs_feature_str           =>$prcs_feature_str, 
         scripts_location           =>$prcs_gbl_scripts_loc_arr ,
         prcs_location              =>$prcs_ps_location_arr, 
  }
}

