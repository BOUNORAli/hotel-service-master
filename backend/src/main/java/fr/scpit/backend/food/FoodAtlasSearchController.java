package fr.scpit.backend.food;

import fr.scpit.backend.exception.FoodNotFoundException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.bson.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;

@RestController
@RequestMapping("/api/v1/foods")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Food Search")
public class FoodAtlasSearchController {

    private static final Logger LOGGER = LoggerFactory.getLogger(FoodAtlasSearchController.class);
    private final FoodAtlasSearchService foodAtlasSearchService;


    @Operation(
            summary = "Search for foods by keywords",
            description = "This endpoint allows you to search for foods by keywords.",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Successful operation"),
                    @ApiResponse(responseCode = "403", description = "Unauthorized / Invalid Token")
            }
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successful operation"),
            @ApiResponse(responseCode = "403", description = "Unauthorized / Invalid Token")
    })
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/with/{keywords}")
    public Collection<Document> getFoodsWithKeywords(@PathVariable String keywords,
                                                     @RequestParam(value = "limit", defaultValue = "5") int limit) {
        return foodAtlasSearchService.foodsByKeywords(keywords, limit);
    }

    @ExceptionHandler(FoodNotFoundException.class)
    @ResponseStatus(value = HttpStatus.NOT_FOUND, reason = "MongoDB didn't find any document.")
    public void handleNotFoundExceptions(FoodNotFoundException e) {
        LOGGER.info("=> Food not found: {}", e.toString());
    }

    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR, reason = "Internal Server Error")
    public void handleAllExceptions(RuntimeException e) {
        LOGGER.error("=> Internal server error.", e);
    }
}
