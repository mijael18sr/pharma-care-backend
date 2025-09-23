package org.softprimesolutions.carritoapp.controller;

import org.softprimesolutions.carritoapp.model.Product;
import org.softprimesolutions.carritoapp.model.ShoppingCart;
import org.softprimesolutions.carritoapp.model.ShoppingCartDetail;
import org.softprimesolutions.carritoapp.model.User;
import org.softprimesolutions.carritoapp.service.ProductService;
import org.softprimesolutions.carritoapp.service.ShoppingCartDetailService;
import org.softprimesolutions.carritoapp.service.ShoppingCartService;
import org.softprimesolutions.carritoapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.Date;

@RestController
@RequestMapping("/api/shopping-cart")
public class ShoppingCartController {

    @Autowired
    private ShoppingCartService shoppingCartService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProductService productService;

    @Autowired
    private ShoppingCartDetailService shoppingCartDetailService;

    @PostMapping("/items")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> addItemToCart(@RequestBody ShoppingCartDetail cartDetail, Principal principal) {
        try {
            User user = userService.findByUsername(principal.getName());
            ShoppingCart cart = shoppingCartService.getCartByUser(user.getId());
            if (cart == null) {
                cart = new ShoppingCart();
                cart.setUser(user);
                cart.setDate(new Date());
                cart.setTotalAmount(BigDecimal.ZERO);
                cart.setStatus("0");
                cart = shoppingCartService.save(cart);
            }

            Product product = productService.findById(cartDetail.getProduct().getId());
            if (product == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Product not found");
            }

            // Check if the product is already in the cart
            ShoppingCartDetail existingDetail = shoppingCartDetailService.findByShoppingCartAndProduct(cart, product);
            if (existingDetail != null) {
                existingDetail.setQuantity(existingDetail.getQuantity() + cartDetail.getQuantity());
                existingDetail.setSubtotal(existingDetail.getPrice().multiply(BigDecimal.valueOf(existingDetail.getQuantity())));
                shoppingCartDetailService.save(existingDetail);
            } else {
                cartDetail.setShoppingCart(cart);
                cartDetail.setPrice(product.getPrice());
                cartDetail.setSubtotal(product.getPrice().multiply(BigDecimal.valueOf(cartDetail.getQuantity())));
                shoppingCartDetailService.save(cartDetail);
            }

            // Update cart total
            cart.setTotalAmount(shoppingCartDetailService.getTotalAmountByShoppingCart(cart.getId()));
            shoppingCartService.save(cart);

            return ResponseEntity.ok(cart);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error adding item to cart: " + e.getMessage());
        }
    }

    @GetMapping("/")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> getCart(Principal principal) {
        try {
            User user = userService.findByUsername(principal.getName());
            ShoppingCart cart = shoppingCartService.getCartByUser(user.getId());
            return ResponseEntity.ok(cart);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving cart: " + e.getMessage());
        }
    }

    @DeleteMapping("/items/{itemId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> removeItemFromCart(@PathVariable Integer itemId, Principal principal) {
        try {
            User user = userService.findByUsername(principal.getName());
            ShoppingCart cart = shoppingCartService.getCartByUser(user.getId());
            if (cart == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Cart not found");
            }

            shoppingCartDetailService.deleteById(itemId);

            // Update cart total
            cart.setTotalAmount(shoppingCartDetailService.getTotalAmountByShoppingCart(cart.getId()));
            shoppingCartService.save(cart);

            return ResponseEntity.ok(cart);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error removing item from cart: " + e.getMessage());
        }
    }

    @PutMapping("/items/{itemId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> updateCartItem(@PathVariable Integer itemId, @RequestParam int quantity, Principal principal) {
        try {
            User user = userService.findByUsername(principal.getName());
            ShoppingCart cart = shoppingCartService.getCartByUser(user.getId());
            if (cart == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Cart not found");
            }

            ShoppingCartDetail cartDetail = shoppingCartDetailService.findById(itemId);
            if (cartDetail == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Cart item not found");
            }

            if (quantity <= 0) {
                shoppingCartDetailService.deleteById(itemId);
            } else {
                cartDetail.setQuantity(quantity);
                cartDetail.setSubtotal(cartDetail.getPrice().multiply(BigDecimal.valueOf(quantity)));
                shoppingCartDetailService.save(cartDetail);
            }

            // Update cart total
            cart.setTotalAmount(shoppingCartDetailService.getTotalAmountByShoppingCart(cart.getId()));
            shoppingCartService.save(cart);

            return ResponseEntity.ok(cart);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating cart item: " + e.getMessage());
        }
    }
}