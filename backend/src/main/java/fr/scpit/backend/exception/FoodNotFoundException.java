package fr.scpit.backend.exception;

public class FoodNotFoundException extends RuntimeException{

    public FoodNotFoundException(String message) {
        super(message);
    }
}
