package fr.scpit.backend.food;

import fr.scpit.backend.exception.FoodServiceBusinessException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
@Slf4j
public class FoodService {

    public static final String FOOD_NOT_FOUND_WITH_ID = "Food not found with id: ";
    private final FoodRepository foodRepository;
    private final UserFavoritesRepository userFavoritesRepository;
    private final MongoTemplate mongoTemplate;

    public List<String> getCuisines() {
        Query query = new Query();
        query.fields().include("cuisines");
        return mongoTemplate.getCollection("foods")
                .distinct("cuisines", query.getQueryObject(), String.class).into(new ArrayList<>());
    }

    public List<FoodResponse> getFoodsByCuisine(String cuisine) {
        return foodRepository.getFoodsByCuisine(cuisine);
    }

    public FoodResponse createNewFood(FoodRequest foodRequest) throws FoodServiceBusinessException {
        log.info("FoodService:createNewFood execution started.");
        try {
            Food food = FoodMapper.convertToEntity(foodRequest);
            log.debug("FoodService:createNewFood request parameters {}", FoodMapper.jsonAsString(foodRequest));

            Food savedFood = foodRepository.save(food);
            FoodResponse foodResponse = FoodMapper.convertToDTO(savedFood);
            log.debug("FoodService:createNewFood received response from Database {}", FoodMapper.jsonAsString(foodResponse));
            return foodResponse;
        } catch (Exception ex) {
            log.error("Exception occurred while persisting Food to database , Exception message {}", ex.getMessage());
            throw new FoodServiceBusinessException("Failed to create a new food");
        } finally {
            log.info("FoodService:createNewFood execution ended.");
        }
    }

    public List<FoodResponse> getFoods() throws FoodServiceBusinessException {
        log.info("FoodService:getFoods execution started.");
        try {
            List<Food> foodList = foodRepository.findAll();
            List<FoodResponse> foodResponseList = foodList.stream()
                    .map(FoodMapper::convertToDTO)
                    .toList();
            log.debug("FoodService:getFoods retrieving foods from database  {}", FoodMapper.jsonAsString(foodResponseList));
            return foodResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving foods from database , Exception message {}", ex.getMessage());
            throw new FoodServiceBusinessException("Failed to fetch foods");
        } finally {
            log.info("FoodService:getFoods execution ended.");
        }
    }

    public List<FoodResponse> getPopularFoods() throws FoodServiceBusinessException {
        log.info("FoodService:getPopularFoods execution started.");
        try {
            List<Food> popularFoods = foodRepository.findAll().stream()
                    .filter(Food::isPopular)
                    .toList();
            List<FoodResponse> popularFoodResponses = popularFoods.stream()
                    .map(FoodMapper::convertToDTO)
                    .toList();
            log.debug("FoodService:getPopularFoods retrieving popular foods from database {}", FoodMapper.jsonAsString(popularFoodResponses));
            return popularFoodResponses;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving popular foods from database , Exception message {}", ex.getMessage());
            throw new FoodServiceBusinessException("Failed to fetch popular foods");
        } finally {
            log.info("FoodService:getPopularFoods execution ended.");
        }
    }

    public List<FoodResponse> getRecommendFoods() throws FoodServiceBusinessException {
        log.info("FoodService:getRecommendFoods execution started.");
        try {
            List<Food> recommendedFoods = foodRepository.findAll().stream()
                    .filter(Food::isRecommend)
                    .toList();
            List<FoodResponse> recommendedFoodResponses = recommendedFoods.stream()
                    .map(FoodMapper::convertToDTO)
                    .toList();
            log.debug("FoodService:getRecommendFoods retrieving recommended foods from database {}", FoodMapper.jsonAsString(recommendedFoodResponses));
            return recommendedFoodResponses;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving recommended foods from database , Exception message {}", ex.getMessage());
            throw new FoodServiceBusinessException("Failed to fetch recommended foods");
        } finally {
            log.info("FoodService:getRecommendFoods execution ended.");
        }
    }

