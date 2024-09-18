package fr.scpit.backend.cart;

import fr.scpit.backend.order_item.OrderItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "carts")
public class Cart {
    @Id
    private String id;
    private String userId; // Assuming this is a user ID
    @DBRef
    private List<OrderItem> items;
    private String status;
    private double totalPrice;
    private String createdAt;
    private String updatedAt;

}
