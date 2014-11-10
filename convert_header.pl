#! /usr/bin/perl -w
use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block to work
use Tie::IxHash;

# Define
my $s1;
my $s1b;
my $s2;
my $s2b;
my $s3;
my $placeholder = 0;
my $JD;

my @keywords;
push(@keywords, "STAR_ID"); # 
push(@keywords, "DATA_CATEGORY"); # 
push(@keywords, "RA"); # 
push(@keywords, "RA_UNITS"); # 
push(@keywords, "DEC"); # 
push(@keywords, "DEC_UNITS"); # 
push(@keywords, "EQUINOX"); # 
push(@keywords, "NUMBER_OF_POINTS"); # 
push(@keywords, "TIME_REFERENCE_FRAME"); # 
push(@keywords, "MINIMUM_DATE"); # 
push(@keywords, "MAXIMUM_DATE"); # 
push(@keywords, "MAXIMUM_DATE_UNITS"); # 
push(@keywords, "MINIMUM_VALUE"); # 
push(@keywords, "MAXIMUM_VALUE"); # 
push(@keywords, "MAXIMUM_VALUE_UNITS"); # 
push(@keywords, "REFERENCES"); # 
push(@keywords, "BIBCODES"); # 
push(@keywords, "TELESCOPE"); # 
push(@keywords, "INSTRUMENT"); # 
push(@keywords, "TIME_SERIES_DATA_FILTER"); # 
push(@keywords, "OBSERVATORY_SITE"); # 
push(@keywords, "COLUMN_JD"); # 
push(@keywords, "COLUMN_RELATIVE_MAGNITUDE"); # 
push(@keywords, "COLUMN_MAGNITUDE_UNCERTAINTY"); # 


my $filename = $ARGV[0];
chomp $filename;


# Declare new filehandle and associated it with filename
open (my $fh, '<', $filename) or die "\nCould not open file '$filename' $!\n";
my @array = <$fh>;
close ($fh);

# Declare new output filehandle for output file 
my @base = split /\./, $filename;
my $newfilename = $base[0] . ".new";
open (my $oh, '>', $newfilename) or die "\nCould not open file '$newfilename' $!\n";


