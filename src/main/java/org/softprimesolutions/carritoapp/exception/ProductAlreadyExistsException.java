package org.softprimesolutions.carritoapp.exception;

public class ProductAlreadyExistsException extends RuntimeException {

    public ProductAlreadyExistsException(String productName) {
        super("Ya existe un producto con el nombre: " + productName);
    }
}
