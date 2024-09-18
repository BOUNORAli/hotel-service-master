package fr.scpit.backend.order;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class OrderStatusUpdateRequest {
    @NotNull
    private String orderId;

    @NotNull
    private String status;
}
