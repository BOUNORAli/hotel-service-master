package fr.scpit.backend.exception;

public class RegisterServiceException extends Exception {
    public RegisterServiceException(String message) {
        super(message);
    }

    public RegisterServiceException(String message, Throwable cause) {
        super(message, cause);
    }


}
