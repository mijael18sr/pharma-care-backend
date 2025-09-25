package org.softprimesolutions.carritoapp.controller;

import lombok.RequiredArgsConstructor;
import org.softprimesolutions.carritoapp.dto.response.ApiResponse;
import org.softprimesolutions.carritoapp.dto.response.ProductResponse;
import org.softprimesolutions.carritoapp.service.ProductService;
import org.softprimesolutions.carritoapp.mapper.ProductMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;
    private final ProductMapper productMapper;

    /**
     * Obtener todos los productos (acceso público)
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<ProductResponse>>> getAllProducts() {
        List<ProductResponse> products = productService.findAll().stream()
                .map(productMapper::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.success(products, "Productos obtenidos exitosamente"));
    }

    /**
     * Obtener un producto por ID (acceso público)
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductResponse>> getProductById(@PathVariable Integer id) {
        var product = productService.findById(id);
        if (product == null) {
            return ResponseEntity.status(404)
                    .body(ApiResponse.error("Producto no encontrado"));
        }
        ProductResponse productResponse = productMapper.toResponse(product);
        return ResponseEntity.ok(ApiResponse.success(productResponse, "Producto encontrado"));
    }
}
