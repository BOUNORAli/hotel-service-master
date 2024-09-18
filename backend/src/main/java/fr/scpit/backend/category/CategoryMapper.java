package fr.scpit.backend.category;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class CategoryMapper {
    private CategoryMapper(){}
    public static Category convertToEntity(CategoryRequest categoryRequest) {
        Category category = new Category();
        category.setCategoryId(categoryRequest.getCategoryId());
        category.setCategoryName(categoryRequest.getCategoryName());
        category.setCategoryName(categoryRequest.getCategoryImage());
        return category;
    }

    public static CategoryResponse convertToDTO(Category category) {
        CategoryResponse categoryResponse = new CategoryResponse();
        categoryResponse.setCategoryId(category.getCategoryId());
        categoryResponse.setCategoryName(category.getCategoryName());
        categoryResponse.setCategoryImage(category.getCategoryImage());
        return categoryResponse;
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
