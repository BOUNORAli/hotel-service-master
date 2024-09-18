package fr.scpit.backend.order_item;

import fr.scpit.backend.exception.OrderServiceBusinessException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import fr.scpit.backend.order.OrderMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/order-items")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Order Item")
public class OrderItemController {

    private final OrderItemService service;

    private static final String SUCCESS = "SUCCESS";

    private static final String FAILED = "FAILED";
    public static final String ORDER_ITEM_SERVICE_ERROR_OCCURRED = "Order Item service error occurred: {}";

    @Operation(
            description = "Get endpoint for orderItem",
            summary = "This is a summary for orderItem get endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "201"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @CrossOrigin(origins = "http://localhost:50948")
    @PostMapping
    public ResponseEntity<APIResponse<OrderItemResponse>> createNewOrderItem(@RequestBody @Valid OrderItemRequest orderItemRequest) {
        try {
            log.info("OrderController::createNewOrder request body {}", OrderMapper.jsonAsString(orderItemRequest));
            OrderItemResponse orderItemResponse = service.createNewOrderItem(orderItemRequest);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(APIResponse.<OrderItemResponse>builder()
                            .status(SUCCESS)
                            .results(orderItemResponse)
                            .build());
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_ITEM_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<OrderItemResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for orderItem",
            summary = "This is a summary for orderItem get endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @GetMapping
    public ResponseEntity<APIResponse<List<OrderItemResponse>>> getOrderItems() {
        try {
            List<OrderItemResponse> orderItemResponseList = service.getAllOrderItems();
            return ResponseEntity.ok(APIResponse.<List<OrderItemResponse>>builder()
                    .status(SUCCESS)
                    .results(orderItemResponseList)
                    .build());
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_ITEM_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<OrderItemResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }


}
