package org.softprimesolutions.carritoapp.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.softprimesolutions.carritoapp.dto.request.LoginRequest;
import org.softprimesolutions.carritoapp.dto.response.LoginResponse;
import org.softprimesolutions.carritoapp.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "message", "Auth service is running"
        ));
    }

    @GetMapping("/test-users")
    public ResponseEntity<Map<String, Object>> testUsers() {
        // Este es un endpoint temporal solo para debugging
        return ResponseEntity.ok(Map.of(
            "message", "Test endpoint for debugging",
            "suggestion", "Check if users exist in database"
        ));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            LoginResponse response = authService.login(loginRequest);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", "Login failed: " + e.getMessage()));
        }
    }
}
