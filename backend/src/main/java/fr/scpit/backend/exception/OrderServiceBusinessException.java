package fr.scpit.backend.exception;

public class OrderServiceBusinessException extends RuntimeException {
    public OrderServiceBusinessException(String message) {
        super(message);
    }
}
