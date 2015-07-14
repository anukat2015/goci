__author__ = 'Tony Burdett'

import sys
import datetime

import urllib
import csv
import subprocess
import json

# usage : python gwas-sparql2json-1.py [1or0]
# ex : python gwas-sparql2json-1.py /my/path/gwas.json /my/path/snp2geneMapping.txt the/url/to/sparql/end/point
# ex : http://localhost:8890/
# arg 1 : the path to the 'to be created' gwas.json file
# arg 2 : path to the snp to gene mapping file
# tab delimited file containing line like : snp_dbSnp_rsId[\t]ensembl_gene_label[\t]ensembl_gene_id
#         eg. : rs10255878    AP1S2P1    ENSG00000226046
#               rs10256972    C7orf50    ENSG00000146540
#               rs10259085    C1GALT1    ENSG00000106392

jsonFilePath = sys.argv[1]
snp2geneMappingFilePath = sys.argv[2]
print snp2geneMappingFilePath
sparqlEndPoint = sys.argv[3]






# first, load the mappings file (rsid -> gene) as a dictionary
#rs_id   consequence_term        ensembl_gene_id_cttv    gene_label
#rs2270368       intron_variant  ENSG00000167208 SNX20
#rs12922317      intron_variant  ENSG00000048471 SNX29
#rs1795648       intron_variant  ENSG00000187672 ERC2
#rs320320        intron_variant  ENSG00000275199 AKT3
#rs3105169       intron_variant  ENSG00000132549 VPS13B
#rs11673344      intron_variant  ENSG00000245680 ZNF585B
snpGeneMappings = {}
with open(snp2geneMappingFilePath) as mappings:
    for a in xrange(1):
        next(mappings)
    for line in csv.reader(mappings, delimiter="\t"):
        if not line[0].startswith("#"):
#            rs_id   consequence_term        ensembl_gene_id_cttv    gene_label
            snp=line[0]
            snp=snp.strip()
            gene=line[2]
            gene=gene.strip()
            so_string = line[1]
            so_string = so_string.strip()
            print "line0=  ", snp
            print "line1=  ", gene
            print "line2=  ", so_string
        if not snp in snpGeneMappings:
            snpGeneMappings[snp] = list()
        gene2soLabel = gene + ":" + so_string;
        snpGeneMappings[snp].append(gene2soLabel)

print "\n\n\n\n"


# clean existing output file
clean = open(jsonFilePath, "w")
clean.close()



# now get sparql results from GWAS catalog

#1 triplet only for testing.
# sparqlurl = sparqlEndPoint + "/sparql?default-graph-uri=&query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+oban%3A+%3Chttp%3A%2F%2Fpurl.org%2Foban%2F%3E%0D%0APREFIX+ro%3A+%3Chttp%3A%2F%2Fwww.obofoundry.org%2Fro%2Fro.owl%23%3E%0D%0APREFIX+efo%3A+%3Chttp%3A%2F%2Fwww.ebi.ac.uk%2Fefo%2F%3E%0D%0APREFIX+gt%3A+%3Chttp%3A%2F%2Frdf.ebi.ac.uk%2Fterms%2Fgwas%2F%3E%0D%0APREFIX+gd%3A+%3Chttp%3A%2F%2Frdf.ebi.ac.uk%2Fdataset%2Fgwas%2F%3E%0D%0A+%0D%0ASELECT+DISTINCT+%3Fsnp+%3Fpubmed_id+%3Fdate+%3Fpvalue+%3Ftrait+%3Fsnpcount+%3Fstudy+%0D%0AWHERE+%7B%0D%0A++%3Fassociation+a+gt%3ATraitAssociation+%3B%0D%0A+++++++++++++++gt%3Ahas_p_value+%3Fpvalue+%3B%0D%0A+++++++++++++++oban%3Ahas_subject+%3Fsnp+%3B%0D%0A+++++++++++++++oban%3Ahas_object+%3Ftrait+%3B%0D%0A+++++++++++++++ro%3Apart_of+%3Fstudy+.%0D%0A++%0D%0A++%3Fstudy+gt%3Ahas_pubmed_id+%3Fpubmed_id+.%0D%0A++FILTER+regex%28str%28%3Fpubmed_id%29%2C+%2215761122%22%29%0D%0A++%3Fstudy+gt%3Ahas_publication_date+%3Fdate+.%0D%0A++OPTIONAL+%7B%3Fstudy+gt%3Ahas_snp_count+%3Fsnpcount%7D%0D%0A%7D&format=text%2Ftab-separated-values&timeout=0&debug=on"


