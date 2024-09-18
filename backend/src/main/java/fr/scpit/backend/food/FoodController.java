package fr.scpit.backend.food;

import fr.scpit.backend.exception.FoodServiceBusinessException;
import fr.scpit.backend.config.JwtService;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;

import fr.scpit.backend.order.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import fr.scpit.backend.order.OrderService;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/foods")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Food")
public class FoodController {

    private final FoodService foodService;

    private final OrderService orderService;

    private final JwtService jwtService;
    private static final String SUCCESS = "SUCCESS";
    private static final String FAILED = "FAILED";
    public static final String FOOD_SERVICE_ERROR_OCCURRED = "Food service error occurred: {}";

    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/cuisines")
    public ResponseEntity<List<String>> getCuisines() {
        List<String> cuisines = foodService.getCuisines();
        return ResponseEntity.ok(cuisines);
    }

    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("cuisines/{cuisine}")
    public ResponseEntity<APIResponse<List<FoodResponse>>> getFoodsByCuisine(@PathVariable String cuisine) {
        try {
            List<FoodResponse> foods = foodService.getFoodsByCuisine(cuisine);
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(foods)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Post endpoint for food",
            summary = "This is a summary for food post endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "201"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @PostMapping
    public ResponseEntity<APIResponse<FoodResponse>> createNewFood(@RequestBody @Valid FoodRequest foodRequest) {
        try {
            log.info("Creating new food: {}", foodRequest);
            FoodResponse foodResponse = foodService.createNewFood(foodRequest);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(APIResponse.<FoodResponse>builder()
                            .status(SUCCESS)
                            .results(foodResponse)
                            .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<FoodResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for food",
            summary = "This is a summary for food get endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping
    public ResponseEntity<APIResponse<List<FoodResponse>>> getFoods() {
        try {
            List<FoodResponse> foods = foodService.getFoods();
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(foods)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for popular food",
            summary = "This is a summary for food get endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/popular")
    public ResponseEntity<APIResponse<List<FoodResponse>>> getPopularFoods() {
        try {
            List<FoodResponse> foods = foodService.getPopularFoods();
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(foods)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for popular food",
            summary = "This is a summary for food get endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/recommend")
    public ResponseEntity<APIResponse<List<FoodResponse>>> getRecommendFoods() {
        try {
            List<FoodResponse> foods = foodService.getRecommendFoods();
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(foods)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for favorite food",
            summary = "This is a summary for food get favorite endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }
    )
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/favorite")
    public ResponseEntity<APIResponse<List<FoodResponse>>> getFavoriteFoods(@RequestHeader("Authorization") String token) {
        try {
            String userId = jwtService.extractUsername(token.replace("Bearer ", ""));
            List<FoodResponse> favoriteFoods = foodService.getFavoriteFoods(userId);
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(favoriteFoods)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for food",
            summary = "This is a summary for food get endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @GetMapping("/{id}")
    public ResponseEntity<APIResponse<FoodResponse>> getFoodById(@PathVariable String id) {
        try {
            FoodResponse food = foodService.getFoodById(id);
            return ResponseEntity.ok(APIResponse.<FoodResponse>builder()
                    .status(SUCCESS)
                    .results(food)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<FoodResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for food",
            summary = "This is a summary for food get by category endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/category/{categoryId}")
    public ResponseEntity<APIResponse<List<FoodResponse>>> getFoodsByCategory(@PathVariable String categoryId) {
        try {
            List<FoodResponse> foods = foodService.getFoodsByCategory(categoryId);
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(foods)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Put endpoint for food",
            summary = "This is a summary for food put endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @PutMapping("/{id}")
    public ResponseEntity<APIResponse<FoodResponse>> updateFood(@PathVariable String id, @RequestBody @Valid FoodRequest foodRequest) {
        try {
            FoodResponse updatedFood = foodService.updateFood(id, foodRequest);
            return ResponseEntity.ok(APIResponse.<FoodResponse>builder()
                    .status(SUCCESS)
                    .results(updatedFood)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<FoodResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Delete endpoint for food",
            summary = "This is a summary for food delete endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }

    )
    @DeleteMapping("/{id}")
    public ResponseEntity<APIResponse<String>> deleteFoodById(@PathVariable String id) {
        try {
            foodService.deleteFoodById(id);
            return ResponseEntity.ok(APIResponse.<String>builder()
                    .status(SUCCESS)
                    .results("Food deleted successfully")
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<String>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Post endpoint to toggle favorite status of a food",
            summary = "Toggle favorite status of a food",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized / Invalid Token",
                            responseCode = "403"
                    )
            }
    )
    @CrossOrigin(origins = "http://localhost:50948")
    @PostMapping("/favorite/{foodId}")
    public ResponseEntity<APIResponse<String>> markAsFavorite(@PathVariable String foodId, @RequestHeader("Authorization") String token) {
        try {
            log.info("Toggling favorite status for food: {}", foodId);
            String userId = jwtService.extractUsername(token.replace("Bearer ", ""));
            foodService.addToFavorites(userId, foodId);
            return ResponseEntity.ok(APIResponse.<String>builder()
                    .status(SUCCESS)
                    .results("Food favorite status toggled")
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<String>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/most-favorited")
    public ResponseEntity<APIResponse<List<FoodResponse>>> getMostFavoritedFoods() {
        try {
            List<FoodResponse> mostFavoritedFoods = foodService.getMostFavoritedFoods();
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(mostFavoritedFoods)
                    .build());
        } catch (FoodServiceBusinessException ex) {
            log.error(FOOD_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }


    @GetMapping("/most-purchased")
    public ResponseEntity<APIResponse<List<FoodResponse>>> getMostPurchasedFoods() {
        try {
            List<FoodResponse> mostPurchasedFoods = orderService.getMostPurchasedFoods();
            return ResponseEntity.ok(APIResponse.<List<FoodResponse>>builder()
                    .status(SUCCESS)
                    .results(mostPurchasedFoods)
                    .build());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(APIResponse.<List<FoodResponse>>builder()
                            .status(FAILED)
                            .errors(List.of(new ErrorDTO(ex.getMessage())))
                            .build());
        }
    }


}