    public List<FoodResponse> getFavoriteFoods(String userId) throws FoodServiceBusinessException {
        log.info("FoodService:getFavoriteFoods execution started.");
        try {
            Optional<UserFavorites> userFavoritesOpt = userFavoritesRepository.findByUserId(userId);
            List<String> favoriteFoodIds = userFavoritesOpt.map(UserFavorites::getFavoriteFoodIds).orElse(new ArrayList<>());

            List<Food> favoriteFoods = foodRepository.findAllById(favoriteFoodIds);
            List<FoodResponse> favoriteFoodResponses = favoriteFoods.stream()
                    .map(FoodMapper::convertToDTO)
                    .toList();

            log.debug("FoodService:getFavoriteFoods retrieving favorite foods from database {}", FoodMapper.jsonAsString(favoriteFoodResponses));
            return favoriteFoodResponses;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving favorite foods from database , Exception message {}", ex.getMessage());
            throw new FoodServiceBusinessException("Failed to fetch favorite foods");
        } finally {
            log.info("FoodService:getFavoriteFoods execution ended.");
        }
    }

    public void addToFavorites(String userId, String foodId) throws FoodServiceBusinessException {
        try {
            Optional<UserFavorites> userFavoritesOpt = userFavoritesRepository.findByUserId(userId);
            UserFavorites userFavorites = userFavoritesOpt.orElse(new UserFavorites(userId, new ArrayList<>()));

            if (userFavorites.getFavoriteFoodIds().contains(foodId)) {
                userFavorites.getFavoriteFoodIds().remove(foodId);
            } else {
                userFavorites.getFavoriteFoodIds().add(foodId);
            }

            userFavoritesRepository.save(userFavorites);
        } catch (Exception ex) {
            throw new FoodServiceBusinessException("Failed to toggle food favorite status with id: " + foodId);
        }
    }

    public FoodResponse getFoodById(String id) throws FoodServiceBusinessException {
        try {
            Optional<Food> optionalFood = foodRepository.findById(id);
            if (optionalFood.isPresent()) {
                Food food = optionalFood.get();
                return FoodMapper.convertToDTO(food);
            } else {
                throw new FoodServiceBusinessException(FOOD_NOT_FOUND_WITH_ID + id);
            }
        } catch (Exception ex) {
            throw new FoodServiceBusinessException("Failed to retrieve food with id: " + id);
        }
    }

    public List<FoodResponse> getFoodsByCategory(String categoryId) throws FoodServiceBusinessException {
        try {
            List<Food> foodList = foodRepository.findAll();
            List<FoodResponse> foodResponseList = foodList.stream()
                    .filter(food -> food.getCategories().stream()
                            .anyMatch(category -> category.getCategoryId().equals(categoryId)))
                    .map(FoodMapper::convertToDTO)
                    .toList();
            log.debug("FoodService:getFoodsByCategory retrieving foods from database for category {} {}", categoryId, FoodMapper.jsonAsString(foodResponseList));
            return foodResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving foods by category from database , Exception message {}", ex.getMessage());
            throw new FoodServiceBusinessException("Failed to fetch foods by category");
        } finally {
            log.info("FoodService:getFoodsByCategory execution ended.");
        }
    }

    public FoodResponse updateFood(String id, FoodRequest foodRequest) throws FoodServiceBusinessException {
        try {
            Optional<Food> optionalFood = foodRepository.findById(id);
            if (optionalFood.isPresent()) {
                Food updatedFood = FoodMapper.convertToEntity(foodRequest);
                updatedFood.setId(id);
                Food savedFood = foodRepository.save(updatedFood);
                return FoodMapper.convertToDTO(savedFood);
            } else {
                throw new FoodServiceBusinessException(FOOD_NOT_FOUND_WITH_ID + id);
            }
        } catch (Exception ex) {
            throw new FoodServiceBusinessException("Failed to update food with id: " + id);
        }
    }

    public void deleteFoodById(String id) throws FoodServiceBusinessException {
        try {
            foodRepository.deleteById(id);
        } catch (Exception ex) {
            throw new FoodServiceBusinessException("Failed to delete food with id: " + id);
        }
    }

    public List<FoodResponse> getMostFavoritedFoods() throws FoodServiceBusinessException {
        log.info("FoodService:getMostFavoritedFoods execution started.");
        try {

            List<Food> mostFavoritedFoods = foodRepository.findAll().stream()
                    .sorted((food1, food2) -> Integer.compare(food2.getFavoriteCount(), food1.getFavoriteCount()))
                    .limit(10)
                    .toList();


            List<FoodResponse> foodResponses = mostFavoritedFoods.stream()
                    .map(FoodMapper::convertToDTO)
                    .toList();

            return foodResponses;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving most favorited foods from database , Exception message {}", ex.getMessage());
            throw new FoodServiceBusinessException("Failed to fetch most favorited foods");
        } finally {
            log.info("FoodService:getMostFavoritedFoods execution ended.");
        }
    }


}
