package fr.scpit.backend.handler;


import fr.scpit.backend.exception.FoodNotFoundException;
import fr.scpit.backend.exception.FoodServiceBusinessException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Collections;

import static fr.scpit.backend.handler.CategoryServiceExceptionHandler.getApiResponse;

@RestControllerAdvice
public class FoodServiceExceptionHandler {

    public static final String FAILED = "FAILED";

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public APIResponse<?> handleMethodArgumentException(MethodArgumentNotValidException exception) {
        return getApiResponse(exception, FAILED);
    }

    @ExceptionHandler(FoodServiceBusinessException.class)
    public APIResponse<?> handleServiceException(FoodServiceBusinessException exception) {
        APIResponse<?> serviceResponse = new APIResponse<>();
        serviceResponse.setStatus(FAILED);
        serviceResponse.setErrors(Collections.singletonList(new ErrorDTO("", exception.getMessage())));
        return serviceResponse;
    }

    @ExceptionHandler(FoodNotFoundException.class)
    public APIResponse<?> handleFoodNotFoundException(FoodNotFoundException exception) {
        APIResponse<?> serviceResponse = new APIResponse<>();
        serviceResponse.setStatus(FAILED);
        serviceResponse.setErrors(Collections.singletonList(new ErrorDTO("", exception.getMessage())));
        return serviceResponse;
    }
}
