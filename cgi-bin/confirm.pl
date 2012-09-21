#!/usr/bin/perl
#
# Confirmation form for user registration. Change all strings according to your local needs.
# Ondrej Chvala, <ochvala@utk.edu>
# Released under GNU GPL v3

use CGI ':standard';
use strict;
use warnings;
use diagnostics; # will help you understand the error messages

my $salt = "00ennfads99324rd"; 		# random string, should be changed for a new installation
my $ddir = "/var/cache/register/";	# directory to keep registration requests

print header;
print start_html('NE362: Get account at USHA','ochvala(at)utk.edu');

my $query = CGI->new;
my $key   = $query->param('i') || "NULL";
my $path  = $ddir.$key;

unless ( -e  $path ) {  # If the key file does not exist
   print h2("Error!"), end_html;
   die "Wrong key.";
}

open(FIN, "< $path");	# read in data
my ($netid, $pass, $name) = split(/:/,<FIN>,3);
close FIN;

my $usexist = `grep $netid /etc/passwd`; chomp $usexist;
if ($usexist) { 	# user already exists
   print h2("Error: user $netid already exists."), end_html;
   die "User already exists.";
}

# Create the account 
system("sudo /usr/lib/cgi-bin/ua.pl $netid $pass \"$name\"");

print h2('USHA machine: for NE362 students only.'),p,
	"Account <b>$netid</b> for user <b>$name</b> was created and activated.",p,
	"See How-To here: ",a({href=>'http://usha.engr.utk.edu/howto.html'},
	'http://usha.engr.utk.edu/howto.html');

print end_html;

