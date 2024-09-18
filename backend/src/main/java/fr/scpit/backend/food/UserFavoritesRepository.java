package fr.scpit.backend.food;

import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface UserFavoritesRepository extends MongoRepository<UserFavorites, String> {
    Optional<UserFavorites> findByUserId(String userId);
}
