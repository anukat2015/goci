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

my $sth = $dbh->prepare('select id, platform from study where  platform is not null')
                or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;

          # Read the matching records and print them out



while (my @data = $sth->fetchrow_array()) {
    my $array_info_id = '0';
    my $array_info_snp_count = 'NR';
    my $array_info_imputed = '0';
    my $array_info_array_name = 'NR';
    my $array_info_snp_count_qualifier = 'NR';
    my $array_info_platform = 'NR';
    my $array_info_study_id = '0';
    my $array_info_pooled = '0';
    my $array_is_cnv = '0';
    my $array_info_haplotype_snp_count = '0';
    my $array_info_snp_per_haplotype_count = '0';



    my $study_id = $data[0];
    my $platform = $data[1];


    $array_info_study_id = $data[0];

    if($platform =~ /CNVs/){
        $array_is_cnv = '1';
    }
    if($platform =~ /pooled/i ){
        print "platform = $platform, pooled = 1\n";
        $array_info_pooled = '1';
    }else{
    }

    if($platform =~ /imputed/i ){
        $array_info_imputed = '1';

    }

    if(! ($platform =~ /see WTCCC/) ){

    my @platform_data =  split /\[/, $platform;
    my $platform_names = $platform_data[0];


    $platform_names =~ s/,/ /g;
    $platform_names =~ s/and/ /g;
    $platform_names =~ s/\&/ /g;
    $platform_names =~ s/  / /g;
    $platform_names =~ s/  / /g;
#    print "platform_names = $platform_names\n";
#    print "platform_names = $platform_names\n";

    my $name_count = 0;
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

        if($name =~ /Affymetrix/){
            if($name_count == 0){
                $array_info_platform = "Affymetrix";
                $name_count++;
            }else{
                $array_info_platform = $array_info_platform . ", Affymetrix";
            }

            $affy_found = 1;
        }
        if ($name =~ /Illumina/){
            if($name_count == 0){
                $array_info_platform = "Illumina";
                $name_count++;
            }else{
                $array_info_platform = $array_info_platform . ", Illumina";
            }
            $illu_found = 1;
        }
        if($name =~ /Perlegen/){
           if($name_count == 0){
                $array_info_platform = "Perlegen";
                $name_count++;
            }else{
                $array_info_platform = $array_info_platform . ", Perlegen";
            }
            $perlegen_found = 1;
        }
        if($name =~ /SNPlex/){
           if($name_count == 0){
                $array_info_platform = "SNPlex";
                $name_count++;
            }else{
                $array_info_platform = $array_info_platform . ", SNPlex";
            }

            $snplex_found = 1;
        }
        if($name =~ /Invader/){
           if($name_count == 0){
                $array_info_platform = "Invader";
                $name_count++;
            }else{
                $array_info_platform = $array_info_platform . ", Invader";
            }

            $invader_found = 1;
        }
        if($name =~ /Axiom/){
           if($name_count == 0){
                $array_info_platform = "Axiom";
                $name_count++;
            }else{
                $array_info_platform = $array_info_platform . ", Axiom";
            }
            $axiom_found = 1;
        }
        if($platform_names =~ /Affymetrix 6\.0/){
           if($name_count == 0){
                $array_info_platform = "Affymetrix 6.0";
                $name_count++;
            }else{
                $array_info_platform = $array_info_platform . ", Affymetrix 6.0";
            }
            $affy6_found = 1;
        }
        if($platform_names =~ /see WTCCC/){
            if($name_count == 0){
                 $array_info_platform = "see WTCCC";
                 $name_count++;
             }else{
                 $array_info_platform = $array_info_platform . ", see WTCCC";
             }
           $see_WTTC_found = 1;
        }

#TODO : to uncoment for last checking!
#        if($affy6_found == 0 && $see_WTTC_found==0 && $axiom_found == 0 && $affy_found == 0 && $illu_found == 0 && $invader_found == 0 && $snplex_found == 0 && $perlegen_found == 0){
#            print "$study_id =$platform=\n\n";
#        }
    }
    if($name_count == 0){
        $array_info_platform = "NR";

    }

#    print $array_info_platform . "\n";

    if($platform_data[1]){
        $array_info_snp_count = (split /\]/, $platform_data[1])[0];

        print "array_info_snp_count = $array_info_snp_count\n";
#        313,179 SNPs; 339,846 2-SNP haplotypes
        if($array_info_snp_count =~ /NR/){
            $array_info_snp_count = 'NR';
        # Illumina [313,179 SNPs; 339,846 2-SNP haplotypes]
        }elsif($array_info_snp_count =~ /haplotypes/){
            $array_info_snp_count =~ s/,//g;
            my @snp_haplotypes_array = split /;[\s]*/, $array_info_snp_count;
            $array_info_snp_count = (split / /, $snp_haplotypes_array[0])[0];
            $array_info_haplotype_snp_count = (split / /, $snp_haplotypes_array[1])[0];
            $array_info_snp_per_haplotype_count = (split / /, $snp_haplotypes_array[1])[1];
            $array_info_snp_per_haplotype_count =~ s/[\-]SNP//g;
        }elsif($array_info_snp_count =~ />=/){
            $array_info_snp_count_qualifier = ">=";
            $array_info_snp_count=~ s/>=//g;
        }elsif($array_info_snp_count =~ /</){

            $array_info_snp_count_qualifier = "<";
            $array_info_snp_count=~ s/<//g;
        }elsif($array_info_snp_count =~ />/){
            $array_info_snp_count_qualifier = ">";
            $array_info_snp_count=~ s/>//g;

        }elsif($array_info_snp_count =~ /up to ~/i ){
                $array_info_snp_count_qualifier = "<";
                $array_info_snp_count=~ s/up to ~//ig;


        }elsif($array_info_snp_count =~ /~/){
            $array_info_snp_count_qualifier = "~";
            $array_info_snp_count=~ s/~//g;


        }elsif($array_info_snp_count =~ /up to/i ){
            $array_info_snp_count_qualifier = "<";
            $array_info_snp_count=~ s/up to//ig;


        }elsif($array_info_snp_count =~ /CNVs/i){
            $array_info_snp_count=~ s/CNVs//ig;
        }elsif($array_info_snp_count =~ /unsure/ || $array_info_snp_count =~ /UNSURE/){
            $array_info_snp_count = "UNSURE";

        }
        elsif($array_info_snp_count =~ /[0-9]/ && $array_info_snp_count =~ /\,/){
            $array_info_snp_count =~ s/,//g;
        }else{
            print "$platform\n";
            print $study_id ." $array_info_snp_count\n\n";
        }

    }else{
        print "$platform\n";
        print $study_id ." NR snp count = $platform\n\n";
    }
    }

    $array_info_snp_count=~ s/ //g;
    $array_info_snp_count =~ s/,//g;

    my $sth_sequence = $dbh->prepare('select S_GWASARRAY_INFO.nextval from DUAL') or die "Couldn't prepare statement: " . $dbh->errstr;
    $sth_sequence->execute()             # Execute the query
            or die "Couldn't execute statement: " . $sth->errstr;
    while (my @data = $sth_sequence->fetchrow_array()) {
        $array_info_id = $data[0];
    }




    print "$study_id, $platform \n";
    print "\tarray_info_id = $array_info_id\n";
    print "\tarray_info_snp_count = $array_info_snp_count\n";
    print "\tarray_info_imputed = $array_info_imputed\n";
    print "\tarray_info_array_name = $array_info_array_name\n";
    print "\tarray_info_snp_count_qualifier = $array_info_snp_count_qualifier\n";
    print "\tarray_info_platform = $array_info_platform\n";
    print "\tarray_info_study_id = $array_info_study_id\n";
    print "\tarray_info_pooled = $array_info_pooled\n\n";


    my $return_code = insert_array_info($array_info_id, $array_info_snp_count, $array_info_imputed, $array_info_array_name, $array_info_snp_count_qualifier, $array_info_platform, $array_info_study_id, $array_info_pooled, $array_is_cnv, $array_info_haplotype_snp_count, $array_info_snp_per_haplotype_count);
    if($return_code == 0){
        die "Couldn't save new array info to database!";
    }

