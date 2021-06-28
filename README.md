
# Peoplesoft Domain Configuration using puppet


#### Configure hiera.yaml

Create hiera.yaml file to read People-soft configuration information by puppet.

In this sample  code PS Application server and Web server (PIA) are gets created in poeldapm01.company.com.
Report server gets  created in poeldapm06.company.com

```yaml
---
version: 5

defaults:  # Used for any hierarchy level that omits these keys.
  datadir: data         # This path is relative to hiera.yaml's directory.
  data_hash: yaml_data  # Use the built-in YAML backend.

hierarchy:
  - name: "node1"
    glob: "node1/*"
  - name: "node6"
    glob: "node6/*"
  - name: "nodex"
    glob: "nodex/*"
  - name: "globaldata"
    glob: "global/*"
```

### Peoplesoft Application server Configuration

####  custom  attributes of  PS application server

Application server Domain having following attributes and we have to customize based on your environments

<table>
<tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>
<tr><td>Environment name </td><td> projprd</td><td> resource/projprd/projprd1_1_appl.pp </td></tr>
<tr><td>Domain name </td><td> projprd1_1  </td><td> resource/projprd/projprd1_1_appl.pp  </td></tr>
<tr><td>node </td><td>"poeldapm01.company.com"</td><td> resource/projprd/projprd1_1_appl.pp  </td></tr>
</table>

##### Following attributes will be unique to each application instances on each environments. If we create multiple instances we need to create multiple attribute files.

<table>
<tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>
<tr><td>domainid</td><td>  PRD1_1</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>
<tr><td>domainname</td><td>  PROJPRD1_1</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>
<tr><td>serverhost</td><td>  poeldapm01.company.com</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>


<tr><td>workstation_listenerport</td><td>  15000</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>
<tr><td>joltlistener_jslport</td><td>  22000</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>
<tr><td>joltrelayadapter_listenerport</td><td>  9100</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>

<tr><td>default_http_port</td><td>  8002</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>
<tr><td>default_https_port</td><td>  8003</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>
<tr><td>default_auth_token</td><td>  .company.com</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>

<tr><td>smtpsourcemachine</td><td>  "poeldapm01.company.com"</td><td> data/node1/envrnprd1_1_appl.yaml</td></tr>


</table>

##### Following attributes will be unique on environment level. This file information shares for all PS application instances.

<table>
<tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>
<tr><td>dbname</td><td>  PROJPRD</td><td> data/nodex/envrnprd_appl.yaml</td></tr>
<tr><td>pwd_domainconnectionpwd</td><td>"U2xxxxxxxxxxxxxxxxxxx"</td><td> data/nodex/envrnprd_appl.yaml</td></tr>
<tr><td>pwd_userpswd</td><td>  "U2xxxxxxxxxxxxxxxxxxx"</td><td> data/nodex/envrnprd_appl.yaml</td></tr>
<tr><td>pwd_connectpswd</td><td> "U2xxxxxxxxxxxxxxxxxxx" </td><td> data/nodex/envrnprd_appl.yaml</td></tr>

</table>

##### Following attributes are static for all PS application instances.

<table>
<tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>
<tr><td>ps_home</td><td> "/psoft/pt/ps_home8.58.08"</td><td> data/global/gbl_appl_server.yaml</td></tr>
<tr><td>ps_app_home</td><td>"/psoft/hcm/projstg"</td><td> data/global/gbl_appl_server.yaml</td></tr>
<tr><td>ps_config_home</td><td>"/pscfghome/home/psadmin2/projstg"  </td><td> data/global/gbl_appl_server.yaml</td></tr>
<tr><td>ps_custom_home</td><td> "/psoft/hcm/proj/projstg" </td><td> data/global/gbl_appl_server.yaml</td></tr>
</table>



####  Create PS application server

Login into configuration account (example : psadm2 ) and
execute this puppet command.

```bash
cd resource/projprd
puppet apply  projprd1_1_appl.pp --confdir=./  --debug >./logs/ps_app_serverlog.log
```

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

### Peoplesoft Web server(PIA) Configuration

####  custom  attributes of Web server

Web server Domain having following attributes and we have to customize based on your environments

