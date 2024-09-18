package fr.scpit.backend.food;

import fr.scpit.backend.category.Category;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "foods")
public class Food {
    @Id
    private String id;
    @NotBlank(message = "food name shouldn't be NULL OR EMPTY")
    private String name;
    private String price;
    private List<Category> categories;
    private boolean favorite;
    private boolean recommend;
    private boolean popular;
    private int stars;
    private String imageUrl;
    private List<String> cuisines;
    private String cookTime;
    private int favoriteCount;
}

