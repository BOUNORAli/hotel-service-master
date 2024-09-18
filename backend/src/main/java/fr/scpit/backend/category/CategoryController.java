package fr.scpit.backend.category;

import fr.scpit.backend.exception.CategoryServiceBusinessException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/categories")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Category")
public class CategoryController {

    private final CategoryService service;

    private static final String SUCCESS = "SUCCESS";
    private static final String FAILED = "FAILED";
    public static final String CATEGORY_SERVICE_ERROR_OCCURRED = "Category service error occurred: {}";

    @Operation(
            description = "Post endpoint for category",
            summary = "This is a summary for category post endpoint",
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
    public ResponseEntity<APIResponse<CategoryResponse>> createNewCategory(@RequestBody @Valid CategoryRequest categoryRequest) {
        try {
            log.info("CategoryController::createNewCategory request body {}", CategoryMapper.jsonAsString(categoryRequest));
            CategoryResponse categoryResponse = service.createNewCategory(categoryRequest);
            APIResponse<CategoryResponse> responseDTO = APIResponse
                    .<CategoryResponse>builder()
                    .status(SUCCESS)
                    .results(categoryResponse)
                    .build();
            log.info("CategoryController::createNewCategory response {}", CategoryMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.CREATED);
        } catch (CategoryServiceBusinessException ex) {
            log.error(CATEGORY_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CategoryResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for category",
            summary = "This is a summary for category get endpoint",
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
    public ResponseEntity<APIResponse<List<CategoryResponse>>> getCategories() {
        try {
            List<CategoryResponse> categories = service.getCategories();
            APIResponse<List<CategoryResponse>> responseDTO = APIResponse
                    .<List<CategoryResponse>>builder()
                    .status(SUCCESS)
                    .results(categories)
                    .build();
            log.info("CategoryController::getCategories response {}", CategoryMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CategoryServiceBusinessException ex) {
            log.error(CATEGORY_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<List<CategoryResponse>>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @Operation(
            description = "Get endpoint for category",
            summary = "This is a summary for category get endpoint",
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
    public ResponseEntity<APIResponse<CategoryResponse>> getCategoryById(@PathVariable String id) {
        try {
            CategoryResponse category = service.getCategoryById(id);
            APIResponse<CategoryResponse> responseDTO = APIResponse
                    .<CategoryResponse>builder()
                    .status(SUCCESS)
                    .results(category)
                    .build();
            log.info("CategoryController::getCategoryById response {}", CategoryMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CategoryServiceBusinessException ex) {
            log.error(CATEGORY_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CategoryResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }


    }

    @Operation(
            description = "Put endpoint for category",
            summary = "This is a summary for category put endpoint",
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
    public ResponseEntity<APIResponse<CategoryResponse>> updateCategory(@PathVariable String id, @RequestBody @Valid CategoryRequest categoryRequest) {
        try {
            CategoryResponse updatedCategory = service.updateCategory(id, categoryRequest);
            APIResponse<CategoryResponse> responseDTO = APIResponse
                    .<CategoryResponse>builder()
                    .status(SUCCESS)
                    .results(updatedCategory)
                    .build();
            log.info("CategoryController::updateCategory response {}", CategoryMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CategoryServiceBusinessException ex) {
            log.error(CATEGORY_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<CategoryResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }


    }

    @Operation(
            description = "Delete endpoint for category",
            summary = "This is a summary for category delete endpoint",
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
    public ResponseEntity<APIResponse<String>> deleteCategoryById(@PathVariable String id) {
        try {
            service.deleteCategoryById(id);
            APIResponse<String> responseDTO = APIResponse
                    .<String>builder()
                    .status(SUCCESS)
                    .results("Category deleted successfully")
                    .build();
            log.info("CategoryController::deleteCategoryById response {}", CategoryMapper.jsonAsString(responseDTO));
            return new ResponseEntity<>(responseDTO, HttpStatus.OK);
        } catch (CategoryServiceBusinessException ex) {
            log.error(CATEGORY_SERVICE_ERROR_OCCURRED, ex.getMessage());
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
}
