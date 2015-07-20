use strict;
use warnings;
use DBI;


#
# For each row, copy the STUDY.PLATFORM field to the STUDY.PLATFORM_DUPLICATE field.
#
# perl duplicatePlatformField.pl -i spottst -u gwas -p spottst_password
#
# -i is the spot instance you want to 'attack' (test => spottst, dev => spotdev', pro=> spotpro)
# -u the user name (ex : gwas)
# -p the user password.
#
#
my $spot_db_instance;
my $spot_db_password;
my $spot_db_user;

GetOptions(
    'i=s'    => \$spot_db_instance,
    'p=s'     => \$spot_db_password,
    'u=s'   => \$spot_db_user,
 ) or die "Incorrect usage!\n";

#my $dbh = DBI->connect('DBI:Oracle:spotdev', 'gwas', 'gwa5d6')
my $dbh = DBI->connect('DBI:Oracle:" . $spot_db_instance, $spot_db_user, $spot_db_password)
                or die "Couldn't connect to database: " . DBI->errstr;

my $sth = $dbh->prepare('select id, platform from study where  platform is not null')
                or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;

while (my @data = $sth->fetchrow_array()) {

    my $study_id = $data[0];
    my $platform = $data[1];

    my $return_code = duplicate_platform($study_id, $platform);

}

if ($sth->rows == 0) {
    print "No row returned for querry.\n\n";
}

$sth->finish;
$dbh->disconnect;




sub duplicate_platform {
    # Arguments: database handle; first and last names of new employee;
    # department ID number for new employee's work assignment
    my ($id, $platform) = @_;

    my $update_handle = $dbh->prepare_cached('UPDATE study SET platform_duplicate = ? WHERE id = ?');

    die "Couldn't prepare queries; aborting"
    unless defined $update_handle;

    my $success = 1;
    $success &&= $update_handle->execute($platform, $id);


    my $result = ($success ? $dbh->commit : $dbh->rollback);
    unless ($result) {
        die "Couldn't finish transaction: " . $dbh->errstr
    }

    return $success;   # Success
}