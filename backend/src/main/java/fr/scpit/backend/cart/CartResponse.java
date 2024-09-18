package fr.scpit.backend.cart;

import com.fasterxml.jackson.annotation.JsonInclude;
import fr.scpit.backend.order_item.OrderItem;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CartResponse {
    private String id;
    private String userId;
    private List<OrderItem> items;
    private String status;
    private double totalPrice;
    private String createdAt;
    private String updatedAt;
}
