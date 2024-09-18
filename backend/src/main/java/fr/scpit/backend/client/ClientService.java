package fr.scpit.backend.client;

import fr.scpit.backend.user.User;
import fr.scpit.backend.user.UserRepository;
import fr.scpit.backend.exception.ClientServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ClientService {
    @Autowired
    private UserRepository userRepository;

    public List<Client> getAllClients() {
        List<User> users = userRepository.findAll();
        return users.stream().map(this::convertToClient).collect(Collectors.toList());
    }

    public Client getClientById(String id) {
        User user = userRepository.findById(id).orElseThrow(() -> new ClientServiceException("Client not found"));
        return convertToClient(user);
    }

    public Client createClient(Client client) {
        User user = convertToUser(client);
        User savedUser = userRepository.save(user);
        return convertToClient(savedUser);
    }

    public Client updateClient(String id, Client client) {
        if (userRepository.existsById(id)) {
            client.setId(id);
            User user = convertToUser(client);
            User updatedUser = userRepository.save(user);
            return convertToClient(updatedUser);
        } else {
            throw new ClientServiceException("Client not found");
        }
    }

    public void deleteClient(String id) {
        if (!userRepository.existsById(id)) {
            throw new ClientServiceException("Client not found");
        }
        userRepository.deleteById(id);
    }

    private Client convertToClient(User user) {
        System.out.println("Converting User to Client: " + user);
        return Client.builder()
                .id(user.getId())
                .firstName(user.getFirstname() != null ? user.getFirstname() : "")
                .lastName(user.getLastname() != null ? user.getLastname() : "")
                .email(user.getEmail() != null ? user.getEmail() : "")
                .build();
    }

    private User convertToUser(Client client) {
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

    public int getTotalUsers() {
        return (int) userRepository.count();
    }


}
