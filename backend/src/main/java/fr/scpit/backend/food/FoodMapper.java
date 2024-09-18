package fr.scpit.backend.food;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class FoodMapper {
    private FoodMapper() {
    }

    public static Food convertToEntity(FoodRequest foodRequest) {
        return Food.builder()
                .id(foodRequest.getId())
                .name(foodRequest.getName())
                .price(foodRequest.getPrice())
                .categories(foodRequest.getCategories())
                .favorite(foodRequest.isFavorite())
                .recommend(foodRequest.isRecommend())
                .popular(foodRequest.isPopular())
                .stars(foodRequest.getStars())
                .imageUrl(foodRequest.getImageUrl())
                .cuisines(foodRequest.getOrigins())
                .cookTime(foodRequest.getCookTime())
                .build();
    }

    public static FoodResponse convertToDTO(Food food) {
        return FoodResponse.builder()
                .id(food.getId())
                .name(food.getName())
                .price(food.getPrice())
                .categories(food.getCategories())
                .favorite(food.isFavorite())
                .recommend(food.isRecommend())
                .popular(food.isPopular())
                .stars(food.getStars())
                .imageUrl(food.getImageUrl())
                .origins(food.getCuisines())
                .cookTime(food.getCookTime())
                .build();
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
