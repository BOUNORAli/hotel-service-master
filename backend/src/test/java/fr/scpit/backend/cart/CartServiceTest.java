package fr.scpit.backend.cart;

import fr.scpit.backend.exception.CartServiceBusinessException;
import fr.scpit.backend.food.Food;
import fr.scpit.backend.order_item.OrderItemRequest;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.ArrayList;
import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

public class CartServiceTest {

    @Mock
    private CartRepository cartRepository;

    @InjectMocks
    private CartService cartService;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void testAddOrderItemToCart() throws CartServiceBusinessException {
        // Mocking data
        String cartId = "testCartId";
        OrderItemRequest orderItemRequest = new OrderItemRequest();
        orderItemRequest.setFood(new Food());
        orderItemRequest.setPrice(10.99);
        orderItemRequest.setQuantity(2);

        // Mocking repository behavior
        Cart mockCart = new Cart();
        mockCart.setItems(new ArrayList<>()); // Assuming items list is initialized
        mockCart.setTotalPrice(0.0); // Assuming initial total price is 0
        when(cartRepository.findById(cartId)).thenReturn(Optional.of(mockCart));
        when(cartRepository.save(any(Cart.class))).thenReturn(mockCart);

        // Call the method
        cartService.addOrderItemToCart(cartId, orderItemRequest);

        // Assertions
        assertEquals(1, mockCart.getItems().size()); // Check if the item is added
        assertEquals(21.98, mockCart.getTotalPrice(), 0.001); // Check if total price is updated correctly
        verify(cartRepository, times(1)).save(mockCart); // Verify if save method is called
    }
}
