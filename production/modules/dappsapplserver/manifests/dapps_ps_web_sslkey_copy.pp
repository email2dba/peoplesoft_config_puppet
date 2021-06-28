
class dappsapplserver::dapps_ps_web_sslkey_copy ($cfg_environ_name, $cfg_domain_name) {
  File {
      mode   => "640",
      owner  => "psadmin2",
      group  => "psoft",
  }

  #-----BEGIN sslkey values ---------------------------------------------

  $ps_sslkey_basedir   = lookup( join2strings ($cfg_environ_name, '_web_location.ps_sslkey_basedir' )  , {value_type => String})
  $appserverhost       = lookup( join2strings ($cfg_domain_name, '_webdomain_attrib.appserverhost' )  , {value_type => String})
  $ps_sslkey_basedir1  = join2strings ($ps_sslkey_basedir,'/')
  $ps_sslkey_dir       = join2strings ($ps_sslkey_basedir1,$appserverhost  )

  $source_sslkey_file  = join2strings ($ps_sslkey_dir, '/pskey' )

  $ps_config_home      = lookup( join2strings ($cfg_environ_name, '_web_location.ps_config_home' ), {value_type => String})
  $ps_domain_dirbase   = join2strings ( $ps_config_home ,"/webserv/" )

  $ps_domain_atrb_str = join2strings ( $cfg_domain_name, '_webdomain_attrib.webdomainname')

  ##$ps_domain_dir       = join2strings ( $ps_domain_dirbase, upper( $cfg_domain_name )) 
  $ps_domain_dir       = join2strings ( $ps_domain_dirbase,  lookup($ps_domain_atrb_str , {value_type => String} )  ) 

  $target_sslkey_file = join2strings ($ps_domain_dir, '/piaconfig/keystore/pskey' )

  #-----END sslkey values ---------------------------------------------
  
  #-----BEGIN  Logo files values --------------------------------------

  $src_file1='/psoft/psoft_scripts/web-logo/signin.html'
  $src_file2='/psoft/psoft_scripts/web-logo/signin.html.donotdelete'
  $src_file3='/psoft/psoft_scripts/web-logo/DAPPS_Rules_of_Behavior.htm'
  $src_file4='/psoft/psoft_scripts/web-logo/OPSE_logo_dapps.gif'

  $base_target=$ps_domain_dir

  $base_target1=join2strings(join2strings ($base_target,"/applications/peoplesoft/PORTAL.war/WEB-INF/psftdocs/"),upper( $cfg_environ_name) )
  $base_target2=join2strings(join2strings ($base_target,"/applications/peoplesoft/PORTAL.war/"), upper( $cfg_environ_name)) 

  
  $target_file1= join2strings($base_target1,"/signin.html")
  $target_file2= join2strings($base_target1,"/signin.html.donotdelete")

  $target_file3= join2strings($base_target2,"/DAPPS_Rules_of_Behavior.htm")
  $target_file4= join2strings( join2strings($base_target2,"/images/"), "OPSE_logo_dapps.gif")

  #-----END  Logo files values ----------------------------------------


  #-----BEGIN sslkey File copy ----------------------------------------

  notify {": pskey file copy begin ":  withpath => true}

  file {$ps_domain_dir:
    ensure => directory,
    owner => 'psadmin2',
    group => 'psoft',
  }

  file {$target_sslkey_file:
    source =>$source_sslkey_file
  }

  notify {" Target SSL KeyFile  $target_sslkey_file":}

  notify {": pskey file copy end ": withpath => false}

  #-----END sslkey File copy ------------------------------------------

  #-----BEGIN Logo File copy ------------------------------------------
  
  notify {": signon.html and logo files copy begin ":  withpath => false}

  file {$base_target1:
    ensure => directory,
    owner => 'psadmin2',
    group => 'psoft',
  }

  file {$target_file1:
    source => $src_file1
  }

  file {$target_file2:
    source => $src_file2,
  }

  file {$target_file3:
    source => $src_file3
  }

  file {$target_file4:
    source => $src_file4
  }

  
  notify {" signon.html Target location $target_file1":}
  notify {" logo Target locaiton $target_file4":}

  notify {" : signon.html and logo files copy end ": withpath => false}
  #----- END Logo File copy -------------------------------------------
}