<table>
<tr><td>Key </td><td> Value  </td><td> Located at   </td></tr>
<tr><td>Environment name </td><td> projprd</td><td> resource/projprd/projprd1_1_web.pp </td></tr>
<tr><td>Domain name </td><td> projprd1_1  </td><td> resource/projprd/projprd1_1_web.pp  </td></tr>
<tr><td>node </td><td>"poeldapm01.company.com"</td><td> resource/projprd/projprd1_1_web.pp  </td></tr>
</table>


NOTE:  Please keep pskey (Certification file ) ready on ./dapps_server_keys directory and file name should be FQDN of host name.

example : If host name is poeldapm01.company.com and pskey for this PIA (PS web server) should be  poeldapm01.company.com

##### Following attributes will be unique to each Web server instances on each environments. If we create multiple instances, we need to create multiple attribute files.

<table>
<tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>

<tr><td>webdomainname </td><td> PROJPRD1_1   </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>
<tr><td>appserverhost </td><td> poeldapm01.company.com  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>
<tr><td>pia_private_key_alias </td><td> poeldapm01-new  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>
<tr><td>pia_name </td><td> PIA  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>
<tr><td>pia_listen_address </td><td> "poeldapm01.company.com"  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>
<tr><td>psserver </td><td> "poeldapm01.company.com:22000"  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>

<tr><td>http_port </td><td> 14002  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>
<tr><td>https_port </td><td> 14003  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>
<tr><td>jslport </td><td> 22000  </td><td>   data/node1/envrnprd1_1_web.yaml    </td></tr>

</table>

##### Following attributes will be unique on environment level. This file information shares for all web server(PIA) instances on this particular environments.

NOTE : If you are creating multiple PIA's for your environments then update the right count.
Also, "all_pia_names" attribute must list all PIA's name excluding the First one which is PIA.

Example : if you are creating three PIA's in this environments then update all_pia_names: 'PIA12,PIA13' and total_pia_count: 3.

<table>
  <tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>
  <tr><td>projprd_environmentname</td> <td> projprd   </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webadminserverhost</td><td> poeldapm01.company.com  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webadmindomainname</td><td> PROJPRD1_1  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webadminservertype</td><td> https  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webadminserverhttp</td><td> "14000"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webadminserverhttps</td><td> "14001"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webadminloginid</td><td> projsystem  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>intgatewayid</td><td> projadmin  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>websitename</td><td> PROJPRD  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>psserver</td><td> "poeldapm01.company.com:20000"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>all_pia_names</td><td> 'PIA12,PIA13'  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>total_pia_count</td><td> 3  </td><td> data/nodex/envrnprd_web.yaml </td></tr>

  <tr><td>piaprivatekeypswd</td><td> "U2FsdxxxxxxxxxxxxhLl6SA6nSaTfh4IIRPB0/zfxIDC"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>pia_trust_keystore_pswd</td><td> "U2Fsdxxxxxxxxxx8oxDuL7VzQy"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>pia_iden_keystorepswd</td><td> "U2Fsdxxxxxxxxxxxxxxxy"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>intgatewaypwd</td><td>  "U2FxxxxxxxxxxxTthrtc="  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>appsrvdomconnpwd</td><td> "U2Fxxxxxxxxxxhrtc="  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webadminloginpwd</td><td> "U2xxxxxxxxxxxhrtc="  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>webProfuserpwd</td><td> "U2Fxxxxxxxxxxxxxxrtc="  </td><td> data/nodex/envrnprd_web.yaml </td></tr>

  <tr><td>ps_home</td><td> "/psoft/pt/ps_home8.58.08"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>ps_app_home</td><td> "/psoft/hcm/projprd"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>ps_config_home</td><td> "/pscfghome/home/psadmin2/projprd"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
  <tr><td>ps_custom_home</td><td> "/psoft/hcm/proj/projprd"  </td><td> data/nodex/envrnprd_web.yaml </td></tr>
</table>

##### Following attributes are static for all WEB server(PIA)  instances.

<table>
  <tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>
  <tr><td>authenticationtokendomain</td><td>  .company.com  </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>reportrepositorypath</td><td>  /psrpt/psreports </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>defltconfigfile</td><td>  deflcfgvalues.cfg </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>pythonbinpath</td><td>  /psdump/software/pt858_03/setup/python/bin </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>weblogicserverhomedir</td><td>  /apps/mwhome/psoft/pt/bea </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>

  <tr><td>webprofuserid</td><td>  PTWEBSERVER </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>webprofile</td><td>  PROD </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>

  <tr><td>ps_home</td><td>  "/psoft/pt/ps_home8.58.08" </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>ps_app_home</td><td>  "/psoft/hcm/projfld" </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>ps_config_home</td><td>  "/pscfghome/home/psadmin2/projfld" </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
  <tr><td>ps_custom_home</td><td>  "/psoft/hcm/proj/projfld" </td><td> data/global/gbl_web_server_attrib_details.yaml </td></tr>
