package uk.ac.ebi.spot.goci.model;

import org.apache.solr.client.solrj.beans.Field;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Javadocs go here!
 *
 * @author Tony Burdett
 * @date 16/01/15
 */
public class AssociationDocument extends OntologyEnabledDocument<Association> {
    // basic Association information
    @Field @NonEmbeddableField private String riskFrequency;
    @Field private String qualifier;

    @Field @NonEmbeddableField private Integer pValueMantissa;
    @Field @NonEmbeddableField private Integer pValueExponent;
    @Field @NonEmbeddableField private Float orPerCopyNum;
    @Field @NonEmbeddableField private String orPerCopyUnitDescr;
    @Field @NonEmbeddableField private String orPerCopyRange;
    @Field @NonEmbeddableField private String orType;

    // additional included genetic data...
    // capture loci/risk alleles for association;
    // if many, collapse risk allele and snp into a single field and use
    // 'x' or ',' to separate SNP x SNP and haplotype associations respectively
    @Field private String rsId;
    @Field private String strongestAllele;
    @Field private String context;
    @Field private String region;
    // mapped genes and reported genes must be per snp -
    // if multiple, separate mapped genes with a hyphen (downstream-upstream) and reported genes with a slash,
    // and then include 'x' or ',' as designated by multiple loci/risk alleles
    @Field("entrezMappedGene") private String entrezMappedGene;
    @Field("entrezMappedGeneLinks") private Collection<String> entrezMappedGeneLinks;
    @Field("ensemblMappedGene") private String ensemblMappedGene;
    @Field("ensemblMappedGeneLinks") private Collection<String> ensemblMappedGeneLinks;
    @Field("reportedGene") private Collection<String> reportedGenes;
    @Field("reportedGeneLinks") private Collection<String> reportedGeneLinks;
    @Field @NonEmbeddableField private Long merged;

    @Field("studyId") @NonEmbeddableField private Collection<String> studyIds;

    // pluralise all other information, but retain order
    @Field("chromosomeName") private Set<String> chromosomeNames;
    @Field("chromosomePosition") private Set<Integer> chromosomePositions;

    @Field("locusDescription") @NonEmbeddableField private String locusDescription;

    // embedded study info
    @Field private String pubmedId;
    @Field private String title;
    @Field private String author;
    @Field private String publication;
    @Field private String publicationDate;
    @Field private String catalogPublishDate;
    @Field private String publicationLink;

    @Field private String platform;

    @Field private String initialSampleDescription;
    @Field private String replicateSampleDescription;

    // embedded DiseaseTrait info
    @Field("traitName") private Collection<String> traitNames;

    // embedded EfoTrait info
    @Field("mappedLabel") private Collection<String> mappedLabels;
    @Field("mappedUri") private Collection<String> mappedUris;

    public AssociationDocument(Association association) {
        super(association);
        this.riskFrequency = association.getRiskFrequency();
        this.qualifier = association.getPvalueText();
        this.orPerCopyUnitDescr = association.getOrPerCopyUnitDescr();
        this.orType = String.valueOf(association.getOrType());
        this.orPerCopyRange = association.getOrPerCopyRange();

        if (association.getOrPerCopyNum() != null) {
            this.orPerCopyNum = association.getOrPerCopyNum();
        }
        if (association.getPvalueMantissa() != null) {
            this.pValueMantissa = association.getPvalueMantissa();
        }
        if (association.getPvalueExponent() != null) {
            this.pValueExponent = association.getPvalueExponent();
        }

        this.chromosomeNames = new LinkedHashSet<>();
        this.chromosomePositions = new LinkedHashSet<>();

        this.entrezMappedGeneLinks = new LinkedHashSet<>();
        this.ensemblMappedGeneLinks = new LinkedHashSet<>();
        this.reportedGenes = new LinkedHashSet<>();
        this.reportedGeneLinks = new LinkedHashSet<>();
        this.studyIds = new HashSet<>();
        embedGeneticData(association);

        this.traitNames = new LinkedHashSet<>();

        this.mappedLabels = new LinkedHashSet<>();
        this.mappedUris = new LinkedHashSet<>();
    }

    public String getRegion() {
        return region;
    }

    public String getEntrezMappedGene() {
        return entrezMappedGene;
    }

    public Collection<String> getEntrezMappedGeneLinks() {
        return entrezMappedGeneLinks;
    }

    public String getEnsemblMappedGene() {
        return ensemblMappedGene;
    }

    public Collection<String> getEnsemblMappedGeneLinks() {
        return ensemblMappedGeneLinks;
    }

    public String getStrongestAllele() {
        return strongestAllele;
    }

    public String getRiskFrequency() {
        return riskFrequency;
    }

    public String getQualifier() {
        return qualifier;
    }

    public String getOrPerCopyUnitDescr() {
        return orPerCopyUnitDescr;
    }

