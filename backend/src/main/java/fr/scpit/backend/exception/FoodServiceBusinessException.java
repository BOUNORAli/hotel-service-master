package fr.scpit.backend.exception;

public class FoodServiceBusinessException extends RuntimeException{

    public FoodServiceBusinessException(String message) {
        super(message);
    }
}
