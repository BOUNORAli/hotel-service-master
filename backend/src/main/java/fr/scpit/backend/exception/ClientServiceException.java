package fr.scpit.backend.exception;

public class ClientServiceException extends RuntimeException {
    public ClientServiceException(String message) {
        super(message);
    }
}
