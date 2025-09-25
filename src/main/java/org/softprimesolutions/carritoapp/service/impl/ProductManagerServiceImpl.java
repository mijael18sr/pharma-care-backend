package org.softprimesolutions.carritoapp.service.impl;

import org.softprimesolutions.carritoapp.dto.request.CreateProductRequest;
import org.softprimesolutions.carritoapp.dto.response.ProductResponse;
import org.softprimesolutions.carritoapp.exception.CategoryNotFoundException;
import org.softprimesolutions.carritoapp.exception.ProductAlreadyExistsException;
import org.softprimesolutions.carritoapp.exception.ProductNotFoundException;
import org.softprimesolutions.carritoapp.mapper.ProductMapper;
import org.softprimesolutions.carritoapp.model.Category;
import org.softprimesolutions.carritoapp.model.Product;
import org.softprimesolutions.carritoapp.repository.CategoryRepository;
import org.softprimesolutions.carritoapp.repository.ProductRepository;
import org.softprimesolutions.carritoapp.service.ProductManagerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ProductManagerServiceImpl implements ProductManagerService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private ProductMapper productMapper;

    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null ? authentication.getName() : "system";
    }

    @Override
    public ProductResponse createProduct(CreateProductRequest request) {
        // Validar que la categoría existe
        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new CategoryNotFoundException(request.getCategoryId()));

        // Validar que no existe un producto con el mismo nombre (opcional)
        if (productRepository.existsByNameIgnoreCase(request.getName())) {
            throw new ProductAlreadyExistsException(request.getName());
        }

        // Convertir DTO a entidad
        Product product = productMapper.toEntity(request, category);

        // Establecer campos de auditoría con usuario actual
        product.setCreatedBy(getCurrentUsername());

        // Guardar producto
        Product savedProduct = productRepository.save(product);

        // Convertir a DTO de respuesta
        return productMapper.toResponse(savedProduct);
    }

    @Override
    public ProductResponse updateProduct(Integer id, CreateProductRequest request) {
        // Buscar producto existente
        Product existingProduct = productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(id));

        // Validar que la categoría existe
        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new CategoryNotFoundException(request.getCategoryId()));

        // Validar que no existe otro producto con el mismo nombre (opcional)
        if (productRepository.existsByNameIgnoreCaseAndIdNot(request.getName(), id)) {
            throw new ProductAlreadyExistsException(request.getName());
        }

        // Actualizar campos
        existingProduct.setName(request.getName());
        existingProduct.setDescription(request.getDescription());
        existingProduct.setPrice(request.getPrice());
        existingProduct.setStock(request.getStock());
        existingProduct.setImageUrl(request.getImageUrl());
        existingProduct.setCategory(category);
        existingProduct.setUpdatedBy(getCurrentUsername());

        // Guardar cambios
        Product updatedProduct = productRepository.save(existingProduct);

        // Convertir a DTO de respuesta
        return productMapper.toResponse(updatedProduct);
    }

    @Override
    public void deleteProduct(Integer id) {
        if (!productRepository.existsById(id)) {
            throw new ProductNotFoundException(id);
        }
        productRepository.deleteById(id);
    }

    @Override
    public ProductResponse findProductById(Integer id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(id));
        return productMapper.toResponse(product);
    }

    @Override
    public List<ProductResponse> findAllProducts() {
        return productRepository.findAll().stream()
                .map(productMapper::toResponse)
                .collect(Collectors.toList());
    }

    // Métodos legacy mantenidos para compatibilidad
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