#all for generating complete export file
# "snp"    "pubmed_id"    "date"    "pvalue"    "trait"    "snpcount"    "study"
# "http://rdf.ebi.ac.uk/dataset/gwas/SingleNucleotidePolymorphism/rs9349379"    "21846871"    2011-08-01 00:00:00    "9e-26"    "http://www.ebi.ac.uk/efo/EFO_0001645"    "57500"    "http://rdf.ebi.ac.uk/dataset/gwas/Study/6424"
# "http://rdf.ebi.ac.uk/dataset/gwas/SingleNucleotidePolymorphism/rs17114046"    "21846871"    2011-08-01 00:00:00    "3e-7"    "http://www.ebi.ac.uk/efo/EFO_0001645"    "57500"    "http://rdf.ebi.ac.uk/dataset/gwas/Study/6424"
sparqlurl = sparqlEndPoint + "/sparql?default-graph-uri=&query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+oban%3A+%3Chttp%3A%2F%2Fpurl.org%2Foban%2F%3E%0D%0APREFIX+ro%3A+%3Chttp%3A%2F%2Fwww.obofoundry.org%2Fro%2Fro.owl%23%3E%0D%0APREFIX+efo%3A+%3Chttp%3A%2F%2Fwww.ebi.ac.uk%2Fefo%2F%3E%0D%0APREFIX+gt%3A+%3Chttp%3A%2F%2Frdf.ebi.ac.uk%2Fterms%2Fgwas%2F%3E%0D%0APREFIX+gd%3A+%3Chttp%3A%2F%2Frdf.ebi.ac.uk%2Fdataset%2Fgwas%2F%3E%0D%0A+%0D%0ASELECT+DISTINCT+%3Fsnp+%3Fpubmed_id+%3Fdate+%3Fpvalue+%3Ftrait+%3Fsnpcount+%3Fstudy+%0D%0AWHERE+%7B%0D%0A++%3Fassociation+a+gt%3ATraitAssociation+%3B%0D%0A+++++++++++++++gt%3Ahas_p_value+%3Fpvalue+%3B%0D%0A+++++++++++++++oban%3Ahas_subject+%3Fsnp+%3B%0D%0A+++++++++++++++oban%3Ahas_object+%3Ftrait+%3B%0D%0A+++++++++++++++ro%3Apart_of+%3Fstudy+.%0D%0A++%0D%0A++%3Fstudy+gt%3Ahas_pubmed_id+%3Fpubmed_id+.%0D%0A++%3Fstudy+gt%3Ahas_publication_date+%3Fdate+.%0D%0A++OPTIONAL+%7B%3Fstudy+gt%3Ahas_snp_count+%3Fsnpcount%7D%0D%0A%7D&format=text%2Ftab-separated-values&timeout=0&debug=on"

sparqlresults = urllib.urlretrieve(sparqlurl, "sparql-retrieved-results.txt")


