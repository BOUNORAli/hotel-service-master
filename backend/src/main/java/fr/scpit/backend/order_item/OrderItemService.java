package fr.scpit.backend.order_item;

import fr.scpit.backend.exception.OrderItemServiceBusinessException;
import fr.scpit.backend.food.Food;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
@Slf4j
public class OrderItemService {

    private OrderItemRepository orderItemRepository;

    public OrderItemResponse createNewOrderItem(OrderItemRequest orderItemRequest) throws OrderItemServiceBusinessException {
        log.info("OrderItemService: createNewOrderItem execution started.");
        try {
            // Récupérer la nourriture de la demande
            Food food = orderItemRequest.getFood();
            // Convertir le prix de la nourriture en double
            double foodPrice = Double.parseDouble(food.getPrice());
            // Calculer le prix en multipliant le prix de la nourriture par la quantité
            double price = foodPrice * orderItemRequest.getQuantity();

            // Créer un nouvel objet OrderItem avec le prix calculé
            OrderItem orderItem = new OrderItem();
            orderItem.setFood(food);
            orderItem.setPrice(price);
            orderItem.setQuantity(orderItemRequest.getQuantity());

            // Sauvegarder l'objet OrderItem dans la base de données
            OrderItem savedOrderItem = orderItemRepository.save(orderItem);
            OrderItemResponse orderItemResponse = OrderItemMapper.mapToDto(savedOrderItem);
            log.debug("OrderItemService: createNewOrderItem received response from Database {}", OrderItemMapper.jsonAsString(orderItemResponse));
            return orderItemResponse;
        } catch (NumberFormatException ex) {
            log.error("Failed to parse food price to double, Exception message {}", ex.getMessage());
            throw new OrderItemServiceBusinessException("Failed to create a new order item due to invalid food price");
        } catch (Exception ex) {
            log.error("Exception occurred while persisting OrderItem to database, Exception message {}", ex.getMessage());
            throw new OrderItemServiceBusinessException("Failed to create a new order item");
        } finally {
            log.info("OrderItemService: createNewOrderItem execution ended.");
        }
    }


    public List<OrderItemResponse> getAllOrderItems() throws OrderItemServiceBusinessException {
        log.info("OrderItemService: getAllOrderItems execution started.");
        try {
            List<OrderItem> orderItemList = orderItemRepository.findAll();
            List<OrderItemResponse> orderItemDTOList = orderItemList.stream()
                    .map(OrderItemMapper::mapToDto)
                    .toList();
            log.debug("OrderItemService: getAllOrderItems retrieved order items from database  {}", OrderItemMapper.jsonAsString(orderItemDTOList));
            return orderItemDTOList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving order items from database, Exception message {}", ex.getMessage());
            throw new OrderItemServiceBusinessException("Failed to fetch order items");
        } finally {
            log.info("OrderItemService: getAllOrderItems execution ended.");
        }
    }


}
