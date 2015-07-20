use strict;
use warnings;
use DBI;



#select t.TRAIT || '===========' || snp.rs_id
#from  association_efo_trait aet, efo_trait t, association_locus al, LOCUS_RISK_ALLELE lra, RISK_ALLELE_SNP ras, SINGLE_NUCLEOTIDE_POLYMORPHISM snp
#where aet.EFO_TRAIT_ID = t.id
#and aet.ASSOCIATION_ID = al.ASSOCIATION_ID
#and al.LOCUS_ID = lra.LOCUS_ID
#and lra.RISK_ALLELE_ID = ras.RISK_ALLELE_ID
#and ras.SNP_ID = snp.id
#order by t.trait


#my $file_path = "trait2snp.txt";
my $file_path = "trait2snp-bis.txt";


open(my $fh, '<:encoding(UTF-8)', $file_path)
  or die "Could not open file '$file_path' $!";

my $count = 0;
my $trait;
my $snp;
my %trait2snps;
while (my $row = <$fh>) {

    my @array = split(/===========/,$row);
    my $trait = $array[0] ;
    my $snp = $array[1];

#    print "\nTrait = $trait, SNP = $snp";




    if($trait2snps{$trait}){
        my @snps4trait = @{$trait2snps{$trait}};

#        print "\tsnps4trait sup to 0";
        my $found = 0;
        foreach my $mySnp (@snps4trait){
#            print "\tsnp = $mySnp";
            if($snp eq $mySnp){
#                print "snp = mySnp found = 1";
                $found = 1;
            }
        }
        if ($found == 0) {
#            print "\tPush $snp";

            push (@snps4trait, $snp);

        }
        $trait2snps{$trait} = \@snps4trait;


    }else{
        my @snps4trait = ();
#        print "\tsnps4trait < 0";
#        print "\tNo snps for trait $trait yet.";
#        print "\tPush $snp";

        push (@snps4trait, $snp);
#        print "snps4trait size = $#snps4trait";
        $trait2snps{$trait} = \@snps4trait;
        my @newSnps4trait = @{$trait2snps{$trait}};
#        print "newSnps4trait size = $#newSnps4trait";

    }



}

foreach my $trait ( keys %trait2snps )
{
    my @snps = @{$trait2snps{$trait}};
    my $count = scalar @snps;
    print "$trait\t$count\n";
}
