package fr.scpit.backend.handler;


import fr.scpit.backend.exception.OrderItemNotFoundException;
import fr.scpit.backend.exception.OrderItemServiceBusinessException;
import fr.scpit.backend.handler.dto.APIResponse;
import fr.scpit.backend.handler.dto.ErrorDTO;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Collections;

@RestControllerAdvice
public class OrderItemServiceExceptionHandler {

    public static final String FAILED = "FAILED";

    @ExceptionHandler(OrderItemServiceBusinessException.class)
    public APIResponse<?> handleServiceException(OrderItemServiceBusinessException exception) {
        APIResponse<?> serviceResponse = new APIResponse<>();
        serviceResponse.setStatus(FAILED);
        serviceResponse.setErrors(Collections.singletonList(new ErrorDTO("", exception.getMessage())));
        return serviceResponse;
    }

    @ExceptionHandler(OrderItemNotFoundException.class)
    public APIResponse<?> handleOrderItemNotFoundException(OrderItemNotFoundException exception) {
        APIResponse<?> serviceResponse = new APIResponse<>();
        serviceResponse.setStatus(FAILED);
        serviceResponse.setErrors(Collections.singletonList(new ErrorDTO("", exception.getMessage())));
        return serviceResponse;
    }
}
