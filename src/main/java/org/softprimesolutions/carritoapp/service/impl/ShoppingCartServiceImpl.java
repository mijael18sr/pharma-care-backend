package org.softprimesolutions.carritoapp.service.impl;

import org.softprimesolutions.carritoapp.model.ShoppingCart;
import org.softprimesolutions.carritoapp.repository.ShoppingCartRepository;
import org.softprimesolutions.carritoapp.service.ShoppingCartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ShoppingCartServiceImpl implements ShoppingCartService {

    @Autowired
    private ShoppingCartRepository shoppingCartRepository;

    @Override
    public ShoppingCart save(ShoppingCart shoppingCart) {
        return shoppingCartRepository.save(shoppingCart);
    }

    @Override
    public ShoppingCart getCartByUser(Long userId) {
        return shoppingCartRepository.findByUserIdAndStatus(userId, "0").orElse(null);
    }
}
