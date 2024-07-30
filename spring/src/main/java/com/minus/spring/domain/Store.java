package com.minus.spring.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Entity
@Table(name = "stores")

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Store {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    private String name;

    @NotNull
    private int postal;

    @NotNull
    private String city;

    @NotNull
    private String country;

    @NotNull
    private String address;

    private double latitude;
    private double longitude;

    public String getFullAddress() {
        return address + ", " + postal + " " + city + ", " + country;
    }
}
