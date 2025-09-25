package org.softprimesolutions.carritoapp.exception;

public class ProductNotFoundException extends RuntimeException {
    public ProductNotFoundException(Integer id) {
        super("Producto no encontrado con ID: " + id);
    }
}
