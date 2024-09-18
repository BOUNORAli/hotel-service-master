package fr.scpit.backend.register;

import java.util.Optional;

import fr.scpit.backend.exception.RegisterServiceException;
import fr.scpit.backend.user.User;
import fr.scpit.backend.user.UserRepository;
import fr.scpit.backend.user.Role;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@Slf4j
public class RegisterService {

    private final UserRepository repository;
    private final PasswordEncoder passwordEncoder;

    public RegisterResponse register(RegisterRequest request) throws RegisterServiceException {
        log.info("RegisterService:register execution started.");
        log.info("RegisterService:register request received {}", request);

        try {
            String email = request.getEmail();
            Optional<User> existingUser = repository.findByEmail(email);
            if (existingUser.isPresent()) {
                throw new RegisterServiceException("User with email " + email + " already exists.");
            }

            if (request.getPassword() == null || request.getPassword().isEmpty()) {
                throw new RegisterServiceException("Password cannot be null or empty.");
            }

            log.info("RegisterService: received password {}", request.getPassword());

            String encodedPassword = passwordEncoder.encode(request.getPassword());
            log.info("RegisterService: encoded password {}", encodedPassword);

            Role userRole = request.getRole() != null ? request.getRole() : Role.USER;

            User user = User.builder()
                    .firstname(request.getFirstname())
                    .lastname(request.getLastname())
                    .email(email)
                    .password(encodedPassword)
                    .role(userRole)
                    .build();

            User savedUser = repository.save(user);

            RegisterResponse registerResponse = RegisterResponse.builder()
                    .firstname(savedUser.getFirstname())
                    .lastname(savedUser.getLastname())
                    .email(savedUser.getEmail())
                    .password(savedUser.getPassword())
                    .role(savedUser.getRole())
                    .build();

            log.debug("RegisterService:register received response from Database {}", registerResponse);
            return registerResponse;
        } catch (Exception ex) {
            log.error("Exception occurred while registering user, Exception message {}", ex.getMessage());
            throw new RegisterServiceException("Failed to register user");
        } finally {
            log.info("RegisterService:register execution ended.");
        }
    }
}

