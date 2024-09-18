package fr.scpit.backend.category;


import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryRequest {
    @NotBlank(message = "category id shouldn't be NULL OR EMPTY")
    private String categoryId;
    @NotBlank(message = "category name shouldn't be NULL OR EMPTY")
    private String categoryName;
    private String categoryImage;
}


