package org.softprimesolutions.carritoapp.service.impl;

import org.softprimesolutions.carritoapp.model.Product;
import org.softprimesolutions.carritoapp.model.ShoppingCart;
import org.softprimesolutions.carritoapp.model.ShoppingCartDetail;
import org.softprimesolutions.carritoapp.repository.ShoppingCartDetailRepository;
import org.softprimesolutions.carritoapp.service.ShoppingCartDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class ShoppingCartDetailServiceImpl implements ShoppingCartDetailService {

    @Autowired
    private ShoppingCartDetailRepository shoppingCartDetailRepository;

    @Override
    public ShoppingCartDetail save(ShoppingCartDetail shoppingCartDetail) {
        return shoppingCartDetailRepository.save(shoppingCartDetail);
    }

    @Override
    public ShoppingCartDetail findByShoppingCartAndProduct(ShoppingCart cart, Product product) {
        return shoppingCartDetailRepository.findByShoppingCartAndProduct(cart, product).orElse(null);
    }

    @Override
    public BigDecimal getTotalAmountByShoppingCart(Integer cartId) {
        return shoppingCartDetailRepository.getTotalAmountByShoppingCart(cartId);
    }

    @Override
    public void deleteById(Integer id) {
        shoppingCartDetailRepository.deleteById(id);
    }

    @Override
    public ShoppingCartDetail findById(Integer id) {
        return shoppingCartDetailRepository.findById(id).orElse(null);
    }
}