# This FOR-loop will iterate through the old light curve file. 
for ( my $i = 0 ; $i <= $#array ; $i++ )
{
    if ( $array[$i] =~ /#0#/ )
    {
#        print "\n\n ANDROMEDA 0 \n\n";
        $array[$i] =~ s/"#0#"/"mag"/g;
        $placeholder = 1; # activates placeholder flag 
    }
    if ( $array[$i] =~ /#12#/ )
    {
#        print "\n\n ANDROMEDA 12 \n\n";
    }
    if ( $array[$i] =~ /#13#/ )
    {
#        print "\n\n ANDROMEDA 13 \n\n";
    }
    if ( $array[$i] =~ /#14#/ )
    {
#        print "\n\n ANDROMEDA 14 \n\n";
        $array[$i] =~ s/"#14#"/"Warsaw University Telescope"/g;
    }
    if ( $array[$i] =~ /#15#/ )
    {
#        print "\n\n ANDROMEDA 15 \n\n";
        $array[$i] =~ s/"#15#"/"OGLE-III"/g;
    }
    if ( $array[$i] =~ /#16#/ )
    {
 #       print "\n\n ANDROMEDA 16 \n\n";
        $array[$i] =~ s/"#16#"/"I (Johnson)"/g;
    }
    if ( $array[$i] =~ /#17#/ )
    {
#        print "\n\n ANDROMEDA 17 \n\n";
        $array[$i] =~ s/"#17#"/"Las Campanas Observatory"/g;
    }
    if ( $array[$i] =~ /#22#/ )
    {
        $array[$i] =~ s/"#22#"/RELATIVE_MAGNITUDE/g;
    }
    if ( $array[$i] =~ /#23#/ )
    {
        $array[$i] =~ s/"#23#"/MAGNITUDE_UNCERTAINTY/g;
    }
    if ( $array[$i] =~ /COLUMN_JD/ )
    {
#        CAN I GREP OR SED JUST A STRING OF NUMBERS, LIKE \d+ ????
         $array[$i] =~ m/\d+/g; # this line will extract the Julian date 
                                # as a string of digits and put it in $& 
#         print "Found '$&'\n"; # DEBUG statement to show match regex is working 
         $JD = $&;
        # while ($string =~ m/regex/g) {
        #   print "Found '$&'.  Next attempt at character " . pos($string)+1 . "\n";
        # }
    }
# This FOR-loop will iterate through the keywords array for each line of the light curve file. 
    for ( my $j = 0 ; $j <= $#keywords ; $j++ )
    {
# This IF-block will check if a line in the light curve file matches one of the keywords. 
# If there is a match, then extract it and print it out to the new file.   
        if ( $array[$i] =~ /^\\$keywords[$j]\s+/ )
        {
            if ( $array[$i] =~ /MAXIMUM_DATE_UNITS/ )
            {
                $array[$i] =~ s/MAXIMUM_DATE_UNITS/DATE_UNITS        /g;
            }
            if ( $array[$i] =~ /MAXIMUM_VALUE_UNITS/ )
            {
                $array[$i] =~ s/MAXIMUM_VALUE_UNITS/VALUE_UNITS        /g;
            }
            print     "$array[$i]";
            print $oh "$array[$i]";
        }
    }
# This IF-block will print a line from the light curve file if it is a header. 
    if ( ( $array[$i] =~ /^\|/ ) )
    {
        if ( $array[$i] =~ /#22#/ )
        {
            $array[$i] =~ s/#22#/RELATIVE_MAGNITUDE/g;
            for ( my $m = 0 ; $m <= $#array ; $m++ )
            {
                if ( $array[$m] =~ /\|\s\s\s\s\sreal\s\|/ )
                {
                    $s1 .= (" " x ( (length("RELATIVE_MAGNITUDE") ) ) );
                    $array[$m] =~ s/\|\s\s\s\s\sreal/\|$s1 real/g;
                    $s1 = "";
                }
            }            
        }
        if ( $array[$i] =~ /#23#/ )
        {
            $array[$i] =~ s/#23#/MAGNITUDE_UNCERTAINTY/g;
            for ( my $n = 0 ; $n <= $#array ; $n++ )
            {
                if ( $array[$n] =~ /\|\s\s\s\sreal\s\|/ )
                {
                    $s1 .= (" " x ( (length("MAGNITUDE_UNCERTAINTY") - 1 ) ) );
                    $array[$n] =~ s/\|\s\s\s\sreal/\|$s1 real/g;
                    $s1 = "";
                }
            }            
        }
        if ( $array[$i] =~ /\s\s\s\s\s\s\s\s\sJD\s\|/ )
        {
            # my $s11 .= "";
            # $s11 .= (" " x 9 );
            $array[$i] =~ s/\s\s\s\s\s\s\s\s\sJD\s\|/           JD \|/g;
            # $s11 = undef;
# this FOR-loop will fix the next row 
            for ( my $n = 0 ; $n <= $#array ; $n++ )
            {
                if ( $array[$n] =~ /\|\s\s\s\s\s\s\sreal\s\|/ )
                {
                    # $s1 .= (" " x 5 );
                    $array[$n] =~ s/\|\s\s\s\s\s\s\sreal\s\|/\|         real \|/g;
                    # $s1 = "";
                }
            }
        }
# this IF block will delete the fourth column (part 1)
        if ( $array[$i] =~ /\s\sACCEPTED\s\|/ )
        {
            $array[$i] =~ s/\s\sACCEPTED\s\|//g;
        }
# this IF block will delete the fourth column (part 2)
        if ( $array[$i] =~ /\s\s\s\s\s\s\sint\s\|/ )
        {
            $array[$i] =~ s/\s\s\s\s\s\s\sint\s\|//g;
        }
# this IF block will calculate the correct number of new spacing for the 
# last row of the header 
        if  ( ( $array[$i] =~ /\|\s+\|\s+\|\s+\|\s+\|/ ) && ( $placeholder == 1 ) )
        {
            my $s4 .= "";
            my $s5 .= "";
            my $s6 .= "";
            $s6 .= (" " x 14); # JD column 
            $s4 .= (" " x (length("RELATIVE_MAGNITUDE") + 6 ) ); # RELATIVE_MAGNITUDE column 
            $s5 .= (" " x (length("MAGNITUDE_UNCERTAINTY") + 5 ) ); # MAGNITUDE_UNCERTAINTY column 
            $array[$i] =~ s/\|\s+\|\s+\|\s+\|\s+\|/\|$s6\|$s4\|$s5\|/g;
            $s4 = undef;
            $s5 = undef;
            $s6 = undef;
        }
        print     "$array[$i]";
        print $oh "$array[$i]";
    }
# This IF-block will print a line from the light curve file if it is a line of data. 
    if ( ( $array[$i] =~ /^\s+/ ) )
    {
        my @lightcurve = split /\s+/, $array[$i];
        $s1 .= (" " x ( (length("RELATIVE_MAGNITUDE") - length("#22#") + 2 ) ) );
        $s1b .= (" " x ( (length("RELATIVE_MAGNITUDE") - length("#22#") -1 ) ) );
        $s2 .= (" " x ( (length("MAGNITUDE_UNCERTAINTY") - length("#23#") + 2 ) ) );
        $s2b .= (" " x ( (length("MAGNITUDE_UNCERTAINTY") - length("#23#") - 0 ) ) );
        $s3 .= (" " x ( 9 ) );
        if ( $placeholder == 1 )
        {
            print     "  ", sprintf("%.5f", $JD+$lightcurve[1]), " $s1 $lightcurve[2] $s2 $lightcurve[3]\n";
            print $oh "  ", sprintf("%.5f", $JD+$lightcurve[1]), " $s1 $lightcurve[2] $s2 $lightcurve[3]\n";
        }
        else
        {
            print     "  $lightcurve[1] $s1b $lightcurve[2] $s2b $lightcurve[3] $s3 $lightcurve[4]\n";
            print $oh "  $lightcurve[1] $s1b $lightcurve[2] $s2b $lightcurve[3] $s3 $lightcurve[4]\n";
        }
        $s1 = "";
        $s1b = "";
        $s2 = "";
        $s2b = "";
        $s3 = "";
    }
}
    
close ($oh);
