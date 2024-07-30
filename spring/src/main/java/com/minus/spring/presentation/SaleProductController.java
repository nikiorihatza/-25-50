package com.minus.spring.presentation;

import com.minus.spring.domain.SaleProduct;
import com.minus.spring.persistence.SaleProductRepository;
import com.minus.spring.persistence.StoreRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/saleproducts")
public record SaleProductController(SaleProductRepository saleProductRepository, StoreRepository storeRepository) {

    @GetMapping("/getAll")
    public ResponseEntity<List<SaleProduct>> getAll() {
        return ResponseEntity.ok(saleProductRepository.findAll());
    }

    @GetMapping("/getAllByStoreID")
    public ResponseEntity<List<SaleProduct>> getAllByStoreID(@RequestParam Long id) {
        return ResponseEntity.ok(saleProductRepository.findAllByStore(storeRepository.findById(id).orElseThrow()));
    }

    @GetMapping("/getByEan")
    public ResponseEntity<SaleProduct> getByEAN(@RequestParam String ean) {
        return ResponseEntity.ok(saleProductRepository.findByEan(ean));
    }
}
