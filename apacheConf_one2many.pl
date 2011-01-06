#!/usr/bin/perl

my $configFile		= "/root/test.conf";
my $outputFolder 	= "/root/configfiles";

open(CONF, $configFile) || die("Could not open " . $configFile . "\n");
my $curIP = "";
my $curHost = "";
my $buf = "";

while(<CONF>) {


	if ( $_ =~ m/.*<VirtualHost (.+)(:\d+)?>.*/ ) {
		$curIP = $1;
	} elsif ($_ !~ m/.*<\/VirtualHost>.*/) {
		$buf .= $_ if ($_ !~ m/\s*#.*/) && ($_ ne "\n"); # Legg til linje i buffer hvis det ikke er en kommentar.

			if ($_ =~ m/.*ServerName (.+).*/i) { $curHost = $1; } 
	} else {
		my @ipInfo = split(/:/, $curIP, 2);
		writeConf($ipInfo[0], $ipInfo[1], $curHost, $buf) if $curHost 
			or print("FaWK! I got data but no hostname to assign it with. This should NOT happen!\n");
		$curHost, $curIP, $buf = "";
	}
}
close(CONF);

sub writeConf {
	my ($ip, $port, $host, $data) = @_;

	print("Host: " . $host . "\n");
	print("IP: " . $ip . " Port: " . $port . "\n");
	print($data);
	print("\n");


	mkdir("$outputFolder/$ip");

	open(FILE, ">$outputFolder/$ip/$host");
	print FILE "<VirtualHost " . $host . ":" . $port . ">\n" if $port
		or print FILE "<VirtualHost " . $host . ">\n";
	print FILE $data;
	print FILE "</VirtualHost>\n";
	close(FILE); 

}
