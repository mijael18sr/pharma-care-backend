package org.softprimesolutions.carritoapp.repository;

import org.softprimesolutions.carritoapp.model.Product;
import org.softprimesolutions.carritoapp.model.ShoppingCart;
import org.softprimesolutions.carritoapp.model.ShoppingCartDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.Optional;

public interface ShoppingCartDetailRepository extends JpaRepository<ShoppingCartDetail, Integer> {
    Optional<ShoppingCartDetail> findByShoppingCartAndProduct(ShoppingCart cart, Product product);

    @Query("SELECT SUM(d.subtotal) FROM ShoppingCartDetail d WHERE d.shoppingCart.id = ?1")
    BigDecimal getTotalAmountByShoppingCart(Integer cartId);
}
