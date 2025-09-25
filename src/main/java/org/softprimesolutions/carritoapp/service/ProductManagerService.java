package org.softprimesolutions.carritoapp.service;

import org.softprimesolutions.carritoapp.dto.request.CreateProductRequest;
import org.softprimesolutions.carritoapp.dto.response.ProductResponse;
import org.softprimesolutions.carritoapp.model.Product;

import java.util.List;

public interface ProductManagerService {
    ProductResponse createProduct(CreateProductRequest request);
    ProductResponse updateProduct(Integer id, CreateProductRequest request);
    void deleteProduct(Integer id);
    ProductResponse findProductById(Integer id);
    List<ProductResponse> findAllProducts();

    // Métodos legacy mantenidos para compatibilidad
    Product create(Product product);
    Product update(Integer id, Product product);
    void delete(Integer id);
    Product findById(Integer id);
}