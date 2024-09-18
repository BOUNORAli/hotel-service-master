package fr.scpit.backend.category;

import fr.scpit.backend.exception.CategoryServiceBusinessException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
@Slf4j
public class CategoryService {

    private final CategoryRepository repository;

    public CategoryResponse createNewCategory(CategoryRequest categoryRequest) throws CategoryServiceBusinessException {
        log.info("CategoryService:createNewCategory execution started.");
        try {
            Category category = CategoryMapper.convertToEntity(categoryRequest);
            log.debug("CategoryService:createNewCategory request parameters {}", CategoryMapper.jsonAsString(categoryRequest));

            Category savedCategory = repository.save(category);
            CategoryResponse categoryResponse = CategoryMapper.convertToDTO(savedCategory);
            log.debug("CategoryService:createNewCategory received response from Database {}", CategoryMapper.jsonAsString(categoryResponse));
            return categoryResponse;
        } catch (Exception ex) {
            log.error("Exception occurred while persisting Category to database , Exception message {}", ex.getMessage());
            throw new CategoryServiceBusinessException("Failed to create a new category");
        } finally {
            log.info("CategoryService:createNewCategory execution ended.");
        }

    }

    public List<CategoryResponse> getCategories() throws CategoryServiceBusinessException {
        log.info("CategoryService:getCategories execution started.");
        try {
            List<Category> categoryList = repository.findAll();
            List<CategoryResponse> categoryResponseList = categoryList.stream()
                    .map(CategoryMapper::convertToDTO)
                    .toList();
            log.debug("CategoryService:getCategories retrieving categories from database  {}", CategoryMapper.jsonAsString(categoryResponseList));
            return categoryResponseList;
        } catch (Exception ex) {
            log.error("Exception occurred while retrieving categories from database , Exception message {}", ex.getMessage());
            throw new CategoryServiceBusinessException("Failed to fetch categories");
        } finally {
            log.info("CategoryService:getCategories execution ended.");
        }
    }

    public CategoryResponse getCategoryById(String id) throws CategoryServiceBusinessException {
        try {
            Optional<Category> optionalCategory = repository.findById(id);
            if (optionalCategory.isPresent()) {
                Category category = optionalCategory.get();
                return CategoryMapper.convertToDTO(category);
            } else {
                throw new CategoryServiceBusinessException("Category not found with id: " + id);
            }
        } catch (Exception ex) {
            throw new CategoryServiceBusinessException("Failed to retrieve category with id: " + id);
        }
    }

    public CategoryResponse updateCategory(String id, CategoryRequest categoryRequest) throws CategoryServiceBusinessException {
        try {
            Optional<Category> optionalCategory = repository.findById(id);
            if (optionalCategory.isPresent()) {
                Category updatedCategory = CategoryMapper.convertToEntity(categoryRequest);
                updatedCategory.setCategoryId(id); // Set the ID of the existing category
                Category savedCategory = repository.save(updatedCategory);
                return CategoryMapper.convertToDTO(savedCategory);
            } else {
                throw new CategoryServiceBusinessException("Category not found with id: " + id);
            }
        } catch (Exception ex) {
            throw new CategoryServiceBusinessException("Failed to update category with id: " + id);
        }
    }

    public void deleteCategoryById(String id) throws CategoryServiceBusinessException {
        try {
            repository.deleteById(id);
        } catch (Exception ex) {
            throw new CategoryServiceBusinessException("Failed to delete category with id: " + id);
        }
    }
}
