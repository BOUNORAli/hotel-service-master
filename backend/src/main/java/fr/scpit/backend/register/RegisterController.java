package fr.scpit.backend.register;

import fr.scpit.backend.exception.RegisterServiceException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/auth/register")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Register")
public class RegisterController {

    private final RegisterService service;

    private static final String SUCCESS = "SUCCESS";
    private static final String FAILED = "FAILED";
    private static final String REGISTER_SERVICE_ERROR_OCCURRED = "Register service error occurred: {}";

    @Operation(
            description = "Post endpoint for registration",
            summary = "This is a summary for registration post endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "201"
                    ),
                    @ApiResponse(
                            description = "Bad Request",
                            responseCode = "400"
                    )
            }

    )
    @CrossOrigin(origins = "http://localhost:50948")
    @PostMapping
    public ResponseEntity<APIResponse<RegisterResponse>> register(@RequestBody RegisterRequest request) {
        log.info("Received RegisterRequest: {}", request); // testt
        try {
            log.info("RegisterController::register request body {}", request);
            RegisterResponse registerResponse = service.register(request);
            APIResponse<RegisterResponse> responseDTO = APIResponse
                    .<RegisterResponse>builder()
                    .status(SUCCESS)
                    .results(registerResponse)
                    .build();
            log.info("RegisterController::register response {}", responseDTO);
            return new ResponseEntity<>(responseDTO, HttpStatus.CREATED);
        } catch (RegisterServiceException ex) {
            log.error(REGISTER_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<RegisterResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }
}
