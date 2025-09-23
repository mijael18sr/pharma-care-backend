package org.softprimesolutions.carritoapp.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@Data
@Table(name = "shopping_carts")
@EqualsAndHashCode(callSuper = true)
public class ShoppingCart extends EntityAudit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "date", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date date;

    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount;



    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @OneToOne(mappedBy = "shoppingCart", cascade = CascadeType.ALL)
    private PaymentDetail paymentDetail;

    @OneToMany(mappedBy = "shoppingCart", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ShoppingCartDetail> details;
}