#"study"    "ethnicity"    "ethnic_group"    "indCount"    "type"
#"http://rdf.ebi.ac.uk/dataset/gwas/Study/10073329"    "http://rdf.ebi.ac.uk/dataset/gwas/Ethnicity/10073332"    "NR"    2992    "initial"
#"http://rdf.ebi.ac.uk/dataset/gwas/Study/10073329"    "http://rdf.ebi.ac.uk/dataset/gwas/Ethnicity/10073330"    "European"    3745    "initial"
#"http://rdf.ebi.ac.uk/dataset/gwas/Study/10073329"    "http://rdf.ebi.ac.uk/dataset/gwas/Ethnicity/10073331"    "European"    1152    "replication"
#STUDY_ID_TO_REPLACE
ethnicitySparqlUrl = sparqlEndPoint + "/sparql?default-graph-uri=&query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX+oban%3A+%3Chttp%3A%2F%2Fpurl.org%2Foban%2F%3E%0D%0APREFIX+ro%3A+%3Chttp%3A%2F%2Fwww.obofoundry.org%2Fro%2Fro.owl%23%3E%0D%0APREFIX+efo%3A+%3Chttp%3A%2F%2Fwww.ebi.ac.uk%2Fefo%2F%3E%0D%0APREFIX+gt%3A+%3Chttp%3A%2F%2Frdf.ebi.ac.uk%2Fterms%2Fgwas%2F%3E%0D%0APREFIX+gd%3A+%3Chttp%3A%2F%2Frdf.ebi.ac.uk%2Fdataset%2Fgwas%2F%3E%0D%0A+%0D%0ASELECT+DISTINCT+%3Fstudy+%3Fethnicity+%3Fethnic_group+%3FindCount+%3Ftype%0D%0AWHERE+%7B%0D%0A++%3Fethnicity+ro%3Apart_of+%3Fstudy+.%0D%0A++FILTER+regex%28str%28%3Fstudy%29%2C+%22STUDY_ID_TO_REPLACE%22%29.%0D%0A++%3Fethnicity+a+gt%3AEthnicity+.%0D%0A++++++%3Fethnicity+gt%3Ahas_type+%3Ftype+.%0D%0A+++++%3Fethnicity+gt%3Ahas_ethnic_group+%3Fethnic_group+.%0D%0A+++++%3Fethnicity+gt%3Ahas_number_of_individuals+%3FindCount++++++++%0D%0A%7D&format=text%2Ftab-separated-values&timeout=0&debug=on"


json = {}

noMappingCount = 0
totalCount = 0

