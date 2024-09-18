package fr.scpit.backend.cart;

import fr.scpit.backend.exception.CartServiceBusinessException;
import fr.scpit.backend.order_item.OrderItem;
import fr.scpit.backend.order_item.OrderItemRequest;
import fr.scpit.backend.order_item.OrderItemRepository;
import fr.scpit.backend.order_item.OrderItemResponse;
import fr.scpit.backend.order_item.OrderItemMapper;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.UUID;

@Service
@AllArgsConstructor
@Slf4j
public class CartService {

    public static final String CART_NOT_FOUND_WITH_ID = "Cart not found with id: ";
    public static final String INVALID_PRICE_FORMAT_FOR_PRODUCT_IN_ORDER_ITEM = "Invalid price format for product in order item";
    private final CartRepository repository;
    private final OrderItemRepository orderItemRepository;

    public CartResponse createNewCart(CartRequest cartRequest) throws CartServiceBusinessException {
        log.info("CartService:createNewCart execution started.");
        try {
            Cart cart = CartMapper.convertToEntity(cartRequest);
            cart.setUserId(cartRequest.getUserId());
            log.debug("CartService:createNewCart request parameters {}", CartMapper.jsonAsString(cartRequest));
            double totalPrice = calculateTotalPrice(cartRequest.getItems());
            cart.setTotalPrice(totalPrice);

            Cart savedCart = repository.save(cart);
            CartResponse cartResponse = CartMapper.convertToDTO(savedCart);
            log.debug("CartService:createNewCart received response from Database {}", CartMapper.jsonAsString(cartResponse));
            return cartResponse;
        } catch (NumberFormatException ex) {
            log.error(INVALID_PRICE_FORMAT_FOR_PRODUCT_IN_ORDER_ITEM);
            throw new CartServiceBusinessException(INVALID_PRICE_FORMAT_FOR_PRODUCT_IN_ORDER_ITEM);
        } catch (Exception ex) {
            log.error("Exception occurred while persisting Cart to database, Exception message {}", ex.getMessage());
            throw new CartServiceBusinessException("Failed to create a new cart");
        } finally {
            log.info("CartService:createNewCart execution ended.");
        }
    }


    private double calculateTotalPrice(List<OrderItem> orderItems) {
        return orderItems.stream()
                .mapToDouble(item -> Double.parseDouble(item.getFood().getPrice()) * item.getQuantity())
                .sum();
    }

    public CartResponse createEmptyCart(String userId) throws CartServiceBusinessException {
        log.info("CartService:createEmptyCart execution started.");
        try {
            if (userId == null || userId.isEmpty()) {
                throw new CartServiceBusinessException("User ID cannot be null or empty");
            }

            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setStatus("Empty");
            cart.setTotalPrice(0.0);
            cart.setCreatedAt(LocalDateTime.now().toString());
            cart.setUpdatedAt(LocalDateTime.now().toString());
            cart.setItems(List.of());
            Cart savedCart = repository.save(cart);
            CartResponse cartResponse = CartMapper.convertToDTO(savedCart);

            log.debug("CartService:createEmptyCart received response from Database {}", CartMapper.jsonAsString(cartResponse));
            return cartResponse;
        } catch (Exception ex) {
            log.error("Exception occurred while creating an empty Cart, Exception message {}", ex.getMessage());
            throw new CartServiceBusinessException("Failed to create an empty Cart");
        } finally {
            log.info("CartService:createEmptyCart execution ended.");
        }
    }

    public List<CartResponse> getCartByUserId(String userId) throws CartServiceBusinessException {
        try {
            List<Cart> cartList = repository.findByUserId(userId);
            List<CartResponse> cartResponseList = cartList.stream()
                    .map(CartMapper::convertToDTO)
                    .toList();
            log.debug("CartService:getCartByUserId retrieving carts for user {} from database  {}", userId, CartMapper.jsonAsString(cartResponseList));
            return cartResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving carts for user {} from database , Exception message {}", userId, ex.getMessage());
            throw new CartServiceBusinessException("Failed to fetch carts for user");
        } finally {
            log.info("CartService:getCartByUserId execution ended.");
        }
    }


    public List<CartResponse> getCarts() throws CartServiceBusinessException {
        log.info("CartService:getCarts execution started.");
        try {
            List<Cart> cartList = repository.findAll();
            List<CartResponse> cartResponseList = cartList.stream()
                    .map(CartMapper::convertToDTO)
                    .toList();
            log.debug("CartService:getCarts retrieving carts from database  {}", CartMapper.jsonAsString(cartResponseList));
            return cartResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving carts from database , Exception message {}", ex.getMessage());
            throw new CartServiceBusinessException("Failed to fetch carts");
        } finally {
            log.info("CartService:getCarts execution ended.");
        }
    }

    public CartResponse getCartById(String id) throws CartServiceBusinessException {
        try {
            Optional<Cart> optionalCart = repository.findById(id);
            if (optionalCart.isPresent()) {
                Cart cart = optionalCart.get();
                return CartMapper.convertToDTO(cart);
            } else {
                throw new CartServiceBusinessException(CART_NOT_FOUND_WITH_ID + id);
            }
        } catch (Exception ex) {
            throw new CartServiceBusinessException("Failed to retrieve cart with id: " + id);
        }
    }

