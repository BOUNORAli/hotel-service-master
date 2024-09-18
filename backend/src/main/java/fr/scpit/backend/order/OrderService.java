package fr.scpit.backend.order;

import fr.scpit.backend.cart.Cart;
import fr.scpit.backend.cart.CartRepository;
import fr.scpit.backend.food.Food;
import fr.scpit.backend.food.FoodResponse;
import fr.scpit.backend.order_item.OrderItem;
import fr.scpit.backend.exception.OrderServiceBusinessException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;
import fr.scpit.backend.order.OrderStatus;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@Slf4j
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartRepository cartRepository;

    public OrderResponse createNewOrder(OrderRequest orderRequest) throws OrderServiceBusinessException {
        log.info("OrderService: createNewOrder execution started.");
        try {
            Order order = OrderMapper.mapToEntity(orderRequest);
            log.debug("OrderService: createNewOrder request parameters {}", OrderMapper.jsonAsString(orderRequest));

            Order savedOrder = orderRepository.save(order);
            OrderResponse orderResponse = OrderMapper.mapToDto(savedOrder);
            log.debug("OrderService: createNewOrder received response from Database {}", OrderMapper.jsonAsString(orderResponse));
            return orderResponse;
        } catch (Exception ex) {
            log.error("Exception occurred while persisting Order to database, Exception message {}", ex.getMessage());
            throw new OrderServiceBusinessException("Failed to create a new order");
        } finally {
            log.info("OrderService: createNewOrder execution ended.");
        }
    }

    public List<OrderResponse> getAllOrders(String status) throws OrderServiceBusinessException {
        log.info("OrderService: getAllOrders execution started.");
        try {
            List<Order> orderList;
            if (status != null) {
                orderList = orderRepository.findByStatus(status);
            } else {
                orderList = orderRepository.findAll();
            }
            List<OrderResponse> orderResponseList = orderList.stream()
                    .map(OrderMapper::mapToDto)
                    .toList();
            log.debug("OrderService: getAllOrders retrieved orders from database  {}", OrderMapper.jsonAsString(orderResponseList));
            return orderResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving orders from database, Exception message {}", ex.getMessage());
            throw new OrderServiceBusinessException("Failed to fetch orders");
        } finally {
            log.info("OrderService: getAllOrders execution ended.");
        }
    }

    public List<OrderResponse> getOrdersByUser(String username) throws OrderServiceBusinessException {
        log.info("OrderService: getOrdersByUser execution started.");
        try {
            List<Order> orderList = orderRepository.findByUser(username);
            List<OrderResponse> orderResponseList = orderList.stream()
                    .map(OrderMapper::mapToDto)
                    .collect(Collectors.toList());
            log.debug("OrderService: getOrdersByUser retrieved orders for user {} from database.", username);
            return orderResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving user orders from database, Exception message: {}", ex.getMessage());
            throw new OrderServiceBusinessException("Failed to fetch orders for user");
        } finally {
            log.info("OrderService: getOrdersByUser execution ended.");
        }
    }


    public OrderResponse updateOrderStatus(OrderStatusUpdateRequest request) throws OrderServiceBusinessException {
        log.info("OrderService: updateOrderStatus execution started. Order ID: {}, New Status: {}", request.getOrderId(), request.getStatus());
        try {
            Order order = orderRepository.findById(request.getOrderId())
                    .orElseThrow(() -> new OrderServiceBusinessException("Order not found"));
            order.setStatus(request.getStatus());
            order.setUpdatedAt(LocalDateTime.now());

            log.debug("OrderService: updateOrderStatus - updating order {}", OrderMapper.jsonAsString(order));
            Order updatedOrder = orderRepository.save(order);
            OrderResponse orderResponse = OrderMapper.mapToDto(updatedOrder);
            log.debug("OrderService: updateOrderStatus updated order in database {}", OrderMapper.jsonAsString(orderResponse));
            return orderResponse;
        } catch (Exception ex) {
            log.error("Exception occurred while updating Order, Exception message {}", ex.getMessage());
            throw new OrderServiceBusinessException("Failed to update order");
        } finally {
            log.info("OrderService: updateOrderStatus execution ended.");
        }
    }


    public void deleteOrder(String id) throws OrderServiceBusinessException {
        log.info("OrderService: deleteOrder execution started.");
        try {
            orderRepository.deleteById(id);
            log.debug("OrderService: deleteOrder deleted order from database");
        } catch (Exception ex) {
            log.error("Exception occurred while deleting Order, Exception message {}", ex.getMessage());
            throw new OrderServiceBusinessException("Failed to delete order");
        } finally {
            log.info("OrderService: deleteOrder execution ended.");
        }
    }

    public OrderResponse checkout(String cartId) throws OrderServiceBusinessException {
        log.info("Received cartId: {}", cartId);
        log.info("User roles: {}", SecurityContextHolder.getContext().getAuthentication().getAuthorities());
        try {
            Optional<Cart> optionalCart = cartRepository.findById(cartId);
            if (optionalCart.isPresent()) {
                Cart cart = optionalCart.get();

                if (cart.getItems().isEmpty()) {
                    log.info("Cart details: {}", cart);
                    log.info("Cart items: {}", cart.getItems());
                    throw new OrderServiceBusinessException("Cart is empty");
                }

                String username = ((UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getUsername();

                Order order = Order.builder()
                        .id(UUID.randomUUID().toString())
                        .name("Order for " + username)
                        .address("Default Address")
                        .paymentId("Default Payment ID")
                        .totalPrice(cart.getTotalPrice())
                        .items(cart.getItems())
                        .status("PENDING")
                        .user(username)
                        .createdAt(LocalDateTime.now())
                        .updatedAt(LocalDateTime.now())
                        .build();

                Order savedOrder = orderRepository.save(order);

                cart.setItems(List.of());
                cart.setTotalPrice(0.0);
                cartRepository.save(cart);

                log.info("Order created successfully from cart with id: {}", cartId);
                return OrderMapper.mapToDto(savedOrder);
            } else {
                throw new OrderServiceBusinessException("Cart not found with id: " + cartId);
            }
        } catch (Exception ex) {
            log.error("Exception occurred while checking out cart with id: {}, Exception message: {}", cartId, ex.getMessage());
            throw new OrderServiceBusinessException("Failed to checkout cart with id: " + cartId);
        }

    }


    public void updateOrderStatus(String orderId, String status) throws OrderServiceBusinessException {
        try {
            Order order = orderRepository.findById(orderId).orElseThrow(() -> new OrderServiceBusinessException("Order not found with id: " + orderId));
            order.setStatus(status);
            order.setUpdatedAt(LocalDateTime.now());
            orderRepository.save(order);
        } catch (Exception ex) {
            log.error("Exception occurred while updating order status with id: {}, Exception message: {}", orderId, ex.getMessage());
            throw new OrderServiceBusinessException("Failed to update order status with id: " + orderId);
        }
    }

    public List<OrderResponse> getOrdersByStatus(String status) throws OrderServiceBusinessException {
        log.info("OrderService: getOrdersByStatus execution started. Status: {}", status);
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

            List<Order> orderList;
            if (isAdmin) {
                if (status == null || status.isEmpty() || status.equals("All")) {
                    orderList = orderRepository.findAll();
                } else {
                    orderList = orderRepository.findByStatus(status);
                }
            } else {
                if (status == null || status.isEmpty() || status.equals("All")) {
                    orderList = orderRepository.findByUser(username);
                } else {
                    orderList = orderRepository.findByStatusAndUser(status, username);
                }
            }

            List<OrderResponse> orderResponseList = orderList.stream()
                    .map(OrderMapper::mapToDto)
                    .collect(Collectors.toList());

            log.debug("OrderService: getOrdersByStatus retrieved orders for user {}", username);
            return orderResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving orders by status from the database, Exception message: {}", ex.getMessage());
            throw new OrderServiceBusinessException("Failed to fetch orders by status");
        } finally {
            log.info("OrderService: getOrdersByStatus execution ended.");
        }
    }

    public List<OrderChartData> getOrdersOverTime() throws OrderServiceBusinessException {
        try {
            List<Order> allOrders = orderRepository.findAll();


            Map<String, Long> ordersGroupedByDate = allOrders.stream()
                    .collect(Collectors.groupingBy(order -> order.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")),
                            Collectors.counting()));


            List<OrderChartData> orderChartData = ordersGroupedByDate.entrySet().stream()
                    .map(entry -> new OrderChartData(entry.getKey(), entry.getValue().intValue()))
                    .collect(Collectors.toList());

            return orderChartData;
        } catch (Exception ex) {
            throw new OrderServiceBusinessException("Failed to fetch orders over time");
        }
    }


    public List<OrderResponse> getOrdersByStatusAndUser(String status, String username) throws OrderServiceBusinessException {
        log.info("OrderService: getOrdersByStatusAndUser started for user {} and status {}", username, status);
        try {
            List<Order> orderList = orderRepository.findByStatusAndUser(status, username);
            List<OrderResponse> orderResponseList = orderList.stream()
                    .map(OrderMapper::mapToDto)
                    .collect(Collectors.toList());

            log.info("OrderService: getOrdersByStatusAndUser finished for user {}", username);
            return orderResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving orders for user {}, Exception message {}", username, ex.getMessage());
            throw new OrderServiceBusinessException("Failed to fetch orders for user");
        }
    }


    public List<FoodResponse> getMostPurchasedFoods() {
        log.info("Fetching most purchased foods");

        List<Order> orders = orderRepository.findAll();


        Map<Food, Integer> foodPurchaseCount = orders.stream()
                .flatMap(order -> order.getItems().stream())
                .filter(orderItem -> orderItem.getFood() != null)
                .collect(Collectors.groupingBy(
                        OrderItem::getFood,
                        Collectors.summingInt(OrderItem::getQuantity)
                ));
        return foodPurchaseCount.entrySet().stream()
                .map(entry -> FoodResponse.builder()
                        .id(entry.getKey().getId())
                        .name(entry.getKey().getName())
                        .price(String.valueOf(entry.getKey().getPrice()))
                        .build())
                .sorted((f1, f2) -> Integer.compare(foodPurchaseCount.get(f2.getId()), foodPurchaseCount.get(f1.getId())))
                .limit(10)
                .toList();
    }




}