    public String getOrPerCopyRange() {
        return orPerCopyRange;
    }

    public String getContext() {
        return context;
    }

    public int getpValueMantissa() {
        return pValueMantissa;
    }

    public int getpValueExponent() { return pValueExponent; }

    public Collection<String> getReportedGenes() {
        return reportedGenes;
    }

    public Collection<String> getReportedGeneLinks() {
        return reportedGeneLinks;
    }

    public String getRsId() {
        return rsId;
    }

    public Long getMerged() { return merged; }

    public Set<String> getChromosomeNames() {
        return chromosomeNames;
    }

    public Set<Integer> getChromosomePositions() {
        return chromosomePositions;
    }

    public float getOrPerCopyNum() {
        return orPerCopyNum;
    }

    public String getOrType() {
        return orType;
    }

    public void addPubmedId(String pubmedId) {
        this.pubmedId = pubmedId;
    }

    public void addTitle(String title) {
        this.title = title;
    }

    public void addAuthor(String author) {
        this.author = author;
    }

    public void addPublication(String publication) {
        this.publication = publication;
    }

    public void addPublicationDate(String publicationDate) {
        this.publicationDate = publicationDate;
    }

    public void addCatalogPublishDate(String catalogPublishDate) {
        this.catalogPublishDate = catalogPublishDate;
    }

    public void addPublicationLink(String publicationLink) {
        this.publicationLink = publicationLink;
    }

    public void addPlatform(String platform) {
        this.platform = platform;
    }

    public void addInitialSampleDescription(String initialSampleDescription) {
        this.initialSampleDescription = initialSampleDescription;
    }

    public void addReplicateSampleDescription(String replicateSampleDescription) {
        this.replicateSampleDescription = replicateSampleDescription;
    }

    public void addTraitName(String traitName) {
        this.traitNames.add(traitName);
    }

    public void addMappedLabel(String mappedLabel) {
        this.mappedLabels.add(mappedLabel);
    }

    public void addMappedUri(String mappedUri) {
        this.mappedUris.add(mappedUri);
    }

    public void addStudyId(String studyId) {
        this.studyIds.add(studyId);
    }

    private void embedGeneticData(Association association) {
        if (association.getLoci().size() > 1) {
            // if this association has multiple loci, this is a SNP x SNP study
            association.getLoci().forEach(
                    locus -> {
                        locus.getStrongestRiskAlleles().forEach(
                                riskAllele -> {
                                    strongestAllele =
                                            setOrAppend(strongestAllele, riskAllele.getRiskAlleleName(), " x ");

                                    SingleNucleotidePolymorphism snp = riskAllele.getSnp();
                                    rsId = setOrAppend(rsId, snp.getRsId(), " x ");

                                    merged = snp.getMerged();

                                    final Set<String> regionNames = new HashSet<>();
                                    final StringBuilder regionBuilder = new StringBuilder();

                                    snp.getLocations().forEach(
                                            location -> {
                                                if (!regionNames.contains(location.getRegion().getName())) {
                                                    regionNames.add(location.getRegion().getName());
                                                    setOrAppend(regionBuilder, location.getRegion().getName(), " / ");
                                                }
                                            });


                                    region = setOrAppend(region, regionBuilder.toString(), " : ");


                                    entrezMappedGene = setOrAppend(entrezMappedGene,
                                                                   getMappedGeneString(association, snp, "NCBI"),
                                                                   " : ");

                                    // and add entrez links for each entrez mapped gene
                                    entrezMappedGeneLinks = createMappedGeneLinks(snp, "NCBI");


                                    ensemblMappedGene = setOrAppend(ensemblMappedGene,
                                                                    getMappedGeneString(association, snp, "Ensembl"),
                                                                    " : ");

                                    // add ensembl links for each ensembl mapped gene
                                    ensemblMappedGeneLinks = createMappedGeneLinks(snp, "Ensembl");

                                    context = snp.getFunctionalClass();
                                    Collection<Location> snpLocations = snp.getLocations();
                                    for (Location snpLocation : snpLocations) {
                                        chromosomeNames.add(snpLocation.getChromosomeName());

                                        if (snpLocation.getChromosomePosition() != null) {
                                            chromosomePositions.add(Integer.parseInt(snpLocation.getChromosomePosition()));
                                        }
                                    }

                                }
                        );
                        locus.getAuthorReportedGenes().forEach(gene -> {
                            reportedGenes.add(gene.getGeneName().trim());
                            String reportedGeneLink = createReportedGeneLink(gene);
                            if (reportedGeneLink != null) {
                                reportedGeneLinks.add(reportedGeneLink);
                            }
                        });

                        locusDescription = locus.getDescription();
                    }
            );
        }
        else {
            // this is a single study or a haplotype
            association.getLoci().forEach(
                    locus -> {
                        locus.getStrongestRiskAlleles().forEach(
                                riskAllele -> {
                                    strongestAllele =
                                            setOrAppend(strongestAllele, riskAllele.getRiskAlleleName(), ", ");

                                    SingleNucleotidePolymorphism snp = riskAllele.getSnp();
                                    rsId = setOrAppend(rsId, snp.getRsId(), ", ");

                                    final Set<String> regionNames = new HashSet<>();
                                    final StringBuilder regionBuilder = new StringBuilder();

                                    snp.getLocations().forEach(
                                            location -> {
                                                if (!regionNames.contains(location.getRegion().getName())) {
                                                    regionNames.add(location.getRegion().getName());
                                                    setOrAppend(regionBuilder, location.getRegion().getName(), " / ");
                                                }
                                            });

                                    region = setOrAppend(region, regionBuilder.toString(), ", ");

                                    entrezMappedGene = setOrAppend(entrezMappedGene,
                                                                   getMappedGeneString(association, snp, "NCBI"),
                                                                   ", ");
                                    // and add entrez links for each entrez mapped gene
                                    entrezMappedGeneLinks = createMappedGeneLinks(snp, "NCBI");


                                    ensemblMappedGene = setOrAppend(ensemblMappedGene,
                                                                    getMappedGeneString(association, snp, "Ensembl"),
                                                                    ", ");

                                    // add ensembl links for each ensembl mapped gene
                                    ensemblMappedGeneLinks = createMappedGeneLinks(snp, "Ensembl");

                                    context = snp.getFunctionalClass();
                                    Collection<Location> snpLocations = snp.getLocations();
                                    for (Location snpLocation : snpLocations) {
                                        chromosomeNames.add(snpLocation.getChromosomeName());
                                        if (snpLocation.getChromosomePosition() != null) {
                                            chromosomePositions.add(Integer.parseInt(snpLocation.getChromosomePosition()));
                                        }
                                    }
                                }
                        );
                        locus.getAuthorReportedGenes().forEach(gene -> {
                            reportedGenes.add(gene.getGeneName().trim());
                            String reportedGeneLink = createReportedGeneLink(gene);
                            if (reportedGeneLink != null) {
                                reportedGeneLinks.add(reportedGeneLink);
                            }
                        });
                        locusDescription = locus.getDescription();
                    }
            );
        }
    }

