use strict;
use warnings;
 use DBI;

#jdbc:oracle:thin:@ora-vm-060.ebi.ac.uk:1531:spotdev
my $dbh = DBI->connect('DBI:Oracle:spotdev', 'gwas', 'gwa5d6')
                or die "Couldn't connect to database: " . DBI->errstr;

my $sth = $dbh->prepare('select id, platform from study where  platform is not null')
                or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;

          # Read the matching records and print them out
while (my @data = $sth->fetchrow_array()) {
    my $study_id = $data[0];
    my $platform = $data[1];
#    print $platform . "\n";

#    print "$study_id\t$platform\n";

    if($platform =~ /Affymetrix/){
    } elsif ($platform =~ /Illumina/){

    }elsif($platform =~ /Perlegen/){
    }elsif($platform =~ /SNPlex/){

    }elsif($platform =~ /Invader/){



    }else{

        print $platform . "\n";
    }


}

if ($sth->rows == 0) {
    print "No row returned for querry.\n\n";
}

$sth->finish;
$dbh->disconnect;