soName2soId = {"transcript_ablation" : "http://purl.obolibrary.org/obo/SO_0001893","splice_acceptor_variant" : "http://purl.obolibrary.org/obo/SO_0001574","splice_donor_variant" : "http://purl.obolibrary.org/obo/SO_0001575","stop_gained" : "http://purl.obolibrary.org/obo/SO_0001587","frameshift_variant" : "http://purl.obolibrary.org/obo/SO_0001589","stop_lost" : "http://purl.obolibrary.org/obo/SO_0001578","initiator_codon_variant" : "http://purl.obolibrary.org/obo/SO_0001582","transcript_amplification" : "http://purl.obolibrary.org/obo/SO_0001889","inframe_insertion" : "http://purl.obolibrary.org/obo/SO_0001821","inframe_deletion" : "http://purl.obolibrary.org/obo/SO_0001822","missense_variant" : "http://purl.obolibrary.org/obo/SO_0001583","splice_region_variant" : "http://purl.obolibrary.org/obo/SO_0001630","incomplete_terminal_codon_variant" : "http://purl.obolibrary.org/obo/SO_0001626","stop_retained_variant" : "http://purl.obolibrary.org/obo/SO_0001567","synonymous_variant" : "http://purl.obolibrary.org/obo/SO_0001819","coding_sequence_variant" : "http://purl.obolibrary.org/obo/SO_0001580","mature_miRNA_variant" : "http://purl.obolibrary.org/obo/SO_0001620","5_prime_UTR_variant" : "http://purl.obolibrary.org/obo/SO_0001623","3_prime_UTR_variant" : "http://purl.obolibrary.org/obo/SO_0001624","non_coding_transcript_exon_variant" : "http://purl.obolibrary.org/obo/SO_0001792","intron_variant" : "http://purl.obolibrary.org/obo/SO_0001627","NMD_transcript_variant" : "http://purl.obolibrary.org/obo/SO_0001621","non_coding_transcript_variant" : "http://purl.obolibrary.org/obo/SO_0001619","upstream_gene_variant" : "http://purl.obolibrary.org/obo/SO_0001631","downstream_gene_variant" : "http://purl.obolibrary.org/obo/SO_0001632","TFBS_ablation" : "http://purl.obolibrary.org/obo/SO_0001895","TFBS_amplification" : "http://purl.obolibrary.org/obo/SO_0001892","TF_binding_site_variant" : "http://purl.obolibrary.org/obo/SO_0001782","regulatory_region_ablation" : "http://purl.obolibrary.org/obo/SO_0001894","regulatory_region_amplification" : "http://purl.obolibrary.org/obo/SO_0001891","regulatory_region_variant" : "http://purl.obolibrary.org/obo/SO_0001566","feature_elongation" : "http://purl.obolibrary.org/obo/SO_0001907","feature_truncation" : "http://purl.obolibrary.org/obo/SO_0001906","intergenic_variant" : "http://purl.obolibrary.org/obo/SO_0001628","nearest_gene_five_prime_end" : "http://targetvalidation.org/sequence/nearest_gene_five_prime_end"}
soName2probability = {"transcript_ablation" : "1","splice_acceptor_variant" : "0.971428571","splice_donor_variant" : "0.942857143","stop_gained" : "0.914285714","frameshift_variant" : "0.885714286","stop_lost" : "0.857142857","initiator_codon_variant" : "0.828571429","transcript_amplification" : "0.8","inframe_insertion" : "0.771428571","inframe_deletion" : "0.742857143","missense_variant" : "0.714285714","splice_region_variant" : "0.685714286","incomplete_terminal_codon_variant" : "0.657142857","stop_retained_variant" : "0.628571429","synonymous_variant" : "0.6","coding_sequence_variant" : "0.571428571","mature_miRNA_variant" : "0.542857143","5_prime_UTR_variant" : "0.514285714","3_prime_UTR_variant" : "0.485714286","non_coding_transcript_exon_variant" : "0.457142857","intron_variant" : "0.428571429","NMD_transcript_variant" : "0.4","non_coding_transcript_variant" : "0.371428571","upstream_gene_variant" : "0.342857143","downstream_gene_variant" : "0.314285714","TFBS_ablation" : "0.285714286","TFBS_amplification" : "0.257142857","TF_binding_site_variant" : "0.228571429","regulatory_region_ablation" : "0.2","regulatory_region_amplification" : "0.171428571","regulatory_region_variant" : "0.142857143","feature_elongation" : "0.114285714","feature_truncation" : "0.085714286","intergenic_variant" : "0.057142857","nearest_gene_five_prime_end" : "0.028571429"}


out = open(jsonFilePath, "a")


unique_string_array = []

