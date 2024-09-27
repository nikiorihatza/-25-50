package com.minus.spring.presentation;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;

@RestController
@RequestMapping("/api")
public class ApiTokenController {

    @Value("${mapbox.api.token}")
    private String apiToken;

    @GetMapping("/token")
    public ResponseEntity<String> getApiToken() {
        if (apiToken != null && !apiToken.isEmpty()) {
            return ResponseEntity.ok(apiToken);
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Token not found");
        }
    }
}
