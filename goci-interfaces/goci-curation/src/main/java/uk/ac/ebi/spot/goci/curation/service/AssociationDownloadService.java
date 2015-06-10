package uk.ac.ebi.spot.goci.curation.service;

import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.model.Association;
import uk.ac.ebi.spot.goci.model.EfoTrait;
import uk.ac.ebi.spot.goci.model.SingleNucleotidePolymorphism;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collection;

/**
 * Created by dwelter on 09/04/15.
 * <p>
 * This is a service class to process a set of associations for a given study and output the result to a tsv file
 */


@Service
public class AssociationDownloadService {

    public AssociationDownloadService() {

    }


    public void createDownloadFile(OutputStream outputStream, Collection<Association> associations)
            throws IOException {

        String file = processAssociations(associations);

        // Write file
        outputStream.write(file.getBytes("UTF-8"));
        outputStream.flush();
        outputStream.close();

    }

    private String processAssociations(Collection<Association> associations) {

        String header =
                "Gene\tStrongest SNP-Risk Allele\tSNP\tProxy SNP\tRisk Allele Frequency in Controls\tInteracting SNPs combined risk allele frequency\tP-value mantissa\tP-value exponent\tP-value (Text)\tOR per copy or beta (Num)\tOR entered (reciprocal)\tOR-type? (Y/N)\tMulti-SNP Haplotype?\tSNP:SNP interaction?\tConfidence Interval\tReciprocal confidence interval\tBeta unit and direction\tStandard Error\tSNP type (novel/known)\tSNP Status\tEFO traits\r\n";


        StringBuilder output = new StringBuilder();
        output.append(header);


        for (Association association : associations) {
            StringBuilder line = new StringBuilder();

            extractGeneticData(association, line);

            if (association.getRiskFrequency() == null) {
                line.append("");
            }
            else {
                line.append(association.getRiskFrequency());

            }
            line.append("\t");

            if (association.getPvalueMantissa() == null) {
                line.append("");
            }
            else {
                line.append(association.getPvalueMantissa());

            }
            line.append("\t");

            if (association.getPvalueExponent() == null) {
                line.append("");
            }
            else {
                line.append(association.getPvalueExponent());
            }
            line.append("\t");

            if (association.getPvalueText() == null) {
                line.append("");
            }
            else {
                line.append(association.getPvalueText());
            }
            line.append("\t");

            if (association.getOrPerCopyNum() == null) {
                line.append("");
            }
            else {
                line.append(association.getOrPerCopyNum());
            }
            line.append("\t");

            if (association.getOrPerCopyRecip() == null) {
                line.append("");
            }
            else {
                line.append(association.getOrPerCopyRecip());
            }
            line.append("\t");

            if (association.getOrType() == null) {
                line.append("");

            }
            else {
                if (association.getOrType()) {
                    line.append("Y");
                }
                else {
                    line.append("N");
                }
            }
            line.append("\t");

            if (association.getMultiSnpHaplotype() == null) {
                line.append("");
            }
            else {
                if (association.getMultiSnpHaplotype()) {
                    line.append("Y");
                }
                else {
                    line.append("N");
                }
            }
            line.append("\t");

            if (association.getSnpInteraction() == null) {
                line.append("");
            }
            else {
                if (association.getSnpInteraction()) {
                    line.append("Y");
                }
                else {
                    line.append("N");
                }
            }
            line.append("\t");

            if (association.getOrPerCopyRange() == null) {
                line.append("");
            }
            else {
                line.append(association.getOrPerCopyRange());
            }
            line.append("\t");

            if (association.getOrPerCopyRecipRange() == null) {
                line.append("");
            }
            else {
                line.append(association.getOrPerCopyRecipRange());
            }
            line.append("\t");


            if (association.getOrPerCopyUnitDescr() == null) {
                line.append("");
            }
            else {
                line.append(association.getOrPerCopyUnitDescr());
            }

            line.append("\t");

            if (association.getOrPerCopyStdError() == null) {
                line.append("");
            }
            else {
                line.append(association.getOrPerCopyStdError());
            }

            line.append("\t");

            if (association.getSnpType() == null) {
                line.append("");
            }
            else {
                line.append(association.getSnpType());
            }
            line.append("\t");

            // SNP Status
            extractSNPStatus(association, line);

            if (association.getEfoTraits() == null) {
                line.append("");
            }
            else {
                extractEfoTraits(association.getEfoTraits(), line);
            }
            line.append("\r\n");

            output.append(line.toString());

        }

        return output.toString();
    }

    private void extractSNPStatus(Association association, StringBuilder line) {

        final StringBuilder snpStatuses = new StringBuilder();

        // Only applies to SNP interaction studies
        if (association.getSnpInteraction() != null && association.getSnpInteraction()) {
            association.getLoci().forEach(
                    locus -> {
                        locus.getStrongestRiskAlleles().forEach(
                                riskAllele -> {

                                    // Genome wide Vs Limited List,
                                    // create a comma separated list per
                                    // risk allele
                                    Collection<String> snpStatus = new ArrayList<>();
                                    String commaSeparatedSnpStatus = "";
                                    if (riskAllele.getLimitedList() != null) {
                                        if (riskAllele.getLimitedList()) {
                                            snpStatus.add("LL");
                                        }
                                    }
                                    if (riskAllele.getGenomeWide() != null) {
                                        if (riskAllele.getGenomeWide()) {
                                            snpStatus.add("GW");
                                        }
                                    }
                                    if (!snpStatus.isEmpty()) {
                                        commaSeparatedSnpStatus = String.join(", ", snpStatus);
                                    }
                                    else { commaSeparatedSnpStatus = "NR";}

                                    setOrAppend(snpStatuses, commaSeparatedSnpStatus, " x ");
                                }
                        );
                    }
            );
        }

        line.append(snpStatuses.toString());
        line.append("\t");
    }

