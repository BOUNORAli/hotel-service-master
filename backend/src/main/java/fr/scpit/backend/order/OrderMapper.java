package fr.scpit.backend.order;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


public class OrderMapper {
    private OrderMapper(){}
    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    public static Order mapToEntity(OrderRequest request) {
        Order order = new Order();
        order.setId(request.getId());
        order.setName(request.getName());
        order.setAddress(request.getAddress());
        order.setPaymentId(request.getPaymentId());
        order.setTotalPrice(request.getTotalPrice());
        order.setItems(request.getItems());
        order.setStatus(request.getStatus());
        order.setUser(request.getUser());
        order.setCreatedAt(LocalDateTime.parse(request.getCreatedAt(), formatter));
        order.setUpdatedAt(LocalDateTime.parse(request.getUpdatedAt(), formatter));
        return order;
    }

    public static OrderResponse mapToDto(Order order) {
        OrderResponse response = new OrderResponse();
        response.setId(order.getId());
        response.setName(order.getName());
        response.setAddress(order.getAddress());
        response.setPaymentId(order.getPaymentId());
        response.setTotalPrice(order.getTotalPrice());
        response.setItems(order.getItems());
        response.setStatus(order.getStatus());
        response.setUser(order.getUser());
        response.setCreatedAt(order.getCreatedAt().format(formatter));
        response.setUpdatedAt(order.getUpdatedAt().format(formatter));
        return response;
    }

    public static String jsonAsString(Object obj) {
        try {
            return new ObjectMapper().writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return null;
        }
    }
}
