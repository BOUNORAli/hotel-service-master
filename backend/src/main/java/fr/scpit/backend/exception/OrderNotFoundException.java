package fr.scpit.backend.exception;

public class OrderNotFoundException extends RuntimeException{

    public OrderNotFoundException(String message) {
        super(message);
    }
}
