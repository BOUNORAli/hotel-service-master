package fr.scpit.backend.order_item;

import com.fasterxml.jackson.annotation.JsonInclude;
import fr.scpit.backend.food.Food;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OrderItemResponse {
    private String id;
    private Food food;
    private double price;
    private int quantity;
}
