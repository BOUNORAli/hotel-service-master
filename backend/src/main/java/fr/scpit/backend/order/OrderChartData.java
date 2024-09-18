package fr.scpit.backend.order;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OrderChartData {
    private String date;
    private int orderCount;
}
