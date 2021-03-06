package uk.ac.ebi.spot.goci.curation.service;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import uk.ac.ebi.spot.goci.curation.builder.AssociationBuilder;
import uk.ac.ebi.spot.goci.curation.validator.SnpFormColumnValidator;
import uk.ac.ebi.spot.goci.curation.validator.SnpFormRowValidator;
import uk.ac.ebi.spot.goci.model.Association;
import uk.ac.ebi.spot.goci.repository.AssociationReportRepository;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

/**
 * Created by emma on 03/03/2016.
 *
 * @author emma
 *         <p>
 *         Test class for AssociationOperationsService.java
 */
@RunWith(MockitoJUnitRunner.class)
public class AssociationOperationsServiceTest {

    private static final Association ASS_BETA =
            new AssociationBuilder().setId(600L).setBetaNum((float) 0.012).build();

    private static final Association ASS_OR =
            new AssociationBuilder().setId(601L).setOrPerCopyNum((float) 5.97).build();

    private static final Association ASS_NO_EFFECT_SIZE =
            new AssociationBuilder().setId(602L).build();

    private AssociationOperationsService associationOperationsService;

    @Mock
    private SingleSnpMultiSnpAssociationService singleSnpMultiSnpAssociationService;

    @Mock
    private SnpInteractionAssociationService snpInteractionAssociationService;

    @Mock
    private AssociationReportRepository associationReportRepository;

    @Mock
    private SnpFormRowValidator snpFormRowValidator;

    @Mock
    private SnpFormColumnValidator snpFormColumnValidator;

    @Before
    public void setUpMock() {
        associationOperationsService = new AssociationOperationsService(singleSnpMultiSnpAssociationService,
                                                                        snpInteractionAssociationService,
                                                                        associationReportRepository,
                                                                        snpFormRowValidator,
                                                                        snpFormColumnValidator);
    }

    @Test
    public void testMocks() {
        // Test mock creation
        assertNotNull(singleSnpMultiSnpAssociationService);
        assertNotNull(snpInteractionAssociationService);
        assertNotNull(associationReportRepository);
        assertNotNull(snpFormRowValidator);
        assertNotNull(snpFormColumnValidator);
    }

    @Test
    public void testDetermineIfAssociationIsOrType() {
        assertEquals("beta", associationOperationsService.determineIfAssociationIsOrType(ASS_BETA));
        assertEquals("or", associationOperationsService.determineIfAssociationIsOrType(ASS_OR));
        assertEquals("none", associationOperationsService.determineIfAssociationIsOrType(ASS_NO_EFFECT_SIZE));
    }
}
