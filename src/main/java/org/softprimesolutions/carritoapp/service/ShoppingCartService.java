package org.softprimesolutions.carritoapp.service;

import org.softprimesolutions.carritoapp.model.ShoppingCart;

public interface ShoppingCartService {
    ShoppingCart save(ShoppingCart shoppingCart);
    ShoppingCart getCartByUser(Long userId);
}
