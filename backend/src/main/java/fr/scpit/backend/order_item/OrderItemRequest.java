package fr.scpit.backend.order_item;

import fr.scpit.backend.food.Food;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderItemRequest {
    private String id;
    private Food food;
    private double price;
    private int quantity;



    public Food getFood() {
        if (food == null) {
            food = new Food();
        }
        return food;
    }
}
