package fr.scpit.backend.food;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "user_favorites")
public class UserFavorites {

    @Id
    private String userId;
    private List<String> favoriteFoodIds;
}
