package uk.ac.ebi.spot.goci.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.exception.EnsemblMappingException;
import uk.ac.ebi.spot.goci.model.Association;
import uk.ac.ebi.spot.goci.model.AssociationReport;
import uk.ac.ebi.spot.goci.model.SingleNucleotidePolymorphism;
import uk.ac.ebi.spot.goci.repository.AssociationReportRepository;
import uk.ac.ebi.spot.goci.repository.SingleNucleotidePolymorphismRepository;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Map;

/**
 * Created by emma on 11/03/2016.
 *
 * @author emma
 */

@Service
public class AssociationUpdateService {

    private AssociationReportRepository associationReportRepository;
    private AssociationQueryService associationService;
    private MappingErrorComparisonService mappingErrorComparisonService;
    private SingleNucleotidePolymorphismRepository singleNucleotidePolymorphismRepository;
    private CheckAuthorReportedGenesService checkAuthorReportedGenesService;
    private AssociationReportService associationReportService;
    private MappingRecordService mappingRecordService;

    private final Logger log = LoggerFactory.getLogger(getClass());

    protected Logger getLog() {
        return log;
    }

    @Autowired
    public AssociationUpdateService(AssociationReportRepository associationReportRepository,
                                    AssociationQueryService associationService,
                                    MappingErrorComparisonService mappingErrorComparisonService,
                                    SingleNucleotidePolymorphismRepository singleNucleotidePolymorphismRepository,
                                    CheckAuthorReportedGenesService checkAuthorReportedGenesService,
                                    AssociationReportService associationReportService,
                                    MappingRecordService mappingRecordService) {
        this.associationReportRepository = associationReportRepository;
        this.associationService = associationService;
        this.mappingErrorComparisonService = mappingErrorComparisonService;
        this.singleNucleotidePolymorphismRepository = singleNucleotidePolymorphismRepository;
        this.checkAuthorReportedGenesService = checkAuthorReportedGenesService;
        this.associationReportService = associationReportService;
        this.mappingRecordService = mappingRecordService;
    }

    public void postFullMappingOperations(Map<Long, Collection<String>> snpToMappingErrors, String performer)
            throws EnsemblMappingException {

        // Get all old association reports so we can compare with new ones
        Collection<AssociationReport> oldAssociationReports = associationReportRepository.findAll();

        ArrayList<String> associationMappingErrors = new ArrayList<>();

        // Get all associations via service
        Collection<Association> associations = associationService.findAllAssociations();

        for (Association association : associations) {
            try {
                associationMappingErrors = checkAuthorReportedGenesService.checkAuthorReportedGenes(association);
            }
            catch (EnsemblMappingException e) {
                throw new EnsemblMappingException("Attempt check author reported genes for all associations failed", e);
            }

            // Find SNPs used in this association and check if they returned errors
            Collection<SingleNucleotidePolymorphism> snpsLinkedToAssociation =
                    singleNucleotidePolymorphismRepository.findByRiskAllelesLociAssociationId(association.getId());

            for (SingleNucleotidePolymorphism snp : snpsLinkedToAssociation) {
                associationMappingErrors.addAll(snpToMappingErrors.get(snp.getId()));
            }

            // Create association report based on whether there is errors or not
            if (!associationMappingErrors.isEmpty()) {
                associationReportService.processAssociationErrors(association, associationMappingErrors);
            }
            else {
                associationReportService.updateAssociationReportDetails(association);
            }

            mappingRecordService.updateAssociationMappingRecord(association, new Date(), performer);
        }
        mappingErrorComparisonService.compareOldVersusNewErrors(oldAssociationReports);
    }
}