# parse results and serialize to JSON
with open(sparqlresults[0]) as results:
    for b in xrange(1):
        next(results)
    for line in csv.reader(results, delimiter="\t"):
        print "line = ", line;
        totalCount += 1
        if not line[0].startswith("#"):
            # grab snp, can we map?
            snpid = line[0]
            snpid = snpid[63:]
            pid = line[1]
            snpCount = line[5]
            studyId = line[6]

            #might be undefined, check for that TODO

            print "study_id = ", studyId

            studyIdUrlProofed = studyId.replace(":", "%3A")
            studyIdUrlProofed = studyId.replace("/", "%2F")
            url = ethnicitySparqlUrl.replace("STUDY_ID_TO_REPLACE", studyIdUrlProofed);
            print "url = ", url


            numberOfIndividual = 0
            ethnicitySparqlResults = urllib.urlretrieve(url, "ethnicity-sparql-retrieved-results.txt")
            with open(ethnicitySparqlResults[0]) as ethnicityResults:
                for c in xrange(1):
                    next(ethnicityResults)
                for ethnicityLine in csv.reader(ethnicityResults, delimiter="\t"):
                    ethnicityCount = ethnicityLine[3]
                    if ethnicityCount is None:
                        numberOfIndividual =  numberOfIndividual
                    else:
                        if ethnicityCount and ethnicityCount.strip():
                            numberOfIndividual =  numberOfIndividual  + int(ethnicityCount)
                        else:
                            numberOfIndividual =  numberOfIndividual

            print ""
            print "numberOfIndividual = ", numberOfIndividual
            print "snpCount = ", snpCount
            print "pid=  ", pid
            print "snpid = ", snpid

        if not snpid in snpGeneMappings:
            noMappingCount += 1
            print "NO MAPPING snpid = " + snpid
        else:
            for gene2so in snpGeneMappings[snpid]:
                geneid, so = gene2so.split(":")
                print "Generating JSON for gene '" + geneid + " -> SNP '" + snpid + "'"
                soId = soName2soId[so]
                geneToVariantProbability=soName2probability[so]
                print "soId" + soId

                pmid = ""
                curated_date = ""
                efo_disease = ""
                for i in range(len(line)):
                    if i == 1:
                        pmid = line[i]
                    if i == 2:
                        curated_date = line[i]
                    if i == 3:
                        pval = line[i]
                    if i == 4:
                        efo_disease = line[i]
                        print "efo_disease = ", efo_disease

                json["sourceID"] = "gwascatalog"
                json["validated_against_schema_version"] = "1.2.1"
                json["type"] = "genetic_association"
                json["access_level"]="public"

                json["unique_association_fields"] = {
                    "variant": "http://identifiers.org/dbsnp/" + snpid,
                    "object": efo_disease,
                    "study_name": "cttv009_gwas_catalog",
                    "pubmed_refs": "http://europepmc.org/abstract/MED/" + pmid,
                    "pvalue": pval,
                    "target": "http://identifiers.org/ensembl/" + geneid,
                    "sample_size" : str(numberOfIndividual),
                    "gwas_panel_resolution" : snpCount}

                unique_string = "snp=" + snpid + "efo=" + efo_disease + "pubmed=" + pmid + "pval=" + pval + "geneid=" + geneid + "sample_size=" + str(numberOfIndividual) + "gwas_panel_resolution" + snpCount



                target = {}
                target["id"] = ["http://identifiers.org/ensembl/" + geneid]
                target["target_type"] = "http://identifiers.org/cttv.target/gene_evidence"
                target["activity"] = "http://identifiers.org/cttv.activity/predicted_damaging"
                json["target"] = target

                variant = {}
                variant["id"] = ["http://identifiers.org/dbsnp/" + snpid]
                variant["type"] = "snp single";
                json["variant"] = variant

                disease = {}
                disease["id"] = [efo_disease]
                json["disease"] = disease

                evidence = {}

                evidence_probability = float(geneToVariantProbability) * float(pval)


                gene2variant = {}
                gene2variant["evidence_codes"]= "http://identifiers.org/eco/cttv_mapping_pipeline"
                gene2variant["functional_consequence"]=soId
                gene2variant_resource_score = {}
                gene2variant_resource_score["type"] = "probability"
                gene2variant_resource_score["value"] = float(geneToVariantProbability)
                gene2variant["resource_score"] = gene2variant_resource_score


                #2015-2-5T13:38:44
                d = datetime.datetime.now()
                year = str(d.year)

                month = str(d.month)
                if len(month) == 1 :
                    month = "0"+month

                day = str(d.day)
                if len(day) == 1 :
                    day = "0"+day

                hour = str(d.hour)
                if len(hour) == 1 :
                    hour = "0"+hour

                minute = str(d.minute)
                if len(minute) == 1 :
                    minute = "0"+minute

                second = str(d.second)
                if len(second) == 1 :
                    second = "0"+second

                dateAsserted = year + "-" + month + "-" + day + "T" + hour + ":" + minute + ":" + second + "+00:00"

                provenance_type = {}
                database = {}
                database["version"] = dateAsserted
                database["id"] = "GWAS Catalog"
                dbxref = {}
                dbxref["version"] = dateAsserted
                #TODO
                dbxref["id"] = "http://identifiers.org/gwascatalog"
                database["dbxref"] = dbxref
                provenance_type["database"] = database

                expert = {}
                expert["statement"] = "Primary submitter of data"
                expert["status"] = "true"
                provenance_type["expert"] = expert

                gene2variant["provenance_type"] = provenance_type

                gene2variant["is_associated"] = "true"

                #TODO
                gene2variant["date_asserted"] = dateAsserted
                gene2variant["evidence_codes"] = ["http://purl.obolibrary.org/obo/ECO_0000205","http://identifiers.org/eco/cttv_mapping_pipeline"]
                gene2variant["functional_consequence"] = soId;

                evidence["gene2variant"] = gene2variant


                variant2disease = {}
                variant2disease_resource_score = {}
                variant2disease_resource_score["type"]="pvalue"
                variant2disease_resource_score["value"]=float(pval)
                variant2disease_resource_score_method = {}
                variant2disease_resource_score_method["description"]="pvalue for the snp to disease association."
                variant2disease_resource_score["method"]=variant2disease_resource_score_method
                variant2disease["resource_score"] = variant2disease_resource_score

                if numberOfIndividual != 0:
                    variant2disease["gwas_sample_size"]=int(numberOfIndividual)


                if snpCount and snpCount.strip():
                    variant2disease["gwas_panel_resolution"]=int(snpCount)


                variant2disease["unique_experiment_reference"] = "http://europepmc.org/abstract/MED/" + pmid

                provenance_type = {}
                literature = {}
                literature["references"] = [{"lit_id":"http://europepmc.org/abstract/MED/" + pmid}]
                provenance_type["literature"] = literature

                database = {}
                database["version"] = dateAsserted
                database["id"] = "GWAS Catalog"
                dbxref = {}
                #TODO
                dbxref["version"] = dateAsserted
                #TODO url?
                #TODO
                dbxref["id"] = "http://identifiers.org/gwascatalog"
                database["dbxref"] = dbxref
                provenance_type["database"] = database

                #TODO
                expert = {}
                expert["statement"] = "Primary submitter of data"
                expert["status"] = "True"
                provenance_type["expert"] = expert

                variant2disease["provenance_type"] = provenance_type

                variant2disease["is_associated"] = "True"
                #TODO
                variant2disease["date_asserted"] = dateAsserted
                variant2disease["evidence_codes"] = ["http://identifiers.org/eco/GWAS","http://purl.obolibrary.org/obo/ECO_0000205"]
                evidence["variant2disease"] = variant2disease

                json["evidence"] = evidence;

                if unique_string not in unique_string_array:
                    unique_string_array.append(unique_string)

                    jsonString = str(json)
                    jsonString = jsonString.replace("'", "\"");
                    jsonString = jsonString.replace("\"True\"", "true")
                    jsonString = jsonString.replace("\"true\"", "true")
                    jsonString = jsonString.replace("None", "null")
                    out.write(jsonString)
                    out.write("\n")
                else:
                    print "DUPLICATE : snp = ", snp, " gene = ", gene, " pval = ", pval , "efo = ", efo_disease


out.close()

#for oneJson in fullJson :
#    oneJsonString = str(oneJson)
##    if "rs975730" in oneJsonString:
#        print "rs97573  in json "
#    oneJsonString = oneJsonString.replace("'", "\"");
#    oneJsonString = oneJsonString.replace("True", "true")
#    oneJsonString = oneJsonString.replace("None", "null")
#    out.write(oneJsonString)
#out.write("\n")
#out.close()



print "No Mapping Count = "
print noMappingCount
print "Total Count = "
print totalCount