    private void extractEfoTraits(Collection<EfoTrait> efoTraits, StringBuilder line) {
        StringBuilder traits = new StringBuilder();
        for (EfoTrait efoTrait : efoTraits) {
            String uri = efoTrait.getUri();
            String[] elements = uri.split("/");

            String id = elements[elements.length - 1];
            setOrAppend(traits, id.trim(), ",");
        }

        line.append(traits.toString());
    }

    private void extractGeneticData(Association association, StringBuilder line) {
        final StringBuilder strongestAllele = new StringBuilder();
        final StringBuilder reportedGenes = new StringBuilder();
        final StringBuilder rsId = new StringBuilder();
        final StringBuilder proxySnpsRsIds = new StringBuilder();
        final StringBuilder riskAlleleFrequency = new StringBuilder();

        // Different delimiters for snp interaction and standard/haplotype associations
        if (association.getSnpInteraction() != null && association.getSnpInteraction()) {

            association.getLoci().forEach(
                    locus -> {
                        locus.getStrongestRiskAlleles().forEach(
                                riskAllele -> {
                                    setOrAppend(strongestAllele, riskAllele.getRiskAlleleName(), " x ");

                                    SingleNucleotidePolymorphism snp = riskAllele.getSnp();
                                    setOrAppend(rsId, snp.getRsId(), " x ");

                                    // Set proxies or 'NR' if non available
                                    Collection<String> currentLocusProxies = new ArrayList<>();
                                    String commaSeparatedProxies = "";
                                    if (riskAllele.getProxySnps() != null) {
                                        for (SingleNucleotidePolymorphism proxySnp : riskAllele.getProxySnps()) {
                                            currentLocusProxies.add(proxySnp.getRsId());
                                        }
                                    }

                                    if (!currentLocusProxies.isEmpty()) {
                                        commaSeparatedProxies = String.join(", ", currentLocusProxies);
                                        setOrAppend(proxySnpsRsIds, commaSeparatedProxies, " x ");

                                    }
                                    else {
                                        setOrAppend(proxySnpsRsIds, "NR", " x ");
                                    }


                                    // Set Risk allele frequency
                                    if (riskAllele.getRiskFrequency() != null &&
                                            !riskAllele.getRiskFrequency().isEmpty()) {
                                        String frequency = riskAllele.getRiskFrequency();
                                        setOrAppend(riskAlleleFrequency, frequency, " x ");
                                    }
                                    else {
                                        setOrAppend(riskAlleleFrequency, "NR", " x ");
                                    }

                                }
                        );

                        // Handle locus genes for SNP interaction studies.
                        // This is so it clear in thE download which group
                        // of genes belong to which interaction
                        Collection<String> currentLocusGenes = new ArrayList<>();
                        String commaSeparatedGenes = "";
                        locus.getAuthorReportedGenes().forEach(gene -> {
                            currentLocusGenes.add(gene.getGeneName().trim());
                        });
                        if (!currentLocusGenes.isEmpty()) {
                            commaSeparatedGenes = String.join(", ", currentLocusGenes);
                            setOrAppend(reportedGenes, commaSeparatedGenes, " x ");
                        }
                        else {
                            setOrAppend(reportedGenes, "NR", " x ");
                        }
                    }
            );
        }
        else {
            // this is a single study or a haplotype
            association.getLoci().forEach(
                    locus -> {
                        locus.getStrongestRiskAlleles().forEach(
                                riskAllele -> {
                                    setOrAppend(strongestAllele, riskAllele.getRiskAlleleName(), ", ");

                                    SingleNucleotidePolymorphism snp = riskAllele.getSnp();
                                    setOrAppend(rsId, snp.getRsId(), ", ");

                                    // Set proxies or 'NR' if non available
                                    Collection<String> currentLocusProxies = new ArrayList<>();
                                    String colonSeparatedProxies = "";
                                    if (riskAllele.getProxySnps() != null) {
                                        for (SingleNucleotidePolymorphism proxySnp : riskAllele.getProxySnps()) {
                                            currentLocusProxies.add(proxySnp.getRsId());
                                        }
                                    }

                                    // For haplotypes ":" is used to separate multiple proxies linked to a single
                                    // risk allele in a haplotype
                                    if (!currentLocusProxies.isEmpty()) {
                                        colonSeparatedProxies = String.join(": ", currentLocusProxies);
                                        setOrAppend(proxySnpsRsIds,  colonSeparatedProxies, ", ");

                                    }
                                    else {
                                        setOrAppend(proxySnpsRsIds, "NR", ", ");
                                    }

                                    // Set Risk allele frequency to blank as its not recorded by curators
                                    // for standard or multi-SNP haplotypes
                                    setOrAppend(riskAlleleFrequency, "", "");

                                }
                        );
                        locus.getAuthorReportedGenes().forEach(gene -> {
                            setOrAppend(reportedGenes, gene.getGeneName().trim(), ", ");
                        });
                    }
            );
        }

        line.append(reportedGenes.toString());
        line.append("\t");
        line.append(strongestAllele.toString());
        line.append("\t");
        line.append(rsId.toString());
        line.append("\t");
        line.append(proxySnpsRsIds.toString());
        line.append("\t");
        line.append(riskAlleleFrequency.toString());
        line.append("\t");

    }


    private void setOrAppend(StringBuilder current, String toAppend, String delim) {
        if (toAppend != null && !toAppend.isEmpty()) {
            if (current.length() == 0) {
                current.append(toAppend);
            }
            else {
                current.append(delim).append(toAppend);
            }
        }
    }
}