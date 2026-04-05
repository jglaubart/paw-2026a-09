package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.time.LocalDate;

public class SearchDateOption implements Serializable {

    private LocalDate date;
    private int productionCount;

    public SearchDateOption() {}

    public SearchDateOption(final LocalDate date, final int productionCount) {
        this.date = date;
        this.productionCount = productionCount;
    }

    public LocalDate getDate() {
        return date;
    }

    public int getProductionCount() {
        return productionCount;
    }
}
