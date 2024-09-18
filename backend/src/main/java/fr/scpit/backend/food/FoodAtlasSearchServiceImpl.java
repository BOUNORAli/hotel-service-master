package fr.scpit.backend.food;

import com.mongodb.client.MongoCollection;
import fr.scpit.backend.exception.FoodNotFoundException;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static com.mongodb.client.model.Aggregates.*;
import static com.mongodb.client.model.Projections.*;
import static com.mongodb.client.model.search.SearchOperator.text;
import static com.mongodb.client.model.search.SearchOptions.searchOptions;
import static com.mongodb.client.model.search.SearchPath.fieldPath;

@Service
public class FoodAtlasSearchServiceImpl implements FoodAtlasSearchService {

    private static final Logger LOGGER = LoggerFactory.getLogger(FoodAtlasSearchServiceImpl.class);
    private final MongoCollection<Document> collection;
    @Value("${spring.data.mongodb.atlas.search.index}")
    private String index;

    public FoodAtlasSearchServiceImpl(MongoTemplate mongoTemplate) {
        this.collection = mongoTemplate.getCollection("foods");
    }

    @Override
    public Collection<Document> foodsByKeywords(String keywords, int limit) {
        LOGGER.info("=> Searching foods by keywords: {} with limit {}", keywords, limit);
        Bson searchStage = search(text(fieldPath("name"), keywords), searchOptions().index(index));
        Bson projectStage = project(fields(include("_id", "name", "price", "imageUrl", "categories", "cuisines", "cookTime")));
        Bson limitStage = limit(limit);
        List<Bson> pipeline = List.of(searchStage, projectStage, limitStage);
        List<Document> docs = collection.aggregate(pipeline).into(new ArrayList<>());

        for (Document doc : docs) {
            Object idObject = doc.get("_id");
            if (idObject instanceof ObjectId objectId) {
                doc.put("_id", objectId.toString());
            }
        }

        if (docs.isEmpty()) {
            throw new FoodNotFoundException("foodsByKeywords "+ ", keywords");
        }
        return docs;
    }




}