    /**
     * @param gene
     * @return reported gene link or null if one could not be created
     */
    private String createReportedGeneLink(Gene gene) {

        // Create link information for reported gene
        String geneLink = gene.getGeneName();
        List<String> entrezIds = new ArrayList<String>();
        String entrezLinks = "";
        List<String> ensemblIds = new ArrayList<String>();
        String ensemblLinks = "";

        if (gene.getEntrezGeneIds() != null) {
            for (EntrezGene entrezGene : gene.getEntrezGeneIds()) {
                entrezIds.add(entrezGene.getEntrezGeneId());
            }
            entrezLinks = String.join("|", entrezIds);
        }
        if (gene.getEnsemblGeneIds() != null) {
            for (EnsemblGene ensemblGene : gene.getEnsemblGeneIds()) {
                ensemblIds.add(ensemblGene.getEnsemblGeneId());
            }
            ensemblLinks = String.join("|", ensemblIds);
        }

        // Construct link with Ensembl and Entrez IDs for reported gene
        if (!entrezLinks.isEmpty()) {

            if (!ensemblLinks.isEmpty()) {
                geneLink = geneLink.concat("|").concat(entrezLinks).concat("|").concat(ensemblLinks);
            }
            else {
                geneLink = geneLink.concat("|").concat(entrezLinks);
            }

            return geneLink;
        }
        else if (!ensemblLinks.isEmpty()) {
            geneLink = geneLink.concat("|").concat(ensemblLinks);
            return geneLink;
        }
        else {
            return null;
        }

    }

