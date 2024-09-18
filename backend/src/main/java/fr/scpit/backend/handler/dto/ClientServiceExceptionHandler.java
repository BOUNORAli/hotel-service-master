package fr.scpit.backend.handler.dto;

import fr.scpit.backend.exception.ClientServiceException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.ArrayList;
import java.util.List;

@ControllerAdvice
public class ClientServiceExceptionHandler {

    @ExceptionHandler(ClientServiceException.class)
    public ResponseEntity<APIResponse<Object>> handleClientServiceException(ClientServiceException ex) {
        ErrorDTO errorDTO = new ErrorDTO(ex.getMessage());
        List<ErrorDTO> errors = new ArrayList<>();
        errors.add(errorDTO);

        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(APIResponse.<Object>builder()
                        .status("FAILED")
                        .errors(errors)
                        .build());
    }
}
