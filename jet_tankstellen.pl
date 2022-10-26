#!/usr/bin/perl

use warnings;
use strict;

my $url = ""; # example url: "https://www.jet-tankstellen.de/tankstellen/hamburg/neuer-kamp-31/";
my $cache_time = 1800; # It's not allowed to update fuel prices much more per hour so we download only all 30 min the new prices

my $price = 0;
my $file = "/tmp/jet.html";
my $cmd = (defined($ARGV[0])) ? $ARGV[0] : '';

sub check_file_age() {
	my $modifiedTimeinDays = -M "$file";

	my $modifiedTimeinSec = $modifiedTimeinDays*60*60*24;
	return $modifiedTimeinSec;
}

sub download() {
	`wget -q -O $file "$url"`;
	return 1;
}

sub grep_and_print() {
	open(my $f, "<", "$file");
	chomp(my @lines = <$f>);
	close $f;

	my $super = 0;
	foreach my $l (@lines) {
		if ($l =~ /Super\s{0,}</gm) {
			# SUPER line found. next eur value is correct
			$super = 1;
		}
		if ($super == 1) {
			if ($l =~ /€ (\d,\d\d)/gm) {
				$price = $1;
				last;
			}
		}
	}
	$price =~ s/,/\./;
	print("price.value $price\n");
	return 1;
}

if ($cmd eq 'config') {
	print("graph_title SUPER fuel @ Jet Tankstelle\n");
	print("graph_args --lower-limit 0\n");
	print("graph_scale no");
	print("graph_category other");
	print("graph_vlabel Euro\n");
	print("price.label Euro per Liter SUPER fuel\n");
	print("price.type GAUGE\n");
	print("price.draw LINE2\n");

	exit(0);
}

if (-e -f -r $file) {
	# read from file
	if (check_file_age() >= $cache_time) {
		`rm $file`;
		download();
	}
	grep_and_print();
} else {
	#download new file
	download();
	grep_and_print();
}

exit(0);
