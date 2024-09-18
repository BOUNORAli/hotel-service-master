package fr.scpit.backend.handler.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ErrorDTO {

    private String field;
    private String errorMessage;

    public ErrorDTO(String errorMessage){
        this.errorMessage=errorMessage;
    }
}
