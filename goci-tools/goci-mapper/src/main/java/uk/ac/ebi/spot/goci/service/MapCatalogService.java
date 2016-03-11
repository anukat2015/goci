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

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by emma on 05/02/2016.
 *
 * @author emma
 *         <p>
 *         Service used to map all associations in the catalog.
 */
@Service
public class MapCatalogService {

    private AssociationReportRepository associationReportRepository;

    // Services
    private AssociationQueryService associationService;
    private MappingErrorComparisonService mappingErrorComparisonService;
    private SingleNucleotidePolymorphismQueryService singleNucleotidePolymorphismQueryService;
    private MapSnpsService mapSnpsService;
    private CheckAuthorReportedGenesService checkAuthorReportedGenesService;

    private final Logger log = LoggerFactory.getLogger(getClass());

    protected Logger getLog() {
        return log;
    }

    @Autowired
    public MapCatalogService(AssociationReportRepository associationReportRepository,
                             AssociationQueryService associationService,
                             MappingErrorComparisonService mappingErrorComparisonService,
                             SingleNucleotidePolymorphismQueryService singleNucleotidePolymorphismQueryService,
                             MapSnpsService mapSnpsService,
                             CheckAuthorReportedGenesService checkAuthorReportedGenesService) {
        this.associationReportRepository = associationReportRepository;
        this.associationService = associationService;
        this.mappingErrorComparisonService = mappingErrorComparisonService;
        this.singleNucleotidePolymorphismQueryService = singleNucleotidePolymorphismQueryService;
        this.mapSnpsService = mapSnpsService;
        this.checkAuthorReportedGenesService = checkAuthorReportedGenesService;
    }

    /**
     * Get all associations in database and map
     *
     * @param performer name of curator/job carrying out the mapping
     */
    public void mapCatalogContents(String performer) throws EnsemblMappingException {

        // Map to store any errors from mapping
        Map<SingleNucleotidePolymorphism, Collection<String>> snpToMappingErrors = new HashMap<>();

        // Get all SNPs and map
        Collection<SingleNucleotidePolymorphism> allSnps = singleNucleotidePolymorphismQueryService.findAll();
        getLog().info("Mapping all SNPs in database, total number: " + allSnps.size());

        try {
            snpToMappingErrors = mapSnpsService.mapSnps(allSnps);
        }
        catch (EnsemblMappingException e) {
            throw new EnsemblMappingException("Attempt to map all SNPs failed", e);
        }

        // Get all old association reports so we can compare with new ones, do this before we remap
        // TODO CANDIDATE FOR ASYNC
        Collection<AssociationReport> oldAssociationReports = associationReportRepository.findAll();

        // Get all associations via service
        // TODO HOW DO WE HANDLE ERRORS
        Collection<Association> associations = associationService.findAllAssociations();
        try {
            checkAuthorReportedGenesService.checkAuthorReportedGenes(associations);
        }
        catch (EnsemblMappingException e) {
            throw new EnsemblMappingException("Attempt check author reported genes for all associations failed", e);
        }
        mappingErrorComparisonService.compareOldVersusNewErrors(oldAssociationReports);
    }
}
