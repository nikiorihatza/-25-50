package com.minus.spring.persistence;

import com.minus.spring.domain.SaleProduct;
import java.util.*;

import com.minus.spring.domain.Store;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SaleProductRepository extends JpaRepository<SaleProduct, Long> {
    List<SaleProduct> findAllByStore(Store store);

    SaleProduct findByEan(@NotNull String ean);
}
