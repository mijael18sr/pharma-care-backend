package org.softprimesolutions.carritoapp.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name = "shopping_cart_details")
public class ShoppingCartDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private int quantity;
    private double price;

    @ManyToOne
    private ShoppingCart shoppingCart;

    @ManyToOne
    private Product product;
}