#    print "$study_id, $platform \n";
#    print "\tarray_info_id = $array_info_id\n";
#    print "\tarray_info_snp_count = $array_info_snp_count\n";
#    print "\tarray_info_imputed = $array_info_imputed\n";
#    print "\tarray_info_array_name = $array_info_array_name\n";
#    print "\tarray_info_snp_count_qualifier = $array_info_snp_count_qualifier\n";
#    print "\tarray_info_platform = $array_info_platform\n";
#    print "\tarray_info_study_id = $array_info_study_id\n";
#    print "\tarray_info_pooled = $array_info_pooled\n\n";




}

if ($sth->rows == 0) {
    print "No row returned for querry.\n\n";
}

$sth->finish;
$dbh->disconnect;




sub insert_array_info {
    # Arguments: database handle; first and last names of new employee;
    # department ID number for new employee's work assignment
    my ($id, $snp_count, $imputed, $array_name, $snp_count_qualifier, $platform, $study_id, $pooled, $is_cnv, $haplotype_snp_count, $snp_per_haplotype_count) = @_;

    if($snp_count =~ /NR/ || $snp_count =~ /UNSURE/ || $snp_count =~ /unsure/){
        $snp_count = undef;
    }

    my $insert_handle = $dbh->prepare_cached('insert into array_info (ID, SNP_COUNT, IMPUTED, ARRAY_NAME, SNP_COUNT_QUALIFIER, PLATFORM, STUDY_ID, POOLED, IS_CNV, HAPLOTYPE_SNP_COUNT,SNP_PER_HAPLOTYPE_COUNT)  values(?,?, ?,?, ?, ? , ?, ?, ?,?,?)');
    my $update_handle = $dbh->prepare_cached('UPDATE study SET PLATFORM_TRANSFERRED = 1 WHERE id = ?');

    die "Couldn't prepare queries; aborting"
        unless defined $insert_handle && defined $update_handle;

        my $success = 1;
                  $success &&= $insert_handle->execute($id, $snp_count, $imputed, $array_name, $snp_count_qualifier, $platform, $study_id, $pooled, $is_cnv,$haplotype_snp_count, $snp_per_haplotype_count);
                  $success &&= $update_handle->execute($study_id);


        my $result = ($success ? $dbh->commit : $dbh->rollback);
                  unless ($result) {
                    die "Couldn't finish transaction: " . $dbh->errstr
                  }

          return $success;   # Success
        }