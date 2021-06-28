
class dappsapplserver::dapps_ps_web_target_update($cfg_environ_name, $cfg_domain_name) {

##-------------Domain level setting-----------------------------

$webdomain_att_arr = join_keys_to_values(  lookup( join2strings ($cfg_domain_name, '_webdomain_attrib'), {value_type => Hash})   , '=')
$webport_att_arr = join_keys_to_values( lookup( join2strings ($cfg_domain_name, '_webport_attrib'), {value_type => Hash}) , '=') 

##-------------Environment level setting-------------------------
$webadmin_server_arr = join_keys_to_values( lookup( join2strings ($cfg_environ_name, '_webadminserver'), {value_type => Hash}) , '=') 
$web_pwd_arr = join_keys_to_values( lookup( join2strings ($cfg_environ_name, '_web_pwd_attrib'), {value_type => Hash}) , '=') 

$web_environmentname  = lookup(  join2strings ($cfg_environ_name, '_environmentname'), {value_type => String})
$web_location_arr = join_keys_to_values( lookup( join2strings ($cfg_environ_name, '_web_location'), {value_type => Hash}) , '=') 

##-------------Global setting--------------------------------------

$web_lockoutuser_arr = join_keys_to_values( lookup('gblweb_lockoutuser', {value_type => Hash}) , '=') 
$web_profile_arr = join_keys_to_values( lookup('gblweb_profile_attrib', {value_type => Hash}) , '=') 

$web_scripts_loc_arr  = join_keys_to_values(  lookup('gblweb_scripts_file_location', {value_type => Hash}), '=')

$other_web_arr = join_keys_to_values( lookup('other_web_attrib', {value_type => Hash}) , '=') 

#------------- END value assignemnt-----------------------------

##notify {"local Array4  ${domain_att_arr[4]}":}
##notify {"gbl_feature_str ${gbl_feature_str}":}

   dapps_target_update_web_server{ $cfg_domain_name: 
       ensure                 => present,
       webdomain_attrib       => $webdomain_att_arr, 
       webport_attrib         => $webport_att_arr,
       webadmin_server_attrib => $webadmin_server_arr,
       web_pwd_attrib         => $web_pwd_arr, 
       web_env_name_attrib    => $web_environmentname, 
       web_lockoutuser_attrib => $web_lockoutuser_arr,
       web_profile_attrib     => $web_profile_arr, 
       web_location_attrib    => $web_location_arr, 
       web_other_attrib       => $other_web_arr, 
       web_scripts_location   => $web_scripts_loc_arr,
   }
}

