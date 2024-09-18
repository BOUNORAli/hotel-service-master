package fr.scpit.backend.exception;

public class CategoryServiceBusinessException extends RuntimeException{

    public CategoryServiceBusinessException(String message) {
        super(message);
    }
}
