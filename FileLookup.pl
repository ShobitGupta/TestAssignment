#! /usr/bin/perl -w

use strict;

use File::Find;
use FileProcessor;
	
$\ = "\n";

if (($#ARGV < 0) || ($#ARGV > 1)) 
{

  print "Usage: Absolute directory path is required";
  exit(1);
}

my $dir = $ARGV[0];

unless (-d $dir)
{
	print "Please enter the directory.. exiting";
	exit(1);
}

print "Directory is OK";

#  Creating a object.
my $fileObj = new FileProcessor ();

# populating files
my @files = $fileObj->getFiles($dir);
if(@files eq 0)
{
   print "Did not find any text files inside given directory.. exiting";
   exit;
}

print "File received for further processing";

# Looping all files for collecting more information
my $fileData = $fileObj->processFiles(\@files);
print "Successfully process files";

# Generating the report
$fileObj->viewReport($fileData);

print "Successfully view report";

exit 0;
# End of main program