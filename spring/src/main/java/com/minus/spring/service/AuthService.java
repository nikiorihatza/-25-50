package com.minus.spring.service;

import com.minus.spring.domain.User;
import com.minus.spring.persistence.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    public User authenticate(String username, String hashedPassword) {
        User user = userRepository.findByUsername(username);
        if (user != null && user.getPassword().equals(hashedPassword)) {
            return user;
        } else {
            throw new RuntimeException("Invalid credentials");
        }
    }
}
