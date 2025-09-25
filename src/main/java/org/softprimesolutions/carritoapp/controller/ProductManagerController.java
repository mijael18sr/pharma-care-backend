package org.softprimesolutions.carritoapp.controller;

import lombok.RequiredArgsConstructor;
import org.softprimesolutions.carritoapp.dto.request.CreateProductRequest;
import org.softprimesolutions.carritoapp.dto.response.ApiResponse;
import org.softprimesolutions.carritoapp.dto.response.ProductResponse;
import org.softprimesolutions.carritoapp.model.Product;
import org.softprimesolutions.carritoapp.service.ProductManagerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/products-manager")
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('ADMIN')")
@Validated
@RequiredArgsConstructor
public class ProductManagerController {

    private final ProductManagerService productManagerService;

    @PostMapping
    public ResponseEntity<ApiResponse<ProductResponse>> createProduct(@Valid @RequestBody CreateProductRequest request) {
        ProductResponse productResponse = productManagerService.createProduct(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(productResponse, "Producto creado exitosamente"));
    }


    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductResponse>> updateProduct(
            @PathVariable Integer id,
            @Valid @RequestBody CreateProductRequest request) {
        ProductResponse productResponse = productManagerService.updateProduct(id, request);
        return ResponseEntity.ok(ApiResponse.success(productResponse, "Producto actualizado exitosamente"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteProduct(@PathVariable Integer id) {
        productManagerService.deleteProduct(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Producto eliminado exitosamente"));
    }


    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductResponse>> getProductById(@PathVariable Integer id) {
        ProductResponse productResponse = productManagerService.findProductById(id);
        return ResponseEntity.ok(ApiResponse.success(productResponse, "Producto encontrado"));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<ProductResponse>>> getAllProducts() {
        List<ProductResponse> products = productManagerService.findAllProducts();
        return ResponseEntity.ok(ApiResponse.success(products, "Productos obtenidos exitosamente"));
    }

    @PostMapping("/legacy")
    public ResponseEntity<Product> createProductLegacy(@RequestBody Product product) {
        return ResponseEntity.ok(productManagerService.create(product));
    }

    @PutMapping("/legacy/{id}")
    public ResponseEntity<Product> updateProductLegacy(@PathVariable Integer id, @RequestBody Product product) {
        return ResponseEntity.ok(productManagerService.update(id, product));
    }
}