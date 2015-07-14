use strict;
use warnings;
use DBI;


#
#Returns a list of all the platform field where the script couldn't find the snp count in the following patter :
#   [snp_count]
#
#   update study
#   set platform = 'Affymetrix [312,230]'
#   where platform = 'Affyemtrix [312,230]'
#

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

    if($platform =~ /\[/ && $platform =~ /\]/){
        if($platform =~ /Million/ ){
            my $new_platform = $platform;
            if($platform  =~ /\.[0-9]{1} Million/){
                $new_platform =~ s/\./,/g;
                $new_platform =~ s/ Million/00,000/g;
            }
            if($platform  =~ /\.[0-9]{2} Million/){
                $new_platform =~ s/\./,/g;
                $new_platform =~ s/ Million/0,000/g;
            }
            $new_platform =~ s/&/&' || '/g;
            $platform =~ s/&/&' || '/g;

            print "update study \nset platform = '$new_platform' \nwhere platform = '$platform'\n\n";
        }
        if($platform =~ /million/ ){
                    my $new_platform = $platform;
                    if($platform  =~ /\.[0-9]{1} million/){
                        $new_platform =~ s/\./,/g;
                        $new_platform =~ s/ million/00,000/g;
                    }
                    if($platform  =~ /\.[0-9]{2} million/){
                        $new_platform =~ s/\./,/g;
                        $new_platform =~ s/ million/0,000/g;
                    }
                    $new_platform =~ s/&/&' || '/g;
                    $platform =~ s/&/&' || '/g;

                    print "update study \nset platform = '$new_platform' \nwhere platform = '$platform'\n\n";
                }
#        print $platform . "\n";

    }else{

#        print $platform . "\n";
    }


}

if ($sth->rows == 0) {
    print "No row returned for querry.\n\n";
}

$sth->finish;
$dbh->disconnect;