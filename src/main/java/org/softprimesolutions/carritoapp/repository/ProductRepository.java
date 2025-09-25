package org.softprimesolutions.carritoapp.repository;

import org.softprimesolutions.carritoapp.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ProductRepository extends JpaRepository<Product, Integer> {

    /**
     * Verifica si existe un producto con el nombre especificado (ignorando mayúsculas/minúsculas)
     */
    boolean existsByNameIgnoreCase(String name);

    /**
     * Verifica si existe un producto con el nombre especificado, excluyendo un ID específico
     * Útil para validaciones en actualizaciones
     */
    @Query("SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END FROM Product p WHERE LOWER(p.name) = LOWER(:name) AND p.id != :id")
    boolean existsByNameIgnoreCaseAndIdNot(@Param("name") String name, @Param("id") Integer id);
}
