use strict;
use warnings;
use DBI;


#
#Returns a list of all the platform field where the script couldn't identify a platform name (ex : Affymetrix, Illumina).
#Most of those will occur when the author of the paper didn not specify the platform but some of them will be typo that
#need correcting with an sql querry like :
#   update study
#   set platform = 'Affymetrix [312,230]'
#   where platform = 'Affyemtrix [312,230]'
#

my $dbh = DBI->connect('DBI:Oracle:spotdev', 'gwas', 'gwa5d6')
                or die "Couldn't connect to database: " . DBI->errstr;

my $sth = $dbh->prepare('select id, study_id from array_info')
                or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;

          # Read the matching records and print them out
while (my @data = $sth->fetchrow_array()) {

    my $array_info_id = $data[0];
    my $study_id = $data[1];

    my $return_code = insert_array_info_id_into_study_table($study_id, $array_info_id);
    if($return_code == 0){
        die "Couldn't save new array info to database!";
    }
}



sub insert_array_info_id_into_study_table {
    # Arguments: database handle; first and last names of new employee;
    # department ID number for new employee's work assignment
    my ($study_id, $array_info_id) = @_;

    my $update_handle = $dbh->prepare_cached('UPDATE study SET array_info_id = ? WHERE id = ?');

    die "Couldn't prepare queries; aborting" unless defined $update_handle;

    my $success = 1;
    $success &&= $update_handle->execute($array_info_id, $study_id);


    my $result = ($success ? $dbh->commit : $dbh->rollback);
    unless ($result) {
        die "Couldn't finish transaction: " . $dbh->errstr
    }

    return $success;   # Success
}