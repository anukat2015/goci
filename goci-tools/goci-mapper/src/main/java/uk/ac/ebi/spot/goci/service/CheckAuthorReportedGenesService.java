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

    public void checkAuthorReportedGenes(Collection<Association> associations) throws EnsemblMappingException {
        for (Association association : associations) { runCheck(association); }
    }

    private void runCheck(Association association) throws EnsemblMappingException {

        for (Locus associationLocus : association.getLoci()) {
            Long locusId = associationLocus.getId();

            Collection<SingleNucleotidePolymorphism> snpsLinkedToLocus =
                    singleNucleotidePolymorphismQueryService.findByRiskAllelesLociId(locusId);

            Collection<Gene> authorReportedGenesLinkedToSnp = associationLocus.getAuthorReportedGenes();

            // Get gene names
            Collection<String> authorReportedGeneNamesLinkedToSnp = new ArrayList<>();
            for (Gene authorReportedGeneLinkedToSnp : authorReportedGenesLinkedToSnp) {
                authorReportedGeneNamesLinkedToSnp.add(authorReportedGeneLinkedToSnp.getGeneName().trim());
            }

            // Pass rs_id and author reported genes to mapping component
            for (SingleNucleotidePolymorphism snpLinkedToLocus : snpsLinkedToLocus) {

                String snpRsId = snpLinkedToLocus.getRsId();


                // Try to map supplied data
                try {
                    getLog().debug("Running mapping....");

                    ensemblMappingPipeline.runAuthorReportedGenesCheck(authorReportedGeneNamesLinkedToSnp,
                                                                       snpLinkedToLocus.getLocations());
                }
                catch (Exception e) {
                    getLog().error("Encountered a " + e.getClass().getSimpleName() +
                                           " whilst trying to run mapping of SNP " + snpRsId, e);
                    throw new EnsemblMappingException();
                }

                getLog().debug("Mapping complete");


            }

            // Collection to store all errors for one association
            Collection<String> associationPipelineErrors = ensemblMappingPipeline.runAuthorReportedGenesCheck();

        }
    }
}
