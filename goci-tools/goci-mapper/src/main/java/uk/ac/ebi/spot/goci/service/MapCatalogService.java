package uk.ac.ebi.spot.goci.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.exception.EnsemblMappingException;
import uk.ac.ebi.spot.goci.model.SingleNucleotidePolymorphism;

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

    // Services
    private SingleNucleotidePolymorphismQueryService singleNucleotidePolymorphismQueryService;
    private MapSnpsService mapSnpsService;
    private AssociationUpdateService associationUpdateService;

    private final Logger log = LoggerFactory.getLogger(getClass());

    protected Logger getLog() {
        return log;
    }

    @Autowired
    public MapCatalogService(SingleNucleotidePolymorphismQueryService singleNucleotidePolymorphismQueryService,
                             AssociationUpdateService associationUpdateService,
                             MapSnpsService mapSnpsService) {
        this.singleNucleotidePolymorphismQueryService = singleNucleotidePolymorphismQueryService;
        this.associationUpdateService = associationUpdateService;
        this.mapSnpsService = mapSnpsService;
    }

    /**
     * Get all associations in database and map
     *
     * @param performer name of curator/job carrying out the mapping
     */
    public void mapCatalogContents(String performer) throws EnsemblMappingException {

        // Map to store any errors from mapping
        Map<Long, Collection<String>> snpToMappingErrors = new HashMap<>();

        // Get all SNPs and map
        Collection<SingleNucleotidePolymorphism> allSnps = singleNucleotidePolymorphismQueryService.findAll();
        getLog().info("Mapping all SNPs in database, total number: " + allSnps.size());

        try {
            snpToMappingErrors = mapSnpsService.mapSnps(allSnps);
        }
        catch (EnsemblMappingException e) {
            throw new EnsemblMappingException("Attempt to map all SNPs failed", e);
        }

        // Update all associations to reflect new mapping
        associationUpdateService.postFullMappingOperations(snpToMappingErrors);
    }
}