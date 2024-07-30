package com.minus.spring.presentation;

import com.minus.spring.persistence.SaleProductRepository;
import org.springframework.web.bind.annotation.RestController;

@RestController
public record SaleProductController(SaleProductRepository saleProductRepository) {

}
