#! /usr/bin/perl -w
use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block to work
use Tie::IxHash;

# Define

my @keywords;
push(@keywords, "STAR_ID"); # 
push(@keywords, "DATA_CATEGORY"); # 
push(@keywords, "NUMBER_OF_POINTS"); # 
push(@keywords, "TIME_REFERENCE_FRAME"); # 
push(@keywords, "MINIMUM_DATE"); # 
push(@keywords, "MAXIMUM_DATE"); # 
push(@keywords, "DISPERSION_MEAN_UNITS"); # 
push(@keywords, "REFERENCES"); # 
push(@keywords, "BIBCODES"); # 
push(@keywords, "TELESCOPE"); # 
push(@keywords, "INSTRUMENT"); # 
push(@keywords, "TIME_SERIES_DATA_FILTER"); # 
push(@keywords, "OBSERVATORY_SITE"); # 
push(@keywords, "COLUMN_JD"); # 
push(@keywords, "COLUMN_RELATIVE_MAGNITUDE"); # 
push(@keywords, "COLUMN_RELATIVE_MAGNITUDE_UNCERTAINTY"); # 


my $filename = $ARGV[0];
chomp $filename;


#Declare new filehandle and associated it with filename
open (my $fh, '<', $filename) or die "\nCould not open file '$filename' $!\n";
my @array = <$fh>;
close ($fh);

# This FOR-loop will iterate through the old light curve file. 
for ( my $i = 0 ; $i <= $#array ; $i++ )
{
# This FOR-loop will iterate through the keywords array for each line of the light curve file. 
    for ( my $j = 0 ; $j <= $#keywords ; $j++ )
    {
# This IF-block will check if a line in the light curve file matches one of the keywords.  
        if ( $array[$i] =~ /^\\$keywords[$j]\s+/ )
        {
            print "$array[$i]";
        }
    }
}

