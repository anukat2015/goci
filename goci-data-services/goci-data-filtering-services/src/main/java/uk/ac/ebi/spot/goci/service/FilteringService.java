package uk.ac.ebi.spot.goci.service;

import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.model.FilterAssociation;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by dwelter on 05/04/16.
 */
@Service
public class FilteringService {


    public Map<String, List<FilterAssociation>> groupByChromosomeName(List<FilterAssociation> associations){

        Map<String, List<FilterAssociation>> byChrom =
                associations.stream()
                            .collect(Collectors.groupingBy(FilterAssociation::getChromosomeName));

        return byChrom;
    }

    public Map<String, List<FilterAssociation>> sortByBPLocation(Map<String, List<FilterAssociation>> byChrom){
        Map<String, List<FilterAssociation>> byBPLocation = new HashMap<>();
        byChrom.forEach((k, v) -> {
            List<FilterAssociation> byChromBP = v.stream()
                    .sorted((v1, v2) -> Integer.compare(v1.getChromosomePosition(), v2.getChromosomePosition()))
                    .collect(Collectors.toList());

            byBPLocation.put(k, byChromBP);
        })  ;


        return byBPLocation;
    }

    public List<FilterAssociation> filterTopAssociations(Map<String, List<FilterAssociation>> byBPLocation){

        List<FilterAssociation> filtered = new ArrayList<>();
        byBPLocation.forEach((chromName, associations) -> {
            System.out.println("Processing chromosome " + chromName + " with " + associations.size() + " associations");

            if(associations.size() == 1 && associations.get(0).getPvalueExponent() < -5){
                associations.get(0).setIsTopAssociation(true);
                filtered.add(associations.get(0));
            }
            else {
                int i =0;

                while(i < associations.size()) {

                    FilterAssociation current = associations.get(i);

                    if(current.getPvalueExponent() < -5) {
                        List<FilterAssociation> ldBlock = new ArrayList<>();

                        if(current.getLdBlock() != null){
                            boolean end = false;
                            ldBlock.add(current);

                            while (!end) {
                                if (i == associations.size() - 1) {
                                    end = true;
                                }
                                else {
                                    FilterAssociation b = associations.get(i + 1);

                                    if (current.getLdBlock().equals(b.getLdBlock())) {
                                        ldBlock.add(b);
                                        i++;
                                    }
                                    else {
                                        end = true;
                                    }
                                }
                            }

                        }

                        else {
                            Integer distToPrev = null;
                            if (i > 0) {
                                distToPrev = current.getChromosomePosition() -
                                        associations.get(i - 1).getChromosomePosition();
                            }

                            Integer distToNext = null;
                            if (i < associations.size() - 1) {
                                distToNext = associations.get(i + 1).getChromosomePosition() -
                                        current.getChromosomePosition();
                            }


                            if (distToPrev != null && distToNext != null && distToPrev > 100000 &&
                                    distToNext > 100000) {
                                current.setIsTopAssociation(true);
                            }
                            else if (distToPrev == null && distToNext != null && distToNext > 100000) {
                                current.setIsTopAssociation(true);
                            }
                            else if (distToPrev != null && distToNext == null && distToPrev > 100000) {
                                current.setIsTopAssociation(true);
                            }
                            else if (distToPrev != null && distToPrev < 100000 &&
                                    !(associations.get(i - 1).getPvalueExponent() < -5)
                                    && ((distToNext != null && distToNext > 100000) || distToNext == null)) {
                                current.setIsTopAssociation(true);
                            }
                            else if (distToNext != null && distToNext < 100000) {
                                int j = i;
                                boolean end = false;

                                ldBlock.add(current);

                                while (!end) {
                                    FilterAssociation a = associations.get(j);
                                    FilterAssociation b = associations.get(j + 1);


                                    Integer dist = b.getChromosomePosition() - a.getChromosomePosition();

                                    if (dist < 100000) {
                                        ldBlock.add(b);
                                        j++;
                                    }
                                    else {
                                        end = true;
                                    }

                                    if (j == associations.size() - 1) {
                                        end = true;
                                    }

                                }
                                i = j;
                            }
                        }

                        if(ldBlock.size() != 0) {
                            FilterAssociation mostSignificant;
                            List<FilterAssociation> secondary = new ArrayList<>();
                            if (ldBlock.size() > 1) {
                                List<FilterAssociation> byPval = ldBlock.stream()
                                        .sorted((fa1, fa2) -> Double.compare(fa1.getPvalue(),
                                                                             fa2.getPvalue()))
                                        .collect(Collectors.toList());


                                mostSignificant = byPval.get(0);

                                if (mostSignificant.getPrecisionConcern()) {
                                    for (int k = 1; k < byPval.size(); k++) {
                                        FilterAssociation fa = byPval.get(k);
                                        if (fa.getPvalueExponent() == mostSignificant.getPvalueExponent()) {
                                            if (fa.getPvalueMantissa() < mostSignificant.getPvalueMantissa()) {
                                                mostSignificant = fa;
                                            }
                                            else if (fa.getPvalueMantissa() ==
                                                    mostSignificant.getPvalueMantissa()) {
                                                secondary.add(fa);
                                            }
                                        }
                                        else {
                                            break;
                                        }
                                    }
                                }
                                else {
                                    boolean done = false;
                                    int p = 0;
                                    while(!done && p < byPval.size()-1) {
                                        if (byPval.get(p).getPvalue() == byPval.get(p+1).getPvalue()) {
                                            secondary.add(byPval.get(p+1));
                                            p++;
                                        }
                                        else{
                                            done = true;
                                        }
                                    }
                                }
                            }
                            else {
                                mostSignificant = ldBlock.get(0);
                            }
                            if (mostSignificant.getPvalueExponent() < -5) {
                                mostSignificant.setIsTopAssociation(true);
                            }
                            //account for the case where multiple p-values within the same LD block are identical
                            if (secondary.size() != 0){
                                for(FilterAssociation s : secondary){
                                    if(s.getPvalue() == mostSignificant.getPvalue()){
                                        s.setIsTopAssociation(true);
                                    }
                                }
                            }
                        }
                    }
                    i++;

                }

            }
            filtered.addAll(associations);

        });

        return filtered;

    }


}
