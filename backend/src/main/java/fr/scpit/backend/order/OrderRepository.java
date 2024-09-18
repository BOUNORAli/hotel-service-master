package fr.scpit.backend.order;

import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface OrderRepository extends MongoRepository<Order, String> {
    List<Order> findByStatus(String status);
    List<Order> findByStatusAndUser(String status, String user);
    List<Order> findByUser(String user);

}
