package fr.scpit.backend.user;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class UpdateNameRequest {
    private String firstName;
    private String lastName;
}
