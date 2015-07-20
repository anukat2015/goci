use strict;
use warnings;
use DBI;


#select t.TRAIT || '=============' || s.pubmed_id
#from  association a, association_efo_trait aet, efo_trait t, study s
#where a.STUDY_ID = s.id
#and a.id = aet.ASSOCIATION_ID
#and aet.EFO_TRAIT_ID = t.id
#order by t.trait


my $file_path = "trait2pmid.txt";


open(my $fh, '<:encoding(UTF-8)', $file_path)
  or die "Could not open file '$file_path' $!";

my $count = 0;
my $trait;
my $pmid;
my %trait2pmids;
while (my $row = <$fh>) {

    my @array = split(/=============/,$row);
    my $trait = $array[0] ;
    my $pmid = $array[1];

    print "\nTrait = $trait, pmid = $pmid";




    if($trait2pmids{$trait}){
        my @pmids4trait = @{$trait2pmids{$trait}};

#        print "\tpmids4trait sup to 0";
        my $found = 0;
        foreach my $mypmid (@pmids4trait){
#            print "\tpmid = $mypmid";
            if($pmid eq $mypmid){
#                print "pmid = mypmid found = 1";
                $found = 1;
            }
        }
        if ($found == 0) {
#            print "\tPush $pmid";

            push (@pmids4trait, $pmid);

        }
        $trait2pmids{$trait} = \@pmids4trait;


    }else{
        my @pmids4trait = ();
#        print "\tpmids4trait < 0";
#        print "\tNo pmids for trait $trait yet.";
#        print "\tPush $pmid";

        push (@pmids4trait, $pmid);
#        print "pmids4trait size = $#pmids4trait";
        $trait2pmids{$trait} = \@pmids4trait;
        my @newpmids4trait = @{$trait2pmids{$trait}};
#        print "newpmids4trait size = $#newpmids4trait";

    }



}

foreach my $trait ( keys %trait2pmids )
{
    my @pmids = @{$trait2pmids{$trait}};
    my $count = scalar @pmids;
    print "$trait\t$count\n";
}
