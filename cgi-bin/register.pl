#!/usr/bin/perl
#
# Initial form for user registration. Change all strings according to your local needs.
# Ondrej Chvala, <ochvala@utk.edu>
# Released under GNU GPL v3

use CGI ':standard';
use strict;
use warnings;
use diagnostics; # will help you understand the error messages

my $debug= 0;
my $salt = "00ennfads99324rd";		# random string, should be changed for a new installation
my $ddir = "/var/cache/register/";	# directory to keep registration requests
my $userdomain = "utk.edu";		# email domain used for account confirmation

print header;
print start_html('NE362: Get account at USHA','ochvala(at)utk.edu'),
    h1('Register account with USHA machine. NE362 students only.'),
    start_form,
    "First name: ",textfield('fname'), p,
    "Last name: ",textfield('lname'), p,
    "UTK Net ID: ",textfield('netid'), p,
    submit,
    end_form,
    hr;

if (param()) {
    my $name  = param('fname')." ".param('lname');
    my $netid = param('netid');
    my $pass  = `</dev/urandom tr -dc A-Za-z1-9 | head -c8`;
    my $key   = $salt.`echo $netid | sha256sum | tr -dc A-Za-z0-9 `;
    my $path  = $ddir.$key;

    if (-e $path && !$debug) {
        print h3("Email with your password has already been sent to $netid\@utk.edu. 
           Please click the link in the email to activate your account.");
    } else { 
	### Write key file ###
        open(FOUT, "> $path")
            or die "Couldn't open $path for writing: $!\n";
        print FOUT "$netid:$pass:$name";
        close FOUT;

	### Send the email ###
	my $to   = $netid.'@'.$userdomain;
	open(MAIL, "|/usr/sbin/sendmail -t");
	print MAIL "From: o\@usha.engr.utk.edu\n";
	print MAIL "To: $to\n";
	print MAIL "Subject: Create account at usha.engr.utk.edu\n\n";
	print MAIL "Hi $name!\n\nYour account at usha.engr.utk.edu will be activated by clicking at this link:\n
http://usha.engr.utk.edu/cgi-bin/confirm.pl?i=$key\n
You can also copy the above link to a browser.\n

Your login name is: $netid and your password is: $pass
Please change your password.

For a simple how-to get started on the Usha system see here:
http://usha.engr.utk.edu/howto.html\n
Regards,\nOndrej Chvala";
	close MAIL;

        if($debug) {  print "Your name is: $name", p,
		  "Your login name: $netid", p,
		  "Your password is: $pass", p, "key: $key", p; }
	print h3("Email with your account credentials was sent to $netid\@utk.edu. 
	  Please click the link in the email to activate your account."),hr;
   }
}
print a({href=>'mailto:ochvala (at) utk.edu'},'Email me if you have problems.');
print end_html;

