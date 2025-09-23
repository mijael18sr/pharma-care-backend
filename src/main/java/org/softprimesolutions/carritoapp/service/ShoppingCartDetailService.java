package org.softprimesolutions.carritoapp.service;

import org.softprimesolutions.carritoapp.model.Product;
import org.softprimesolutions.carritoapp.model.ShoppingCart;
import org.softprimesolutions.carritoapp.model.ShoppingCartDetail;

import java.math.BigDecimal;

public interface ShoppingCartDetailService {
    ShoppingCartDetail save(ShoppingCartDetail shoppingCartDetail);
    ShoppingCartDetail findByShoppingCartAndProduct(ShoppingCart cart, Product product);
    BigDecimal getTotalAmountByShoppingCart(Integer cartId);
    void deleteById(Integer id);
    ShoppingCartDetail findById(Integer id);
}
