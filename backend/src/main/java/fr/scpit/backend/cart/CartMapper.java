package fr.scpit.backend.cart;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class CartMapper {
    private CartMapper(){}

    public static Cart convertToEntity(CartRequest cartRequest) {
        Cart cart = new Cart();
        cart.setId(cartRequest.getId());
        cart.setUserId(cartRequest.getUserId());
        cart.setItems(cartRequest.getItems());
        cart.setStatus(cartRequest.getStatus());
        cart.setTotalPrice(cartRequest.getTotalPrice());
        cart.setCreatedAt(cartRequest.getCreatedAt());
        cart.setUpdatedAt(cartRequest.getUpdatedAt());
        return cart;
    }

    public static CartResponse convertToDTO(Cart cart) {
        CartResponse cartResponse = new CartResponse();
        cartResponse.setId(cart.getId());
        cartResponse.setUserId(cart.getUserId());
        cartResponse.setItems(cart.getItems());
        cartResponse.setStatus(cart.getStatus());
        cartResponse.setTotalPrice(cart.getTotalPrice());
        cartResponse.setCreatedAt(cart.getCreatedAt());
        cartResponse.setUpdatedAt(cart.getUpdatedAt());
        return cartResponse;
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
