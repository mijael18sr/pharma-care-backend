package org.softprimesolutions.carritoapp.controller;

import org.softprimesolutions.carritoapp.model.PaymentDetail;
import org.softprimesolutions.carritoapp.model.ShoppingCart;
import org.softprimesolutions.carritoapp.model.User;
import org.softprimesolutions.carritoapp.service.PaymentDetailService;
import org.softprimesolutions.carritoapp.service.ShoppingCartService;
import org.softprimesolutions.carritoapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/api/checkout")
public class CheckoutController {

    @Autowired
    private UserService userService;

    @Autowired
    private ShoppingCartService shoppingCartService;

    @Autowired
    private PaymentDetailService paymentDetailService;

    @PostMapping("/")
    public ResponseEntity<?> processCheckout(@RequestBody PaymentDetail paymentDetail, Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
        }

        try {
            User user = userService.findByUsername(principal.getName());
            ShoppingCart cart = shoppingCartService.getCartByUser(user.getId());

            if (cart == null || cart.getDetails().isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Shopping cart is empty");
            }

            paymentDetail.setShoppingCart(cart);
            paymentDetail.setPaymentMethod("CREDIT_CARD");
            paymentDetail.setPaymentStatus("COMPLETED");
            paymentDetailService.save(paymentDetail);

            // Mark the cart as completed
            cart.setStatus("1"); // Assuming 1 for 'COMPLETED'
            shoppingCartService.save(cart);

            return ResponseEntity.ok().body("Checkout successful");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error during checkout: " + e.getMessage());
        }
    }
}