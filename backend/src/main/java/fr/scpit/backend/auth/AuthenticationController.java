package fr.scpit.backend.auth;

import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import fr.scpit.backend.token.TokenService;
import fr.scpit.backend.user.User;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Auth")
public class AuthenticationController {

    private final AuthenticationService service;
    private final TokenService tokenService;

    private static final String SUCCESS = "SUCCESS";
    private static final String FAILED = "FAILED";
    private static final String AUTHENTICATION_SERVICE_ERROR_OCCURRED = "Authentication service error occurred: {}";
    @CrossOrigin(origins = "http://localhost:50948")
    @GetMapping("/user")
    public User getUserByToken(@RequestParam String token) {
        return tokenService.findUserByToken(token);
    }



    @Operation(
            description = "Post endpoint for authentication",
            summary = "This is a summary for authentication post endpoint",
            responses = {
                    @ApiResponse(
                            description = "Success",
                            responseCode = "200"
                    ),
                    @ApiResponse(
                            description = "Unauthorized",
                            responseCode = "401"
                    )
            }
    )
    @CrossOrigin(origins = "http://localhost:50948")
    @PostMapping("/authenticate")
    public ResponseEntity<APIResponse<AuthenticationResponse>> authenticate(
            @RequestBody AuthenticationRequest request
    ) {
        try {
            AuthenticationResponse authenticationResponse = service.authenticate(request);
            APIResponse<AuthenticationResponse> responseDTO = APIResponse
                    .<AuthenticationResponse>builder()
                    .status(SUCCESS)
                    .results(authenticationResponse)
                    .build();
            return ResponseEntity.status(HttpStatus.OK).body(responseDTO);
        } catch (AuthenticationServiceException ex) {
            log.error(AUTHENTICATION_SERVICE_ERROR_OCCURRED, ex.getMessage());
            ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
            List<ErrorDTO> errors = new ArrayList<>();
            errors.add(errorDTO);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(APIResponse.<AuthenticationResponse>builder()
                            .status(FAILED)
                            .errors(errors)
                            .build());
        }
    }

    @PostMapping("/refresh-token")
    public void refreshToken(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        service.refreshToken(request, response);
    }


}
