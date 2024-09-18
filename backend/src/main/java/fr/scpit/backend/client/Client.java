package fr.scpit.backend.client;

import fr.scpit.backend.user.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "_users")
public class Client {
    @Id
    private String id;
    private String firstName;
    private String lastName;
    private String email;
}
