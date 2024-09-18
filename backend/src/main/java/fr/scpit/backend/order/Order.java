package fr.scpit.backend.order;

import fr.scpit.backend.order_item.OrderItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "orders")
public class Order {
    @Id
    private String id;
    private String name;
    private String address;
    private String paymentId;
    private double totalPrice;
    @DBRef
    private List<OrderItem> items;
    private String status;
    private String user;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}

