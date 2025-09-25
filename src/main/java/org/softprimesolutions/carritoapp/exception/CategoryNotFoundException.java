package org.softprimesolutions.carritoapp.exception;

public class CategoryNotFoundException extends RuntimeException {
    public CategoryNotFoundException(Integer id) {
        super("Categoría no encontrada con ID: " + id);
    }
}
