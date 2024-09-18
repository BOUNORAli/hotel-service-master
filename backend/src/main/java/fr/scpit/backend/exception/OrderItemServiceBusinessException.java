package fr.scpit.backend.exception;

public class OrderItemServiceBusinessException extends RuntimeException{

    public OrderItemServiceBusinessException(String message) {
        super(message);
    }
}
