package com.minus.spring.persistence;

import com.minus.spring.domain.User;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface UserRepository extends MongoRepository<User, Long> {
    User findByUsername(String username);
}