</table>

#### Create WEB server (PIA)
Login into configuration account (example : psadm2 ) and execute this puppet command.

```bash
cd resource/projprd
puppet apply  projprd1_1_web.pp --confdir=./  --debug >./logs/ps_webserverlog.log
```


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

### Peoplesoft Report server Configuration

####  custom  attributes of Report server

Report server Domain having following attributes and we have to customize based on your environments

<table>
<tr><td>Key </td><td> Value  </td><td> Located at   </td></tr>
<tr><td>Environment name </td><td> projprd</td><td> resource/projprd/projprd6_1_prcs.pp </td></tr>
<tr><td>Domain name </td><td> projprd1_1  </td><td> resource/projprd/projprd6_1_prcs.pp  </td></tr>
<tr><td>node </td><td>"poeldapm06.company.com"</td><td> resource/projprd/projprd6_1_prcs.pp </td></tr>
</table>


##### Following attributes will be unique to each Report server instances on each environments. If we create multiple instances we need to create multiple attribute files.

<table>
<tr><td>Key </td><td> Value  </td><td> Located at              </td></tr>
<tr><td>prcsservername</td><td>  PSCBL1  </td><td> data/node6/projprd6_1.yaml </td></tr>
<tr><td>prcssrvrdomain</td><td>  PROJPRD6_1 </td><td> data/node6/projprd6_1.yaml </td></tr>
<tr><td>smtpsourcemachine</td><td>  "poeldapm06.company.com" </td><td> data/node6/projprd6_1.yaml </td></tr>
</table>  

##### Following attributes will be unique on environment level. This file information shares for all Report server instances.

<table>
  <tr><td>Key </td><td> Value  </td><td> Located at    </td></tr>
  <tr><td>dbname </td><td> PROJPRD  </td><td> data/nodex/envrnprd_prcs.yaml   </td></tr>
  <tr><td>environmentname </td><td> projprd </td><td> data/nodex/envrnprd_prcs.yaml   </td></tr>
  <tr><td>ps_home </td><td> "/psoft/pt/ps_home8.58.08" </td><td> data/nodex/envrnprd_prcs.yaml   </td></tr>
  <tr><td>ps_app_home </td><td> "/psoft/hcm/projprd" </td><td> data/nodex/envrnprd_prcs.yaml   </td></tr>
  <tr><td>ps_config_home </td><td> "/pscfghome/home/psadmin2/projprd" </td><td> data/nodex/envrnprd_prcs.yaml   </td></tr>
  <tr><td>ps_custom_home </td><td> "/psoft/hcm/proj/projprd" </td><td> data/nodex/envrnprd_prcs.yaml   </td></tr>
</table>  

##### Following attributes are static for all Report server instances.
<table>
<tr><td>Key </td><td> Value  </td><td> Located at    </td></tr>
<tr><td>smtpserver </td><td>  mail.company.com </td><td> data/global/gbl_prcs_server.yaml </td></tr>
<tr><td>smtpsender </td><td>  "abcd.proj.support.list@company.com"</td><td> data/global/gbl_prcs_server.yaml </td></tr>
<tr><td>ps_home </td><td>  "/psoft/pt/ps_home8.58.08"</td><td> data/global/gbl_prcs_server.yaml </td></tr>
<tr><td>ps_app_home </td><td>  "/psoft/hcm/projstg"</td><td> data/global/gbl_prcs_server.yaml </td></tr>
<tr><td>ps_config_home </td><td>  "/pscfghome/home/psadmin2/projstg_new"</td><td> data/global/gbl_prcs_server.yaml </td></tr>
<tr><td>ps_custom_home </td><td>  "/psoft/hcm/proj/projstg"</td><td> data/global/gbl_prcs_server.yaml </td></tr>
</table>  

#### Create Report server
Login into configuration account (example : psadm2 ) and execute this puppet command.

```bash
cd resource/projprd
puppet apply projprd6_1_prcs.pp  --confdir=./  --debug >./logs/psreportlog.log
```
