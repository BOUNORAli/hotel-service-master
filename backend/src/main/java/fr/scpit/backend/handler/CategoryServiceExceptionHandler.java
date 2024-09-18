package fr.scpit.backend.handler;

import fr.scpit.backend.exception.CategoryNotFoundException;
import fr.scpit.backend.exception.CategoryServiceBusinessException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@RestControllerAdvice
public class CategoryServiceExceptionHandler {

    public static final String FAILED = "FAILED";

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public APIResponse<?> handleMethodArgumentException(MethodArgumentNotValidException exception) {
        return getApiResponse(exception, FAILED);
    }

    static APIResponse<?> getApiResponse(MethodArgumentNotValidException exception, String failed) {
        APIResponse<?> serviceResponse = new APIResponse<>();
        List<ErrorDTO> errors = new ArrayList<>();
        exception.getBindingResult().getFieldErrors()
                .forEach(error -> {
                    ErrorDTO errorDTO = new ErrorDTO(error.getField(), error.getDefaultMessage());
                    errors.add(errorDTO);
                });
        serviceResponse.setStatus(failed);
        serviceResponse.setErrors(errors);
        return serviceResponse;
    }

    @ExceptionHandler(CategoryServiceBusinessException.class)
    public APIResponse<?> handleServiceException(CategoryServiceBusinessException exception) {
        APIResponse<?> serviceResponse = new APIResponse<>();
        serviceResponse.setStatus(FAILED);
        serviceResponse.setErrors(Collections.singletonList(new ErrorDTO("", exception.getMessage())));
        return serviceResponse;
    }

    @ExceptionHandler(CategoryNotFoundException.class)
    public APIResponse<?> handleBookNotFoundException(CategoryNotFoundException exception) {
        APIResponse<?> serviceResponse = new APIResponse<>();
        serviceResponse.setStatus(FAILED);
        serviceResponse.setErrors(Collections.singletonList(new ErrorDTO("", exception.getMessage())));
        return serviceResponse;
    }
}
