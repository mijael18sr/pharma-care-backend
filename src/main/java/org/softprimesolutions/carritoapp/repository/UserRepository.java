package org.softprimesolutions.carritoapp.repository;

import org.softprimesolutions.carritoapp.model.User;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    @Cacheable(value = "users", key = "#username")
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    Optional<User> findByIdentityDocument(String identityDocument);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    boolean existsByIdentityDocument(String identityDocument);

    @Query("SELECT u FROM User u LEFT JOIN FETCH u.roles ur LEFT JOIN FETCH ur.rol WHERE u.username = :username")
    @Cacheable(value = "users", key = "'withRoles_' + #username")
    Optional<User> findByUsernameWithRoles(@Param("username") String username);
}
