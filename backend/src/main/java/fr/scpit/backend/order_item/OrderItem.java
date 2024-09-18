package fr.scpit.backend.order_item;

import fr.scpit.backend.food.Food;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "order_items")
public class OrderItem {
    @Id
    private String id;
    @DBRef
    private Food food;
    private double price;
    private int quantity;

}
