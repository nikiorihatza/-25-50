package com.minus.spring.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "saleproducts")

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class SaleProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @NotNull
    private String ean;

    @NotNull
    private String qr;

    @NotNull
    private String name;

    @NotNull
    private double prize;

    @NotNull
    private int discount;

    @NotNull
    private double discountprize;

    @ManyToOne
    @JoinColumn(name = "store_id")
    private Store store;
}
