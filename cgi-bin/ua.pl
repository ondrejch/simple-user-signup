#!/usr/bin/perl -w
#
# Script for user registration. Change all strings according to your local needs.
# You need to add the folowing line to /etc/sudoers to make it work
#
# www-data ALL=NOPASSWD:/usr/lib/cgi-bin/ua.pl
#
# Ondrej Chvala, <ochvala@utk.edu>
# Released under GNU GPL v3

$netid=$ARGV[0];
$pass=$ARGV[1];
$name=$ARGV[2];

system("/usr/sbin/useradd -mk /etc/skel/ -s /bin/bash -G fuse -c \"$name,,,NE362 student\" $netid");
system("echo $netid:$pass | /usr/sbin/chpasswd");



