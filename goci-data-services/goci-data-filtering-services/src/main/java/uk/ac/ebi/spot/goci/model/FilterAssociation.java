package uk.ac.ebi.spot.goci.model;

/**
 * Created by dwelter on 05/04/16.
 */
public class FilterAssociation {

    private Integer rowNumber;

    private String strongestAllele = null;

    private Double pvalueMantissa = null;

    private Integer pvalueExponent = null;

    private String chromosomeName;

    private Integer chromosomePosition;

    private Boolean isTopAssociation = false;

    public FilterAssociation(Integer rowNumber,
                             String strongestAllele,
                             Double pvalueMantissa,
                             Integer pvalueExponent,
                             String chromosomeName,
                             String chromosomePosition){
        this.rowNumber = rowNumber;
        this.strongestAllele = strongestAllele;
        this.pvalueMantissa = pvalueMantissa;
        this.pvalueExponent = pvalueExponent;
        this.chromosomeName = chromosomeName;
        this.chromosomePosition = Integer.parseInt(chromosomePosition);
    }

    public Integer getRowNumber() {
        return rowNumber;
    }

    public void setRowNumber(Integer rowNumber) {
        this.rowNumber = rowNumber;
    }

   public String getStrongestAllele() {
        return strongestAllele;
    }

    public void setStrongestAllele(String strongestAllele) {
        this.strongestAllele = strongestAllele;
    }

    public Double getPvalueMantissa() {
        return pvalueMantissa;
    }

    public void setPvalueMantissa(Double pvalueMantissa) {
        this.pvalueMantissa = pvalueMantissa;
    }

    public Integer getPvalueExponent() {
        return pvalueExponent;
    }

    public void setPvalueExponent(Integer pvalueExponent) {
        this.pvalueExponent = pvalueExponent;
    }


    public String getChromosomeName() {
        return chromosomeName;
    }

    public void setChromosomeName(String chromosomeName) {
        this.chromosomeName = chromosomeName;
    }

    public Integer getChromosomePosition() {
        return chromosomePosition;
    }

    public void setChromosomePosition(String chromosomePosition) {
        this.chromosomePosition = Integer.parseInt(chromosomePosition);
    }

    public void setChromosomePosition(Integer chromosomePosition) {
        this.chromosomePosition = chromosomePosition;
    }

    public Boolean getIsTopAssociation() {
        return isTopAssociation;
    }

    public void setIsTopAssociation(Boolean isTopAssociation) {
        this.isTopAssociation = isTopAssociation;
    }
}
