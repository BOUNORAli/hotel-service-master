package fr.scpit.backend.food;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;

public interface FoodRepository extends MongoRepository<Food, String> {
    @Query(value = "{'cuisines': '?0'}")
    List<FoodResponse> getFoodsByCuisine(String cuisine);
}
