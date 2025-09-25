package org.softprimesolutions.carritoapp.controller;

import lombok.RequiredArgsConstructor;
import org.softprimesolutions.carritoapp.dto.response.ApiResponse;
import org.softprimesolutions.carritoapp.model.Category;
import org.softprimesolutions.carritoapp.service.CategoryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    /**
     * Obtener todas las categorías (acceso público)
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<Category>>> getAllCategories() {
        List<Category> categories = categoryService.findAll();
        return ResponseEntity.ok(ApiResponse.success(categories, "Categorías obtenidas exitosamente"));
    }
}