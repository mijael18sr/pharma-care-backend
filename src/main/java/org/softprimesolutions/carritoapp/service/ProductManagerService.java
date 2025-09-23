package org.softprimesolutions.carritoapp.service;

import org.softprimesolutions.carritoapp.model.Product;

public interface ProductManagerService {
    Product create(Product product);
    Product update(Integer id, Product product);
    void delete(Integer id);
    Product findById(Integer id);
}