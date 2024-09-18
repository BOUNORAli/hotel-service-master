package fr.scpit.backend.cart;

import fr.scpit.backend.exception.CartServiceBusinessException;
import fr.scpit.backend.exception.OrderServiceBusinessException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import fr.scpit.backend.order.OrderResponse;
import fr.scpit.backend.order.OrderService;
import fr.scpit.backend.order_item.OrderItemRequest;
import fr.scpit.backend.order_item.OrderItemResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
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
@RequestMapping("/api/v1/carts")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Cart")
public class CartController {

    private final CartService service;
    private final OrderService orderService;

    private static final String SUCCESS = "SUCCESS";
    private static final String FAILED = "FAILED";
    public static final String CART_SERVICE_ERROR_OCCURRED = "Cart service error occurred: {}";

    @Operation(
            description = "Post endpoint for cart",
            summary = "This is a summary for cart post endpoint",
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
    public ResponseEntity<APIResponse<CartResponse>> createNewCart(@RequestBody @Valid CartRequest cartRequest) {
        try {
            log.info("CartController::createNewCart request body {}", CartMapper.jsonAsString(cartRequest));
            CartResponse cartResponse = service.createNewCart(cartRequest);
            APIResponse<CartResponse> responseDTO = APIResponse.<CartResponse>builder()
                    .status(SUCCESS)
                    .results(cartResponse)
                    .build();
            log.info("CartController::createNewCart response {}", CartMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.CREATED);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CartResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Endpoint to create an empty cart",
            summary = "Creates an empty cart for the specified user ID",
            responses = {
                    @ApiResponse(
                            description = "Cart created successfully",
                            responseCode = "201",
                            content = @Content(
                                    schema = @Schema(implementation = APIResponse.class)
                            )
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }
    )
    @CrossOrigin(origins = "http://localhost:50948")
    @PostMapping("/createEmptyCart")
    public ResponseEntity<APIResponse<CartResponse>> createEmptyCart(@RequestParam String id) {
        try {
            log.info("CartController::createEmptyCart request received for user ID: {}", id);
            CartResponse cartResponse = service.createEmptyCart(id);
            APIResponse<CartResponse> responseDTO = APIResponse.<CartResponse>builder()
                    .status(SUCCESS)
                    .results(cartResponse)
                    .build();
            log.info("CartController::createEmptyCart response: {}", CartMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.CREATED);
        } catch (CartServiceBusinessException ex) {
            log.error("Error occurred while creating an empty cart: {}", ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CartResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for cart",
            summary = "This is a summary for cart get endpoint",
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
    public ResponseEntity<APIResponse<List<CartResponse>>> getCarts() {
        try {
            List<CartResponse> carts = service.getCarts();
            APIResponse<List<CartResponse>> responseDTO = APIResponse.<List<CartResponse>>builder()
                    .status(SUCCESS)
                    .results(carts)
                    .build();
            log.info("CartController::getCarts response {}", CartMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<CartResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for cart",
            summary = "This is a summary for cart get endpoint",
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
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/{id}")
    public ResponseEntity<APIResponse<CartResponse>> getCartById(@PathVariable String id) {
        try {
            CartResponse cart = service.getCartById(id);
            APIResponse<CartResponse> responseDTO = APIResponse.<CartResponse>builder()
                    .status(SUCCESS)
                    .results(cart)
                    .build();
            log.info("CartController::getCartById response {}", CartMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CartResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for carts by user ID",
            summary = "Get carts by user ID"
    )
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/user/{userId}")
    public ResponseEntity<APIResponse<List<CartResponse>>> getCartByUserId(@PathVariable String userId) {
        try {
            List<CartResponse> carts = service.getCartByUserId(userId);
            APIResponse<List<CartResponse>> responseDTO = APIResponse.<List<CartResponse>>builder()
                    .status(SUCCESS)
                    .results(carts)
                    .build();
            log.info("CartController::getCartByUserId response {}", CartMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<CartResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Put endpoint for cart",
            summary = "This is a summary for cart put endpoint",
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
    @PutMapping("/{id}")
    public ResponseEntity<APIResponse<CartResponse>> updateCart(@PathVariable String id, @RequestBody @Valid CartRequest cartRequest) {
        try {
            CartResponse updatedCart = service.updateCart(id, cartRequest);
            APIResponse<CartResponse> responseDTO = APIResponse.<CartResponse>builder()
                    .status(SUCCESS)
                    .results(updatedCart)
                    .build();
            log.info("CartController::updateCart response {}", CartMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CartResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Delete endpoint for cart",
            summary = "This is a summary for cart delete endpoint",
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
    @DeleteMapping("/{id}")
    public ResponseEntity<APIResponse<String>> deleteCartById(@PathVariable String id) {
        try {
            service.deleteCartById(id);
            APIResponse<String> responseDTO = APIResponse.<String>builder()
                    .status(SUCCESS)
                    .results("Cart deleted successfully")
                    .build();
            log.info("CartController::deleteCartById response {}", CartMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<String>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Add an order item to a cart",
            summary = "Add an order item to a cart by cart ID",
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
    @CrossOrigin(origins = "http://localhost:50948")
    @PutMapping("/{cartId}/orderItems")
    public ResponseEntity<APIResponse<CartResponse>> addOrderItemToCart(
            @PathVariable String cartId,
            @RequestBody @Valid OrderItemRequest orderItemRequest
    ) {
        try {
            CartResponse cartResponse = service.addOrderItemToCart(cartId, orderItemRequest);
            APIResponse<CartResponse> responseDTO = APIResponse.<CartResponse>builder()
                    .status(SUCCESS)
                    .results(cartResponse)
                    .build();
            return ResponseEntity.ok(responseDTO);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CartResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Delete an order item from a cart",
            summary = "Delete an order item from a cart by cart ID and order item ID",
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
    @CrossOrigin(origins = "http://localhost:50948")
    @DeleteMapping("/{cartId}/orderItems/{orderItemId}")
    public ResponseEntity<APIResponse<CartResponse>> deleteOrderItemFromCart(
            @PathVariable String cartId,
            @PathVariable String orderItemId
    ) {
        try {
            service.deleteOrderItemFromCart(cartId, orderItemId);
            return ResponseEntity.ok().build();
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CartResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get order items for a specific cart",
            summary = "Fetch order items by cart ID",
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
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/{cartId}/orderItems")
    public ResponseEntity<APIResponse<List<OrderItemResponse>>> getOrderItems(@PathVariable String cartId) {
        try {
            log.info("CartController::getOrderItems called with cartId: {}", cartId);
            List<OrderItemResponse> orderItems = service.getOrderItems(cartId);
            APIResponse<List<OrderItemResponse>> responseDTO = APIResponse.<List<OrderItemResponse>>builder()
                    .status(SUCCESS)
                    .results(orderItems)
                    .build();
            log.info("CartController::getOrderItems response: {}", CartMapper.jsonAsString(responseDTO));
            return ResponseEntity.ok(responseDTO);
        } catch (CartServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
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

    @Operation(
            description = "Checkout a cart",
            summary = "Checkout a cart by cart ID",
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
    @CrossOrigin(origins = "http://localhost:50948")
    @PostMapping("/{cartId}/checkout")
    public ResponseEntity<APIResponse<OrderResponse>> checkout(@PathVariable String cartId) {
        try {
            OrderResponse orderResponse = orderService.checkout(cartId);
            APIResponse<OrderResponse> responseDTO = APIResponse.<OrderResponse>builder()
                    .status(SUCCESS)
                    .results(orderResponse)
                    .build();
            return ResponseEntity.ok(responseDTO);
        } catch (OrderServiceBusinessException ex) {
            log.error(CART_SERVICE_ERROR_OCCURRED, ex.getMessage());
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

}
