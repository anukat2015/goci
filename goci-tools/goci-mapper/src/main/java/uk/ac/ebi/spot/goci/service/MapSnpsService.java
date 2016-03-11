package uk.ac.ebi.spot.goci.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.component.EnsemblMappingPipeline;
import uk.ac.ebi.spot.goci.exception.EnsemblMappingException;
import uk.ac.ebi.spot.goci.model.EnsemblMappingResult;
import uk.ac.ebi.spot.goci.model.GenomicContext;
import uk.ac.ebi.spot.goci.model.Location;
import uk.ac.ebi.spot.goci.model.SingleNucleotidePolymorphism;
import uk.ac.ebi.spot.goci.repository.SingleNucleotidePolymorphismRepository;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Created by emma on 11/03/2016.
 *
 * @author emma
 *         <p>
 *         Ssrvice that maps a selection of SNPs
 */
@Service
public class MapSnpsService {

    private EnsemblMappingPipeline ensemblMappingPipeline;
    private SnpLocationMappingService snpLocationMappingService;
    private SnpGenomicContextMappingService snpGenomicContextMappingService;
    private SingleNucleotidePolymorphismRepository singleNucleotidePolymorphismRepository;

    private final Logger log = LoggerFactory.getLogger(getClass());

    protected Logger getLog() {
        return log;
    }

    @Autowired
    public MapSnpsService(EnsemblMappingPipeline ensemblMappingPipeline,
                          SnpLocationMappingService snpLocationMappingService,
                          SnpGenomicContextMappingService snpGenomicContextMappingService,
                          SingleNucleotidePolymorphismRepository singleNucleotidePolymorphismRepository) {
        this.ensemblMappingPipeline = ensemblMappingPipeline;
        this.snpLocationMappingService = snpLocationMappingService;
        this.snpGenomicContextMappingService = snpGenomicContextMappingService;
        this.singleNucleotidePolymorphismRepository = singleNucleotidePolymorphismRepository;
    }

    public Map<Long, Collection<String>> mapSnps(Collection<SingleNucleotidePolymorphism> snps)
            throws EnsemblMappingException {

        // Store any mapping errors
        Map<Long, Collection<String>> snpIdToMappingErrors = new HashMap<>();

        for (SingleNucleotidePolymorphism snp : snps) {

            // Map to store returned location data, this is used in
            // snpLocationMappingService to process all locations linked
            // to a single snp in one go
            Map<String, Set<Location>> snpToLocationsMap = new HashMap<>();

            String snpRsId = snp.getRsId();
            EnsemblMappingResult ensemblMappingResult = new EnsemblMappingResult();

            // Try to map supplied data
            try {
                getLog().debug("Running mapping....");
                ensemblMappingResult =
                        ensemblMappingPipeline.runMapping(snpRsId);
            }
            catch (Exception e) {
                getLog().error("Encountered a " + e.getClass().getSimpleName() +
                                       " whilst trying to run mapping of SNP " + snpRsId, e);
                throw new EnsemblMappingException();
            }
            getLog().debug("Mapping complete");

            Collection<Location> locations = ensemblMappingResult.getLocations();
            Collection<GenomicContext> snpGenomicContexts = ensemblMappingResult.getGenomicContexts();
            ArrayList<String> pipelineErrors = ensemblMappingResult.getPipelineErrors();

            // First remove old locations and genomic contexts
            snpLocationMappingService.removeExistingSnpLocations(snp);
            snpGenomicContextMappingService.removeExistingGenomicContexts(snp);

            // Update functional class
            snp.setFunctionalClass(ensemblMappingResult.getFunctionalClass());
            snp.setLastUpdateDate(new Date());
            singleNucleotidePolymorphismRepository.save(snp);

            // TODO DOING SNP PER SNP SO DONT NEED TO FLATTEN
            // Store location information for SNP
            if (!locations.isEmpty()) {
                for (Location location : locations) {

                    // Next time we see SNP, add location to set
                    // This would only occur is SNP has multiple locations
                    if (snpToLocationsMap.containsKey(snpRsId)) {
                        snpToLocationsMap.get(snpRsId).add(location);
                    }

                    // First time we see a SNP store the location
                    else {
                        Set<Location> snpLocation = new HashSet<>();
                        snpLocation.add(location);
                        snpToLocationsMap.put(snpRsId, snpLocation);
                    }
                }
            }
            else {
                getLog().warn("Attempt to map SNP: " + snpRsId + " returned no location details");
                pipelineErrors.add("Attempt to map SNP: " + snpRsId + " returned no location details");
            }

            // Save data
            if (!snpToLocationsMap.isEmpty()) {
                getLog().debug("Updating location details ...");
                snpLocationMappingService.storeSnpLocation(snpToLocationsMap);
                getLog().debug("Updating location details complete");
            }
            if (!snpGenomicContexts.isEmpty()) {
                getLog().debug("Updating genomic context details ...");
                //  TODO REFACTOR THIS METHOD AS THERE IS ONLY ONE SNP NOW
                snpGenomicContextMappingService.processGenomicContext(snpGenomicContexts);
                getLog().debug("Updating genomic context details complete");
            }
            else {
                getLog().warn("Attempt to map SNP: " + snpRsId + " returned no mapped genes");
                pipelineErrors.add("Attempt to map SNP: " + snpRsId + " returned no mapped genes");
            }

            // TODO COLLATE ALL ERRORS, WHAT IF WE SAW SAME SNP TWICE IN DB
            // Add errors to map
            snpIdToMappingErrors.put(snp.getId(), pipelineErrors);
        }
        return snpIdToMappingErrors;
    }
}
