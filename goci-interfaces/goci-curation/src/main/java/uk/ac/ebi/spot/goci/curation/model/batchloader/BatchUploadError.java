package uk.ac.ebi.spot.goci.curation.model.batchloader;

/**
 * Created by emma on 21/03/2016.
 *
 * @author emma
 *         <p>
 *         Model class used to represent errors generated after a failed upload of file containing SNP association values
 */
public class BatchUploadError {

    private Integer row;

    private String columnName;

    private String error;

    public Integer getRow() {
        return row;
    }

    public void setRow(Integer row) {
        this.row = row;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}
