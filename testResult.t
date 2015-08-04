#!/perl/bin/perl -w

use Test::More 'no_plan';
use Test::Output;
use Test::Simple;


# Checking if the module is successfully loaded or not.
use_ok( 'FileProcessor' );

use_ok('File::Find');

# Testing object is created successfully
my $obj = new_ok("FileProcessor");

# Verifying if methods are accessible inside module
can_ok ( 'FileProcessor', 'parse_dir' );


can_ok ( 'FileProcessor', 'getFiles' );

can_ok ( 'FileProcessor', 'processFiles' );


can_ok ( 'FileProcessor', 'processFile' );


can_ok ( 'FileProcessor', 'viewReport' );

can_ok ( 'FileProcessor', 'new' );


# Validate if object belongs to respective module
isa_ok($obj, 'FileProcessor');

# Validating if passed correct parameters
like (system("perl FileLookup.pl"), qr|Usage: Absolute directory path is required|, "Testing for correct parameters passed to script");

# Validating if passed right directory to program for further processing
unlike (system("perl FileLookup.pl fasteners"), qr|Please enter the directory.. exiting|, "Testing if entered the wrong directory");

# Validating if passed right directory 
like (system("perl FileLookup.pl fasteners"), qr|Directory is OK|, "Testing if directory is OK");

# Validating if found a file
like (system("perl FileLookup.pl fasteners"), qr|Found file|, "Testing if found any file for further processing");

# Validating if not found any file 
unlike (system("perl FileLookup.pl fasteners"), qr|Did not find any text files inside given directory.. exiting|, "Testing if no file found for further processing");

# Validating if successfully received txt files after all validations
like (system("perl FileLookup.pl fasteners"), qr|File received for further processing|, "Testing if received txt files after all validations");

# Validating if directory contains zero size file.
unlike (system("perl FileLookup.pl fasteners"), qr|File has zero size.. continue with next file|, "Testing for zero size file");

# Validating if directory contains non text files
unlike (system("perl FileLookup.pl fasteners"), qr|Found non txt file. Continue with next file|, "Testing for non text files");

# Validating if directory contains non txt extension files.
like (system("perl FileLookup.pl fasteners"), qr|Skipping file|, "Testing for non txt extension files");

# Validating if succesfully process files
like (system("perl FileLookup.pl fasteners"), qr|Successfully process files|, "Testing if processed files successfully");

# Validating if succesfully process files
like (system("perl FileLookup.pl fasteners"), qr|Successfully view report|, "Testing if view report successfully");



















