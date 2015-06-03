#!/usr/bin/perl

## Copyright (c) 20014 Kai Knoepfel
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 2
## of the License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.







use SAPNW::Rfc;
use SAPNW::Connection;
use Getopt::Long;

my $timeout = 20;			# Plugin timeout



#
# Dont change anything below these lines ...
#


GetOptions(
    "v"         => \$ver,
    "version"   => \$ver,
    "h"         => \$help,
    "help"      => \$help,			
    "sysnr=i"	=> \$sysnr,			# sapsystem number
    "host=s"	=> \$host,			# monitored-system
    "user=s"	=> \$user,			# monitoring user on remote-system
    "pass=s"	=> \$pass,			# password of monitoring-user on remote-system
    "client=s"	=> \$mandt,			# sap client
	);

version();


if ( $help eq "-h" || $help eq "-help" )
	{
		help();
	}

elsif ( $host eq undef || $sysnr eq undef || $user eq undef || $pass eq undef || $mandt eq undef )
        {
        print "Please use -h or -help to use the script with correct syntax!!\n";
        }
else
        {
		pipe(READ,WRITE);
		$p_pid = $$;
		$c_pid = fork();
		if ( $c_pid )
			{
				close WRITE;	
				
				eval {
    				local $SIG{ALRM} = sub { die "Timelimit excedded $!" };
        			alarm($timeout);
        			$rc = <READ>;
        			alarm 0;
        			
        			};
				
				if ( $@ =~ /Zeitlimit/ ) 
					{
						kill("KILL", $c_pid);
						print "Critical -> No Login possible -> Timeout occured! Please check the systemstate!|login=0\n";
        				exit 2;	
				
					}
				elsif ( $rc == 0 )
					{
						print "OK - SAP Login works fine on $host!|login=1\n";
						exit 0;
					}
				elsif ( $rc == 2 )
					{
						print "CRITICAL - SAP Login don´t work on $host!|login=0\n";
						exit 2;
					}
				elsif ( $rc == 1 )
					{
						 print "WARNING - RFC_LOGON_FAILURE (sm20/sm21)|login=0\n";
                         exit 1;
					}
					
				
			}
		else
			{
			eval {
				$conn = SAPNW::Rfc->rfc_connect(ashost => "$host",
       									sysnr => "$sysnr", 
      	       				      		client => "$mandt",
      	       				            user => "$user", 
                                       	passwd => "$pass");
				};
				
			 if ( $@ =~ /RFC_LOGON_FAILURE/ )
                           	{
                               		 print WRITE 1;
                                       	 exit 1;
                       	 	}

  
  			my $rd = $conn->function_lookup("RFC_PING");
  			my $rc = $rd->create_function_call;

    			eval {
  				$rc->invoke;
    				};
    			
    			if ($@ )	
				{
      					die "RFC Error: $@\n";
					print WRITE 2;
    				}	
			else
				{
					print WRITE 0;
 					$conn->disconnect;
				}
			}
	}





	
sub help{
	if ( $help == "1" ) 
			{
			print "\n";
			print "Usage:\n";
			print "	check_sap_login.pl -host <HOSTNAME> -sysnr <SAP-SYS-NR> -user <USER> -pass <PASS> -client <SAP-CLIENT> \n";
			print "\n";
			print "Optionen:\n";
			print "\n";
			print "	-host: HOSTNAME\n";
			print "\n";
			print "	-sysnr: SAP-System-NR\n";
			print "\n";
			print "	-user: SAP-User (The user must have right to login with rfc!)\n";
			print "\n";
			print "	-pass: Password\n";
			print "\n";
			print "	-client: SAP-Client\n";
			print "\n";
			print "Help:\n";
			print "\n";
			print "	To use this plugin you must installed the sap nwrfcsdk-kit.\n";
			print "	https://support.sap-com/swdc -> My Company Application Components -> Complimentary Software -> SAP NW RFC SDK\n";
			print "\n";
			print "	You need the following perl-modules: SAPNW::Rfc, SAPNW::Connection, Getopt::Long\n";
			print "\n";
			}
		}
		
sub version{
	if ( $ver == "1" )
			{
				print "\n";
				print "Version: \n";
				print "0.1 -> add Getopt::Long\n";
				print "\n";
				print "For changes, ideas or bugs please contact kutte013\@gmail.com\n";
				print "\n";
				exit 0;
			}
		}	