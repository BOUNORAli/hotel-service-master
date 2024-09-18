package fr.scpit.backend.client;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import fr.scpit.backend.handler.dto.APIResponse;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/clients")
@CrossOrigin(origins = "http://localhost:50948")
public class ClientController {
    @Autowired
    private ClientService clientService;

    @GetMapping
    public List<ClientResponse> getAllClients() {
        return clientService.getAllClients().stream()
                .map(ClientMapper::mapToDto)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    public ClientResponse getClientById(@PathVariable String id) {
        Client client = clientService.getClientById(id);
        return ClientMapper.mapToDto(client);
    }

    @PostMapping
    public ClientResponse createClient(@RequestBody ClientRequest clientRequest) {
        Client client = ClientMapper.mapToEntity(clientRequest);
        client = clientService.createClient(client);
        return ClientMapper.mapToDto(client);
    }

    @PutMapping("/{id}")
    public ClientResponse updateClient(@PathVariable String id, @RequestBody ClientRequest clientRequest) {
        Client client = ClientMapper.mapToEntity(clientRequest);
        client = clientService.updateClient(id, client);
        return ClientMapper.mapToDto(client);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteClient(@PathVariable String id) {
        clientService.deleteClient(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/count")
    public ResponseEntity<APIResponse<Integer>> getTotalUsers() {
        try {
            int totalUsers = clientService.getTotalUsers();
            return ResponseEntity.ok(APIResponse.<Integer>builder()
                    .status("SUCCESS")
                    .results(totalUsers)
                    .build());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(APIResponse.<Integer>builder()
                            .status("FAILED")
                            .build());
        }
    }

}
