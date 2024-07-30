package com.minus.spring.presentation;

import com.minus.spring.domain.Store;
import java.util.*;
import com.minus.spring.persistence.StoreRepository;
import com.minus.spring.service.StoreService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/store")
public record StoreController(StoreRepository storeRepository, StoreService storeService) {

    @GetMapping("/getAll")
    ResponseEntity<List<Store>> getAllStores() {
        return ResponseEntity.ok(storeRepository.findAll());
    }

    @GetMapping("/giveSortedByNearest")
    public ResponseEntity<List<Store>> giveSortedByNearest(
            @RequestParam String currentLocation,
            @RequestParam(required = false, defaultValue = "99999999999999999999") double limit) {

        try {
            List<Store> sortedStores = storeService.getSortedStoresByNearest(currentLocation, limit);
            return new ResponseEntity<>(sortedStores, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping
    public ResponseEntity<Store> createStore(@RequestBody Store store) {
        try {
            Store savedStore = storeService.saveStore(store);
            return new ResponseEntity<>(savedStore, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