    private Collection<String> createMappedGeneLinks(SingleNucleotidePolymorphism snp, String source) {

        Collection<String> mappedGeneLinks = new LinkedHashSet<>();
        snp.getGenomicContexts().forEach(context -> {

            if (source.equalsIgnoreCase(context.getSource())) {

                Gene gene = context.getGene();

                String distance = "";
                if (context.getDistance() != null) {
                    distance = String.valueOf(context.getDistance());
                }

                String location = "";
                if (context.getLocation() != null) {
                    if (context.getLocation().getChromosomeName() != null) {
                        location = context.getLocation().getChromosomeName();
                    }
                }
                else {
                    getLog().warn("SNP: " + snp.getRsId() + " has no location for genomic context: " + context.getId());
                }


                if (source.equalsIgnoreCase("NCBI")) {

                    if (gene.getEntrezGeneIds() != null) {
                        for (EntrezGene entrezGene : gene.getEntrezGeneIds()) {
                            String geneLink =
                                    gene.getGeneName()
                                            .concat("|")
                                            .concat(entrezGene.getEntrezGeneId());
                            if (!distance.equals("")) {
                                geneLink = geneLink.concat("|").concat(distance);
                            }
                            if (!location.equals("")) {
                                geneLink = geneLink.concat("|".concat(location));
                            }
                            mappedGeneLinks.add(geneLink);
                        }
                    }
                }

                if (source.equalsIgnoreCase("Ensembl")) {

                    if (gene.getEnsemblGeneIds() != null) {
                        for (EnsemblGene ensemblGene : gene.getEnsemblGeneIds()) {
                            String geneLink =
                                    gene.getGeneName()
                                            .concat("|")
                                            .concat(ensemblGene.getEnsemblGeneId());
                            if (!distance.equals("")) {
                                geneLink = geneLink.concat("|").concat(distance);
                            }
                            if (!location.equals("")) {
                                geneLink = geneLink.concat("|".concat(location));
                            }
                            mappedGeneLinks.add(geneLink);
                        }
                    }
                }
            }
        });

        return mappedGeneLinks;
    }

    private String getMappedGeneString(Association association, SingleNucleotidePolymorphism snp, String source) {

        // Use set here so we don't get duplicates
        Set<String> mappedGenes = new HashSet<>();
        List<String> closestUpstreamDownstreamGenes = new ArrayList<>();

        snp.getGenomicContexts().forEach(
                context -> {
                    if (context.getGene() != null && context.getGene().getGeneName() != null &&
                            context.getSource() != null) {

                        if (source.equalsIgnoreCase(context.getSource())) {
                            String geneName = context.getGene().getGeneName().trim();

                            // Get any overlapping genes
                            if (context.getDistance() == 0) {
                                mappedGenes.add(geneName);
                            }

                            // else get the closest upstream and downstream
                            // logic here is to create an array with 2 elements, upstream
                            // at first index and downstream at second
                            else {
                                if (context.getIsClosestGene() != null && context.getIsClosestGene()) {
                                    if (context.getIsUpstream()) {
                                        {
                                            closestUpstreamDownstreamGenes.add(0, geneName);
                                        }
                                    }
                                    else if (context.getIsDownstream()) {
                                        if (!closestUpstreamDownstreamGenes.contains(geneName)) {
                                            closestUpstreamDownstreamGenes.add(geneName);
                                        }
                                    }
                                    else {
                                        getLog().warn("No closest upstream and downstream gene for association: " +
                                                              association.getId() + ", snp: " + snp.getRsId() +
                                                              ", for source " + source);
                                    }
                                }
                            }
                        }
                    }
                });


        String geneString = "";
        if (!mappedGenes.isEmpty()) {

            if (mappedGenes.size() == 1) {
                geneString = mappedGenes.iterator().next().toString();
            }

            else if (mappedGenes.size() > 1) {
                geneString = String.join("|", mappedGenes);
            }

            else {
                geneString = "N/A";
            }
        }

        else {

            if (!closestUpstreamDownstreamGenes.isEmpty()) {
                if (closestUpstreamDownstreamGenes.size() == 2) {
                    geneString =
                            closestUpstreamDownstreamGenes.get(0)
                                    .concat(" - ")
                                    .concat(closestUpstreamDownstreamGenes.get(
                                            1));
                }

                else if (closestUpstreamDownstreamGenes.size() == 1) {
                    geneString = closestUpstreamDownstreamGenes.get(0);
                    getLog().warn("Indexing bad genetic data for association " +
                                          "'" + association.getId() +
                                          "': wrong number of closest upstream and downstream gene, expected 2, got 1");
                }

                else {
                    getLog().warn("Indexing bad genetic data for association " +
                                          "'" + association.getId() +
                                          "': wrong number of closest upstream and downstream gene, expected 2, got" +
                                          closestUpstreamDownstreamGenes.size());
                }

            }

            else {
                geneString = "N/A";
            }
        }

        return geneString;
    }

    private String setOrAppend(String current, String toAppend, String delim) {
        if (toAppend != null && !toAppend.isEmpty()) {
            if (current == null || current.isEmpty()) {
                current = toAppend;
            }
            else {
                current = current.concat(delim).concat(toAppend);
            }
        }
        return current;
    }

    private StringBuilder setOrAppend(StringBuilder current, String toAppend, String delim) {
        if (toAppend != null && !toAppend.isEmpty()) {
            if (current.length() == 0) {
                current.append(toAppend);
            }
            else {
                current.append(delim).append(toAppend);
            }
        }
        return current;
    }

    public String getLocusDescription() {
        return locusDescription;
    }

    public void setLocusDescription(String locusDescription) {
        this.locusDescription = locusDescription;
    }
}
