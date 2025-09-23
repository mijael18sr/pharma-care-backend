package org.softprimesolutions.carritoapp.repository;

import org.softprimesolutions.carritoapp.model.ShoppingCart;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ShoppingCartRepository extends JpaRepository<ShoppingCart, Integer> {
    Optional<ShoppingCart> findByUserIdAndStatus(Long userId, String status);
}
