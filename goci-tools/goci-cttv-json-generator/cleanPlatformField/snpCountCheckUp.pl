use strict;
use warnings;
use DBI;
use Getopt::Long;

#
#Returns a list of all the platform field where the script couldn't find the snp count in the following pattern :
#   [snp_count]
#
#   update study
#   set platform = 'Affymetrix [312,230]'
#   where platform = 'Affyemtrix [312,230]'
#
#
# perl snpCountCheckUp.pl -i spottst -u gwas -p spottst_password
#
# -i is the spot instance you want to 'attack' (test => spottst, dev => spotdev', pro=> spotpro)
# -u the user name (ex : gwas)
# -p the user password.
#


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
my $dbh = DBI->connect('DBI:Oracle:' . $spot_db_instance, $spot_db_user, $spot_db_password)                or die "Couldn't connect to database: " . DBI->errstr;

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

    if($platform =~ /\[/ && $platform =~ /\]/){
         my @a = split(/\[/, $platform);
         my @b = split(/\]/, $a[1]);
         my $snp_count = $b[0];
         if($snp_count !~ /((up to )|[~]|[>]|(Up to ))?((NR)|([123456789,]+)){1}/){
            print  "-- PROBLEM with study is = " .$study_id . " as platform = " . $platform . "\n";

         }

#        Commented out for now but leaving it in case one day the curators are happy to get read of the 'million' strings and have integers instead.
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
            $new_platform =~ s/,//g;

            print "--$platform\nupdate study \nset platform_duplicate = '$new_platform' \nwhere id = '$study_id';\n\n";
        }
        if($platform =~ /million/){
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

            $new_platform =~ s/,//g;

            print "--$platform\nupdate study \nset platform_duplicate = '$new_platform' \nwhere id = '$study_id';\n\n";
        }

    }else{

        print $study_id . " " . $platform . "\n";
    }


}

if ($sth->rows == 0) {
    print "No row returned for querry.\n\n";
}

$sth->finish;
$dbh->disconnect;
