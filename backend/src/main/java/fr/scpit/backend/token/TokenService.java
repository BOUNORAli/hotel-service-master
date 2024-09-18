package fr.scpit.backend.token;

import fr.scpit.backend.user.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class TokenService {

    private final TokenRepository tokenRepository;

    @Autowired
    public TokenService(TokenRepository tokenRepository) {
        this.tokenRepository = tokenRepository;
    }

    public User findUserByToken(String tokenValue) {
        Optional<Token> token = tokenRepository.findByToken(tokenValue);
        return token != null ? token.get().getUser() : null;
    }
}

