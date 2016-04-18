package uk.ac.ebi.spot.goci.service;

import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.model.Association;
import uk.ac.ebi.spot.goci.model.AssociationValidationError;

import java.util.ArrayList;
import java.util.Collection;

/**
 * Created by emma on 01/04/2016.
 *
 * @author emma
 *         <p>
 *         Full checking service will run all checks
 */
@Service
public class FullAssociationCheckingService implements AssociationCheckingService {

    @Override
    public Collection<AssociationValidationError> runChecks(Association association,
                                                            ValidationChecksBuilder validationChecksBuilder) {

        // TODO ADD COMPLETE LIST OF CHECKS

        // Create collection to store all newly created associations
        Collection<AssociationValidationError> associationValidationErrors = new ArrayList<>();

        Collection<AssociationValidationError> pvalueErrors = validationChecksBuilder.runPvalueChecks(association);

        Collection<AssociationValidationError> annotationErrors =
                validationChecksBuilder.runAnnotationChecks(association);
        if (!annotationErrors.isEmpty()) {
            associationValidationErrors.addAll(annotationErrors);
        }

        String effectType = determineIfAssociationIsOrType(association);

        // Run checks depending on effect type
        if (effectType.equalsIgnoreCase("or")) {
            Collection<AssociationValidationError> orErrors =
                    validationChecksBuilder.runOrChecks(association, effectType);
            if (!orErrors.isEmpty()) {
                associationValidationErrors.addAll(orErrors);
            }
        }

        if (effectType.equalsIgnoreCase("beta")) {
            Collection<AssociationValidationError> betaErrors =
                    validationChecksBuilder.runBetaChecks(association, effectType);
            if (!betaErrors.isEmpty()) {
                associationValidationErrors.addAll(betaErrors);
            }
        }

        if (effectType.equalsIgnoreCase("nr")) {
            Collection<AssociationValidationError> noEffectErrors =
                    validationChecksBuilder.runNoEffectErrors(association, effectType);
            if (!noEffectErrors.isEmpty()) {
                associationValidationErrors.addAll(noEffectErrors);
            }
        }
        return associationValidationErrors;
    }
}