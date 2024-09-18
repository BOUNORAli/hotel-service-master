package fr.scpit.backend.order;

import com.fasterxml.jackson.annotation.JsonInclude;
import fr.scpit.backend.order_item.OrderItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OrderResponse {

    private String id;
    private String name;
    private String address;
    private String paymentId;
    private double totalPrice;
    private List<OrderItem> items;
    private String status;
    private String user; // Assuming this is a user ID
    private String createdAt;
    private String updatedAt;
}
