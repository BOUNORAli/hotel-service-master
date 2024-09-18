package fr.scpit.backend.client;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import fr.scpit.backend.user.User;

public class ClientMapper {
    private ClientMapper() {}

    public static Client mapToEntity(ClientRequest clientRequest) {
        return Client.builder()
                .id(clientRequest.getId())
                .firstName(clientRequest.getFirstName())
                .lastName(clientRequest.getLastName())
                .email(clientRequest.getEmail())
                .build();
    }

    public static ClientResponse mapToDto(Client client) {
        return ClientResponse.builder()
                .id(client.getId())
                .firstName(client.getFirstName())
                .lastName(client.getLastName())
                .email(client.getEmail())
                .build();
    }

    public static Client mapToClient(User user) {
        return Client.builder()
                .id(user.getId())
                .firstName(user.getFirstname())
                .lastName(user.getLastname())
                .email(user.getEmail())
                .build();
    }

    public static User mapToUser(Client client) {
        return User.builder()
                .id(client.getId())
                .firstname(client.getFirstName())
                .lastname(client.getLastName())
                .email(client.getEmail())
                .password("")
                .role(null)
                .tokens(null)
                .build();
    }

    public static String jsonAsString(Object obj) {
        try {
            return new ObjectMapper().writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return null;
        }
    }
}