    public CartResponse updateCart(String id, CartRequest cartRequest) throws CartServiceBusinessException {
        try {
            Optional<Cart> optionalCart = repository.findById(id);
            if (optionalCart.isPresent()) {
                Cart updatedCart = CartMapper.convertToEntity(cartRequest);
                updatedCart.setId(id);
                Cart savedCart = repository.save(updatedCart);
                return CartMapper.convertToDTO(savedCart);
            } else {
                throw new CartServiceBusinessException(CART_NOT_FOUND_WITH_ID + id);
            }
        } catch (Exception ex) {
            throw new CartServiceBusinessException("Failed to update cart with id: " + id);
        }
    }

    public void deleteCartById(String id) throws CartServiceBusinessException {
        try {
            repository.deleteById(id);
        } catch (Exception ex) {
            throw new CartServiceBusinessException("Failed to delete cart with id: " + id);
        }
    }

    public CartResponse addOrderItemToCart(String cartId, OrderItemRequest orderItemRequest) throws CartServiceBusinessException {
        try {
            Optional<Cart> optionalCart = repository.findById(cartId);
            if (optionalCart.isPresent()) {
                Cart cart = optionalCart.get();
                List<OrderItem> items = cart.getItems();
                double foodPrice = Double.parseDouble(orderItemRequest.getFood().getPrice());
                double totalOrderPrice = foodPrice * orderItemRequest.getQuantity();

                if (orderItemRequest.getFood() == null || orderItemRequest.getQuantity() <= 0) {
                    throw new CartServiceBusinessException("Invalid OrderItemRequest");
                }

                String orderItemId = UUID.randomUUID().toString();

                OrderItem newOrderItem = OrderItem.builder()
                        .id(orderItemId)
                        .food(orderItemRequest.getFood())
                        .price(totalOrderPrice)
                        .quantity(orderItemRequest.getQuantity())
                        .build();

                orderItemRepository.save(newOrderItem);

                items.add(newOrderItem);
                cart.setItems(items);
                double cartTotalPrice = cart.getTotalPrice() + totalOrderPrice;
                cart.setTotalPrice(cartTotalPrice);
                cart.setUpdatedAt(LocalDateTime.now().toString());
                repository.save(cart);

                log.info("OrderItem added successfully to cart with id: {}", cartId);
                return CartMapper.convertToDTO(cart);
            } else {
                throw new CartServiceBusinessException(CART_NOT_FOUND_WITH_ID + cartId);
            }
        } catch (NumberFormatException ex) {
            throw new CartServiceBusinessException(INVALID_PRICE_FORMAT_FOR_PRODUCT_IN_ORDER_ITEM);
        } catch (Exception ex) {
            throw new CartServiceBusinessException("Failed to add order item to cart with id: " + cartId);
        }
    }



    public void deleteOrderItemFromCart(String cartId, String orderItemId) throws CartServiceBusinessException {
        try {
            Optional<Cart> optionalCart = repository.findById(cartId);
            if (optionalCart.isPresent()) {
                Cart cart = optionalCart.get();
                List<OrderItem> items = cart.getItems();
                Optional<OrderItem> optionalOrderItem = items.stream()
                        .filter(item -> item.getId().equals(orderItemId))
                        .findFirst();
                if (optionalOrderItem.isPresent()) {
                    OrderItem orderItemToDelete = optionalOrderItem.get();
                    items.remove(orderItemToDelete);
                    double totalPrice = cart.getTotalPrice() - orderItemToDelete.getPrice();
                    cart.setTotalPrice(totalPrice);
                    repository.save(cart);
                } else {
                    throw new CartServiceBusinessException("Order item not found with id: " + orderItemId);
                }
            } else {
                throw new CartServiceBusinessException(CART_NOT_FOUND_WITH_ID + cartId);
            }
        } catch (Exception ex) {
            throw new CartServiceBusinessException("Failed to delete order item from cart with id: " + cartId);
        }
    }

    public List<OrderItemResponse> getOrderItems(String cartId) throws CartServiceBusinessException {
        try {
            log.info("CartService::getOrderItems called with cartId: {}", cartId);
            Optional<Cart> optionalCart = repository.findById(cartId);
            if (optionalCart.isPresent()) {
                Cart cart = optionalCart.get();
                List<OrderItem> items = cart.getItems();

                if (items == null || items.isEmpty()) {
                    log.error("CartService::getOrderItems found null or empty OrderItem list in cart with id: {}", cartId);
                    throw new CartServiceBusinessException("No OrderItems found in cart");
                }

                List<OrderItemResponse> orderItemResponses = items.stream()
                        .filter(item -> item != null && item.getId() != null)
                        .map(OrderItemMapper::mapToDto)
                        .collect(Collectors.toList());

                log.info("CartService::getOrderItems retrieved items: {}", orderItemResponses);
                return orderItemResponses;
            } else {
                throw new CartServiceBusinessException(CART_NOT_FOUND_WITH_ID + cartId);
            }
        } catch (Exception ex) {
            throw new CartServiceBusinessException("Failed to retrieve order items for cart with id: " + cartId);
        }
    }

}
