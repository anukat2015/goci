use strict;
use warnings;
use DBI;
use Getopt::Long;


#Returns a list of all the platform field where the script couldn't identify a platform name (ex : Affymetrix, Illumina).
#Most of those will occur when the author of the paper didn not specify the platform but some of them will be typo that
#need correcting with an sql querry like :
#   update study
#   set platform = 'Affymetrix [312,230]'
#   where platform = 'Affyemtrix [312,230]'
#
# perl platformCheckUp.pl -i spottst -u gwas -p spottst_password
#
# -i is the spot instance you want to 'attack' (test => spottst, dev => spotdev', pro=> spotpro)
# -u the user name (ex : gwas)
# -p the user password.


my $spot_db_instance;
my $spot_db_password;
my $spot_db_user;

GetOptions(
    'i=s'    => \$spot_db_instance,
    'p=s'     => \$spot_db_password,
    'u=s'   => \$spot_db_user,
 ) or die "Incorrect usage!\n";



#my $dbh = DBI->connect('DBI:Oracle:spotdev', 'gwas', '')
#my $dbh = DBI->connect('DBI:Oracle:spottst', 'gwas', '')
my $dbh = DBI->connect('DBI:Oracle:' . $spot_db_instance, $spot_db_user, $spot_db_password)
                or die "Couldn't connect to database: " . DBI->errstr;

my $sth = $dbh->prepare('select id, platform_duplicate from study where  platform_duplicate is not null')
                or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;

          # Read the matching records and print them out
while (my @data = $sth->fetchrow_array()) {
    my $study_id = $data[0];
    my $platform = $data[1];
#    print $platform . "\n";

#    print "$study_id\t$platform\n";

#    if($platform =~ /Affymetrix/){
#    } elsif ($platform =~ /Illumina/){
#
#    }elsif($platform =~ /Perlegen/){
#    }elsif($platform =~ /SNPlex/){
#
#    }elsif($platform =~ /Invader/){
#
#
#
#    }else{
#
#        print $platform . "\n";
#    }
    my @platform_data =  split /\[/, $platform;
    my $platform_names = $platform_data[0];


    $platform_names =~ s/,/ /g;
    $platform_names =~ s/and/ /g;
    $platform_names =~ s/\&/ /g;
    $platform_names =~ s/  / /g;
    $platform_names =~ s/  / /g;
#    print "platform_names = $platform_names\n";
#    print "platform_names = $platform_names\n";

    my @platform_names_array = split / /,$platform_names;
    foreach my $name (@platform_names_array){
#        print "$name \n";
        my $affy_found = 0;
        my $illu_found = 0;
        my $invader_found = 0;
        my $snplex_found = 0;
        my $perlegen_found = 0;
        my $axiom_found = 0;
        my $affy6_found = 0;
        my $see_WTTC_found = 0;
        my $platform_name_found = 0;

        if($name =~ /Affymetrix/){
            $affy_found = 1;
        }
        if ($name =~ /Illumina/){
            $illu_found = 1;
        }
        if($name =~ /Perlegen/){
            $perlegen_found = 1;
        }
        if($name =~ /SNPlex/){
            $snplex_found = 1;
        }
        if($name =~ /Invader/){
            $invader_found = 1;
        }
        if($name =~ /Axiom/){
            $axiom_found = 1;
        }
        if($platform_names =~ /Affymetrix 6\.0/){
            $affy6_found = 1;
        }
        if($platform_names =~ /see WTCCC/){
            $see_WTTC_found = 1;
        }
        if($name =~ /NR/){
            $platform_name_found = 1;
        }


        if($affy6_found == 0 && $see_WTTC_found==0 && $axiom_found == 0 && $affy_found == 0 && $illu_found == 0 && $invader_found == 0 && $snplex_found == 0 && $perlegen_found == 0 && $platform_name_found == 0){
#            print "names_array.size = " . scalar @platform_names_array . "\n";
            print "--$platform\nupdate  study \nset platform_duplicate = '$platform' \nwhere id = '$study_id';\n\n";
        }
    }

}

if ($sth->rows == 0) {
    print "No row returned for querry.\n\n";
}

$sth->finish;
$dbh->disconnect;
