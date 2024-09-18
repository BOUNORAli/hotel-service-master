package fr.scpit.backend.cart;

import fr.scpit.backend.order_item.OrderItem;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.NotNull;


import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartRequest {
    private String id;
    @NotBlank(message = "user id shouldn't be NULL OR EMPTY")
    private String userId;
    private List<OrderItem> items;
    private String status;
    private double totalPrice;
    private String createdAt;
    private String updatedAt;
    @NotNull(message = "Cart ID cannot be null")
    private String cartId;
}
