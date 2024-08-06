package com.minus.spring.service;

import com.minus.spring.domain.SaleProduct;
import com.minus.spring.domain.User;
import com.minus.spring.persistence.SaleProductRepository;
import com.minus.spring.persistence.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SaleProductRepository saleProductRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).orElseThrow();
    }

    public User saveUser(User user) {
        return userRepository.save(user);
    }

    public void deleteUserById(Long id) {
        userRepository.deleteById(id);
    }

    public User addSaleProductToFavorites(Long userId, Long productId) {
        Optional<User> userOpt = userRepository.findById(userId);
        Optional<SaleProduct> productOpt = saleProductRepository.findById(productId);

        if (userOpt.isPresent() && productOpt.isPresent()) {
            User user = userOpt.get();
            user.getFavorites().add(productId);
            return userRepository.save(user);
        } else {
            throw new RuntimeException("User or SaleProduct not found");
        }
    }
}
