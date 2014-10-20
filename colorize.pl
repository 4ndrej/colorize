#!/usr/bin/perl -w
#===============================================================================
#
#         FILE:  colorize.pl
#
#        USAGE:  colorize.pl [--html] -[style][foregroundcolor][backgroundcolor]:[string] 
#
#  DESCRIPTION:  colorize lines via string search from STDIN and outputs them via STDOUT
#
# REQUIREMENTS:  just perl
#         BUGS:  ---
#       AUTHOR:  Daniel Flinkmann ( Daniel AT Flinkmann.de ) 
#      VERSION:  0.4a
#      CREATED:  01/11/08 01:07:09 CEST
#      WEBSITE:	 HTTP://WWW.FLINKMANN.DE/
#===============================================================================

use strict;

# prototype 
#
sub about ();
sub htmlheader ();
sub htmlfooter ();

# variables 
#
my $VERSION = "0.4a" ;
my $row ; 
my $argscount = $#ARGV;  
my $argsnum ; 
my $htmlout = 0;
my $htmlheader = 0;
my $htmlfooter = 0;
my @searchstring ; 
my @colorcode ; 
my @paintway ;
my @colorpresets = ("u18", "u28", "u38", "u48", "u78", "l10", "l20", "l30", "l40", "l70", "l11", "l22", "l33", "l74", "l76") ;

# main 
#
if ($argscount == -1) { 
	print "Error: No options entered !\n" ; 
	about() ; 
}

foreach $argsnum (0 .. $argscount) {
	if ($ARGV[$argsnum] eq "--html") {
		$htmlout = 1;
		htmlheader();
	}
}

foreach $argsnum (0 .. $argscount) {
	if ($ARGV[$argsnum] ne "--html") {
		my $tempstring = $ARGV[$argsnum] ; 
		if ($ARGV[$argsnum] =~ /^[-|+]:/) {
			($paintway[$argsnum],$searchstring[$argsnum]) = $ARGV[$argsnum] =~ m/^([-|+]):(.*)$/  ; 
			$tempstring  = $paintway[$argsnum] .(shift @colorpresets).":".$searchstring[$argsnum] ;
		}
		($paintway[$argsnum], my $ttype, my $tfcol, my $tbcol, $searchstring[$argsnum]) = $tempstring =~ m/^([-|+])(i|u|n|l|b)([0-7])([0-8]):(.*)$/ ;  
		my $type ; 
		if (defined $ttype) {
			if ($ttype eq 'i') {		$type = "7" ;
			} elsif ($ttype eq 'u') { 	$type = "4" ;
			} elsif ($ttype eq 'n') {	$type = "0" ;
			} elsif ($ttype eq 'l') {	$type = "1" ;
			} elsif ($ttype eq 'b') {	$type = "5" ; 
			} else {      about() ;
			}
		} else {
			print "Error: Option: ". $ARGV[$argsnum]." is not correct !!\n"  ;
			about (); 
		}
		if ($htmlout == 1) {
			if ($ttype eq 'i') {
				$colorcode[$argsnum]="<span class=\"color_bg_".($tfcol+30)." color_fg_".($tbcol+40)."\" >";
			} elsif ($ttype eq 'l') { 
				$colorcode[$argsnum]="<span class=\"color_light_fg_".($tfcol+30)." color_light_bg_".($tbcol+40)."\" >" ;
			} else {
				$colorcode[$argsnum]="<span class=\"color_style_".$ttype." color_fg_".($tfcol+30)." color_bg_".($tbcol+40)."\" >";
			}
		} else {
			$colorcode[$argsnum]="\033[".$type.";".($tfcol+30).";".($tbcol+40)."m" ;
		}
	}
}

