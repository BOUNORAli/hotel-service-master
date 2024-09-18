package fr.scpit.backend.order_item;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface OrderItemRepository extends MongoRepository<OrderItem,String> {
}
