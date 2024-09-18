package fr.scpit.backend.food;

import org.bson.Document;

import java.util.Collection;

public interface FoodAtlasSearchService {

    Collection<Document> foodsByKeywords(String keywords, int limit);
}
