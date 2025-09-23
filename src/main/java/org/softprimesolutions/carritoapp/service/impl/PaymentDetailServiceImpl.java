package org.softprimesolutions.carritoapp.service.impl;

import org.softprimesolutions.carritoapp.model.PaymentDetail;
import org.softprimesolutions.carritoapp.repository.PaymentDetailRepository;
import org.softprimesolutions.carritoapp.service.PaymentDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PaymentDetailServiceImpl implements PaymentDetailService {

    @Autowired
    private PaymentDetailRepository paymentDetailRepository;

    @Override
    public PaymentDetail save(PaymentDetail paymentDetail) {
        return paymentDetailRepository.save(paymentDetail);
    }
}
