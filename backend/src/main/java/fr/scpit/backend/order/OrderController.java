package fr.scpit.backend.order;

import fr.scpit.backend.exception.OrderServiceBusinessException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


import java.util.*;
import java.util.stream.Collectors;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Order")
public class OrderController {

    private final OrderService orderService;

    private static final String SUCCESS = "SUCCESS";
    private static final String FAILED = "FAILED";
    public static final String ORDER_SERVICE_ERROR_OCCURRED = "Order service error occurred: {}";

    @PostMapping
    public ResponseEntity<APIResponse<OrderResponse>> createNewOrder(@RequestBody @Valid OrderRequest orderRequest) {
        try {
            log.info("OrderController::createNewOrder request body {}", OrderMapper.jsonAsString(orderRequest));
            OrderResponse orderResponse = orderService.createNewOrder(orderRequest);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(APIResponse.<OrderResponse>builder()
                            .status(SUCCESS)
                            .results(orderResponse)
                            .build());
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<OrderResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @PostMapping("/checkout")
    public ResponseEntity<APIResponse<OrderResponse>> checkout(@RequestBody Map<String, String> requestBody) {
        String cartId = requestBody.get("cartId");
        try {
            log.info("OrderController::checkout request body {}", OrderMapper.jsonAsString(requestBody));
            OrderResponse orderResponse = orderService.checkout(cartId);
            return ResponseEntity.ok(APIResponse.<OrderResponse>builder()
                    .status(SUCCESS)
                    .results(orderResponse)
                    .build());
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<OrderResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @GetMapping
    public ResponseEntity<APIResponse<List<OrderResponse>>> getOrders(@RequestParam(required = false) String status) {
        log.info("OrderController: getOrders with status {}", status);
        try {
            List<OrderResponse> orders = orderService.getOrdersByStatus(status);
            return ResponseEntity.ok(APIResponse.<List<OrderResponse>>builder()
                    .status(SUCCESS)
                    .results(orders)
                    .build());
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<OrderResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @PatchMapping("/{id}") //Reda
    public ResponseEntity<APIResponse<OrderResponse>> updateOrderStatus(@PathVariable String id, @RequestBody @Valid OrderStatusUpdateRequest request) {
        try {
            request.setOrderId(id);
            log.info("OrderController::updateOrderStatus request body {}", OrderMapper.jsonAsString(request));
            OrderResponse orderResponse = orderService.updateOrderStatus(request);
            return ResponseEntity.ok(APIResponse.<OrderResponse>builder()
                    .status(SUCCESS)
                    .results(orderResponse)
                    .build());
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<OrderResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<APIResponse<Void>> deleteOrder(@PathVariable String id) {
        try {
            orderService.deleteOrder(id);
            return ResponseEntity.noContent().build();
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<Void>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @PostMapping("/updateStatus")
    public ResponseEntity<APIResponse<Void>> updateOrderStatus(@RequestBody OrderStatusUpdateRequest request) {
        try {
            log.info("OrderController::updateOrderStatus request body {}", OrderMapper.jsonAsString(request));
            orderService.updateOrderStatus(request.getOrderId(), request.getStatus());
            return ResponseEntity.ok(APIResponse.<Void>builder()
                    .status(SUCCESS)
                    .build());
        } catch (OrderServiceBusinessException ex) {
            log.error(ORDER_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<Void>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @GetMapping("/over-time")
    public ResponseEntity<APIResponse<List<OrderChartData>>> getOrdersOverTime() {
        try {
            List<OrderChartData> orderData = orderService.getOrdersOverTime();
            return ResponseEntity.ok(APIResponse.<List<OrderChartData>>builder()
                    .status("SUCCESS")
                    .results(orderData)
                    .build());
        } catch (OrderServiceBusinessException ex) {
            log.error("Order service error occurred: {}", ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<OrderChartData>>builder()
                            .status("FAILED")
                            .errors(List.of(errorDTO))
                            .build());
        }
    }


    @GetMapping("/past")
    public ResponseEntity<APIResponse<List<OrderResponse>>> getPastOrders(@RequestParam(required = false) String status) {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            String username;

            if (principal instanceof UserDetails) {
                username = ((UserDetails) principal).getUsername();
            } else {
                username = principal.toString();
            }

            Collection<? extends GrantedAuthority> authorities = SecurityContextHolder.getContext().getAuthentication().getAuthorities();
            boolean isAdmin = authorities.stream().anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));

            List<OrderResponse> orders;
            if (isAdmin) {
                if (status == null || status.equalsIgnoreCase("All")) {
                    orders = orderService.getAllOrders(null);
                } else {

                    orders = orderService.getAllOrders(status);
                }
            } else {

                if (status == null || status.equalsIgnoreCase("All")) {

                    orders = orderService.getOrdersByUser(username);
                } else {

                    orders = orderService.getOrdersByStatusAndUser(status, username);
                }
            }

            return ResponseEntity.ok(APIResponse.<List<OrderResponse>>builder()
                    .status("SUCCESS")
                    .results(orders)
                    .build());
        } catch (OrderServiceBusinessException ex) {
            log.error("Order service error occurred: {}", ex.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<OrderResponse>>builder()
                            .status("FAILED")
                            .errors(List.of(new ErrorDTO(ex.getMessage())))
                            .build());
        }
    }



}