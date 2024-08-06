package com.minus.spring.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "users")

@Getter
@Setter

@AllArgsConstructor
@NoArgsConstructor
public class User {
    @Id
    private Long id;
    private String username;
    private String password;
    private List<Long> favorites; // List of IDs
    private String city;
    private int postcode;
    private String address;
    private String role;
    private Store store;
}
