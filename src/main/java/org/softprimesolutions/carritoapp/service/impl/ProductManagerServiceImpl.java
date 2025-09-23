package org.softprimesolutions.carritoapp.service.impl;

import org.softprimesolutions.carritoapp.model.Product;
import org.softprimesolutions.carritoapp.repository.ProductRepository;
import org.softprimesolutions.carritoapp.service.ProductManagerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProductManagerServiceImpl implements ProductManagerService {

    @Autowired
    private ProductRepository productRepository;

    @Override
    public Product create(Product product) {
        return productRepository.save(product);
    }

    @Override
    public Product update(Integer id, Product product) {
        return productRepository.findById(id).map(p -> {
            p.setName(product.getName());
            p.setDescription(product.getDescription());
            p.setPrice(product.getPrice());
            p.setStock(product.getStock());
            p.setImageUrl(product.getImageUrl());
            p.setCategory(product.getCategory());
            return productRepository.save(p);
        }).orElse(null);
    }

    @Override
    public void delete(Integer id) {
        productRepository.deleteById(id);
    }

    @Override
    public Product findById(Integer id) {
        return productRepository.findById(id).orElse(null);
    }
}