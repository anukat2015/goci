package uk.ac.ebi.spot.goci.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.component.EnsemblMappingPipeline;
import uk.ac.ebi.spot.goci.exception.EnsemblMappingException;
import uk.ac.ebi.spot.goci.model.Association;
import uk.ac.ebi.spot.goci.model.Gene;
import uk.ac.ebi.spot.goci.model.Locus;
import uk.ac.ebi.spot.goci.model.SingleNucleotidePolymorphism;

import java.util.ArrayList;
import java.util.Collection;

/**
 * Created by emma on 11/03/2016.
 *
 * @author emma
 */
@Service
public class CheckAuthorReportedGenesService {

    private EnsemblMappingPipeline ensemblMappingPipeline;
    private AssociationReportService associationReportService;
    private MappingRecordService mappingRecordService;
    private SingleNucleotidePolymorphismQueryService singleNucleotidePolymorphismQueryService;

    private final Logger log = LoggerFactory.getLogger(getClass());

    protected Logger getLog() {
        return log;
    }

    public ArrayList<String> checkAuthorReportedGenes(Association association)
            throws EnsemblMappingException {

        return runCheck(association);
    }

    private ArrayList<String> runCheck(Association association) throws EnsemblMappingException {

        ArrayList<String> associationMappingErrors = new ArrayList<>();

        for (Locus associationLocus : association.getLoci()) {
            Long locusId = associationLocus.getId();

            // Get SNPs
            Collection<SingleNucleotidePolymorphism> snpsLinkedToLocus =
                    singleNucleotidePolymorphismQueryService.findByRiskAllelesLociId(locusId);

            // Get author reported genes
            Collection<Gene> authorReportedGenesLinkedToSnp = associationLocus.getAuthorReportedGenes();

            // Get gene names
            Collection<String> authorReportedGeneNamesLinkedToSnp = new ArrayList<>();
            for (Gene authorReportedGeneLinkedToSnp : authorReportedGenesLinkedToSnp) {
                authorReportedGeneNamesLinkedToSnp.add(authorReportedGeneLinkedToSnp.getGeneName().trim());
            }

            // Pass rs_id and author reported genes to mapping component
            for (SingleNucleotidePolymorphism snpLinkedToLocus : snpsLinkedToLocus) {
                ArrayList<String> snpErrors = new ArrayList<>();

                // Try to map supplied data
                try {
                    snpErrors = ensemblMappingPipeline.runAuthorReportedGenesCheck(authorReportedGeneNamesLinkedToSnp,
                                                                                   snpLinkedToLocus.getLocations());
                }
                catch (Exception e) {
                    getLog().error("Encountered a " + e.getClass().getSimpleName() +
                                           " whilst trying to check author reported genes for SNP " + snpLinkedToLocus.getRsId(), e);
                    throw new EnsemblMappingException();
                }
                associationMappingErrors.addAll(snpErrors);
            }
        }
        return associationMappingErrors;
    }
}
