# Check SAP-Login

This plugin only checks the login to sap-system!

First: The nwrfcsdk-kit from sap must be available on icinga-system.
       You can find it here:
       https://support.sap-com/swdc -> My Company Application Components -> Complimentary Software -> SAP NW RFC SDK

# Manpage <<< check_sap_login >>>



### Usage:
	check_sap_login.pl -host < HOSTNAME > -sysnr < SYSNR > -user < USER > -pass < PASSWORD > -client < SAP-CLIENT >
			
### Optionen:
	
	-host: HOSTNAME
	
	-sysnr: SAP-System-NR
	
	-user: < user >
	    The user must have right to login with rfc!
	    
	-pass: < password >
	   
	  
	Help:
		To use this plugin you must installed the sap nwrfcsdk-kit.
	    https://support.sap-com/swdc -> My Company Application Components -> Complimentary Software -> SAP NW RFC SDK
		and you need the following perl-modules: SAPNW::Rfc, SAPNW::Connection, Getopt::Lon	
	
	Version: check_sap_login.pl -v
	
	Help: check_sap_login.pl -h

			
	



