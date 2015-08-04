package FileProcessor;
use File::Find;

my $fileInfo = "";
my $content = "";
my @textFiles = ();

# Creating a object
sub new
{
	my $class = shift;
	my $obj = {};
	bless $obj;
	return $obj;
}

sub getFiles
{
	my $obj = shift;
	my $dir = shift;
	find(\&parse_dir, $dir);
	return @textFiles;
}
	
# Scanning the directory for all .txt files
sub parse_dir
{
	
	if($_ =~ /\.txt$/i)
	{
		print "Found file";
		
		push(@textFiles, $File::Find::name);
	}
        else
        {
                print "Skipping file: $_";
        }

}


sub processFiles
{
    my $obj = shift;
    my $textFiles = shift;
    
    for (@$textFiles)
    {
	
	if(-z $_)
	{
		print "File has zero size.. continue with next file";
		next;
	}

        # Skipping non txt files	
	unless (-T)
	{
		print "Found non txt file. Continue with next file";
		next;
	}
	#next unless -T; # ignore non txt files
	
	processFile($_);
	
    }
    
    return $fileInfo;
}


# Processing each file inside the directory
sub processFile
{
	my $file = shift;
	
	$content = ();
        my $lines = 0;
	my $totalWords = 0;
	my @data = ();
        my $longestSen = 0;
        my $longestLine;
        
        my $size = -s $file; 
 
	open(FILE, $file) or die "Can't open file $file: $!";
	while(<FILE>)
	{
		chomp;
                $lines++;
                

		my @content = split;
		$totalWords += scalar @content;

                my $len = length;
                if ($len > $longestSen)
                {
                  $longestSen = $len;
                   $longestLine = $_;
                }

		
		for (@content)
		{
			if (exists $content->{$_})
			{
				$content->{$_} += 1; 
			}
			else
			{
			    $content->{$_} = 1;
			}
		}

                if(eof)
                {
                      last;
                }
	}
	close(FILE);

        my $tenMostCommonWordsCnt = 0;
        my $tenMostCommonWords = "";
        foreach my $key (sort hashValueDescendingNum (keys(%$content))) {

            if($tenMostCommonWordsCnt == 10)
            {
                last;
                
            }


             $tenMostCommonWordsCnt++;
             $tenMostCommonWords .= "$key,";

        }	
	push(@data, $totalWords);
        push(@data, $tenMostCommonWords);
        push(@data, $longestLine);
        push(@data, $lines);
        push(@data, $size);
	
	$fileInfo->{$file} = [@data];
}

# Generating the report
sub viewReport
{
    my $obj = shift;
    my $fileData = shift;
    my $longestSen = 0;
    my $longestLine = "";
     
    foreach my $key (keys %$fileData)
    {
       my $len = length $fileData->{$key}->[2];
       if ($len > $longestSen)
       {
          $longestSen = $len;
          $longestLine = $fileData->{$key}->[2];
       }

       print "\n\n";
       print "File Name: -------------> $key\t";
       print "No of words: ------------> $fileData->{$key}->[0] \t";
       print "10MostCommonlywords: ------------------> $fileData->{$key}->[1] \t";
       print "longestSentence: ---------------------->  $fileData->{$key}->[2] \t";
       print "Nooflines:-----------------------------> $fileData->{$key}->[3] \t";
       print "size: ---------------------------------> $fileData->{$key}->[4] \t";
       
       print "\n\n";
       print "Largest sentence from all files:---------------------> $longestLine";

    } 
}

# Logic to sort hash in desending order
sub hashValueDescendingNum {
       $content->{$b} <=> $content->{$a};
}

1;