while (defined($row = <STDIN>)) {
	foreach $argsnum (0 .. $argscount) {
		if ($ARGV[$argsnum] ne "--html") {
			if ($row =~ /$searchstring[$argsnum]/) {
				chomp $row ;
				if ($paintway[$argsnum] =~ /-/) {
					if ($htmlout == 1) {
						$row = $colorcode[$argsnum] . $row . "<\/span>\n";
					} else {
						$row = $colorcode[$argsnum] . $row . "\033[0m\n";
					}
				}
				if ($paintway[$argsnum] =~ /\+/) {
					if ($htmlout == 1) {
						$row =~ s/($searchstring[$argsnum])/$colorcode[$argsnum]$1<\/span>/g;
						$row .= "\n"; 
					} else {
						$row =~ s/($searchstring[$argsnum])/$colorcode[$argsnum]$1\033[0m/g;
						$row .= "\n"; 
					}
				}
			}
		}
	}
	print $row ; 
}

if ( $htmlout == 1 ){
	htmlfooter();
}

exit 0 ; 

# Usage sub 
#

sub about () {
	print "colorize, The stdin-stdout line colorizer, version:$VERSION by daniel flinkmann, www.flinkmann.de (defunct)\n"; 
	print "currently available at https://github.com/4ndrej/colorize public repo\n"; 
	print "\nUsage:\t" ;
	print "Colorize with matching string:\n";
	print "use --html to html output\n";
	print "$0 [--html] [-+]<style><foreground color><background color>:<searchstring>\n\n" ; 
	print "Quick-Usage:\n" ; 
	print "$0 -:<searchstring> -:<searchstring> -:<searchstring>\n" ;
	print "$0 +:<searchstring> +:<searchstring> +:<searchstring>\n\n" ; 
	print "- will colorize whole matching rows, + will colorize the matched portion only.\n" ;
	print "<style>            : n = normal, l = light, u=underscore, i = inverted, b = blinking\n" ; 
	print "<foreground color> : 0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = purple, 6 = cyan, 7 = white\n"; 
	print "<background color> : 0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = purple, 6 = cyan, 7 = white 8 = no Background\n";
	print "<searchstring>     : string\n\n" ;
	print "Note: You can enter as much search strings as you like, however the latter can overwrite the earlier\n"; 
	print "(Searchstrings in +:<searchstring> can be regular expressions, but not in -:<searchstring>)\n\n"; 
	print "Examples:\n"; 
	print "Normal colorisation with users chosen colors\n" ; 
	print "ls -lF / \| $0 -n17:usr -u34:home +l58:etc\n" ;
	print "Prints out the root directory with red/white \"usr\" dir (whole row), underscored yellow/blue \"home\" directory (whole row) and the word etc will be colorized in light purple with no background color.\n\n"; 
	print "Example of a quick colorisation with preset colors:\n"; 
	print "ls -lF / \| $0 -:usr +:home\n" ; 
	print "Prints out the root directory with the first preset color \"usr\" dir (whole row) and second preset  \"home\" directory (only matched word)\n";
	exit (-1) ; 
}

#html header
sub htmlheader () {
	print "<html>\n";
	print "<head>\n";
	print "<title>Output colored by colorize.pl (www.flinkmann.de)</title>\n";
	print "<style type=\"text/css\">\n";
	print "		.color_style_n {}\n";
	print "		.color_style_u {text-decoration:underline}\n";
	print "		.color_style_b {text-decoration:blink}\n";
	print "		.color_fg_30 {color: Black}\n";
	print "		.color_fg_31 {color: Red}\n";
	print "		.color_fg_32 {color: Green}\n";
	print "		.color_fg_33 {color: Yellow}\n";
	print "		.color_fg_34 {color: Blue}\n";
	print "		.color_fg_35 {color: Purple}\n";
	print "		.color_fg_36 {color: Cyan}\n";
	print "		.color_fg_37 {color: White}\n";
	print "		.color_bg_40 {background-color: Black}\n";
	print "		.color_bg_41 {background-color: Red}\n";
	print "		.color_bg_42 {background-color: Green}\n";
	print "		.color_bg_43 {background-color: Yellow}\n";
	print "		.color_bg_44 {background-color: Blue}\n";
	print "		.color_bg_45 {background-color: Purple}\n";
	print "		.color_bg_46 {background-color: Cyan}\n";
	print "		.color_bg_47 {background-color: White}\n";
	print "		.color_bg_48 {}\n";
	print "		.color_bg_30 {color: Black}\n";
	print "		.color_bg_31 {color: Red}\n";
	print "		.color_bg_32 {color: Green}\n";
	print "		.color_bg_33 {color: Yellow}\n";
	print "		.color_bg_34 {color: Blue}\n";
	print "		.color_bg_35 {color: Purple}\n";
	print "		.color_bg_36 {color: Cyan}\n";
	print "		.color_bg_37 {color: White}\n";
	print "		.color_fg_40 {background-color: Black}\n";
	print "		.color_fg_41 {background-color: Red}\n";
	print "		.color_fg_42 {background-color: Green}\n";
	print "		.color_fg_43 {background-color: Yellow}\n";
	print "		.color_fg_44 {background-color: Blue}\n";
	print "		.color_fg_45 {background-color: Purple}\n";
	print "		.color_fg_46 {background-color: Cyan}\n";
	print "		.color_fg_47 {background-color: White}\n";
	print "		.color_fg_48 {}\n";
	print "		.color_light_fg_30 {color: DimGray}\n";
	print "		.color_light_fg_31 {color: LightRed}\n";
	print "		.color_light_fg_32 {color: LightGreen}\n";
	print "		.color_light_fg_33 {color: LightYellow}\n";
	print "		.color_light_fg_34 {color: LightBlue}\n";
	print "		.color_light_fg_35 {color: MediumPurple}\n";
	print "		.color_light_fg_36 {color: LightCyan}\n";
	print "		.color_light_fg_37 {color: GhostWhite}\n";
	print "		.color_light_bg_40 {background-color: DimGray}\n";
	print "		.color_light_bg_41 {background-color: LightRed}\n";
	print "		.color_light_bg_42 {background-color: LightGreen}\n";
	print "		.color_light_bg_43 {background-color: LightYellow}\n";
	print "		.color_light_bg_44 {background-color: LightBlue}\n";
	print "		.color_light_bg_45 {background-color: MediumPurple}\n";
	print "		.color_light_bg_46 {background-color: LightCyan}\n";
	print "		.color_light_bg_47 {background-color: GhostWhite}\n";
	print "		.color_light_bg_48 {}\n";
	print "</style>\n";
	print "</head>\n";
	print "<body>\n";
	print "<pre>\n";
}

#html footer
sub htmlfooter () {
	print "</pre>\n";
	print "</body>\n";
	print "</html>\n";
}
