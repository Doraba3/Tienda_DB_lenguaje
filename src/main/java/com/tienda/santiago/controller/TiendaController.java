package com.tienda.santiago.controller;

import com.tienda.santiago.entity.*;
import com.tienda.santiago.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class TiendaController {

    private final ClienteRepository clienteRepo;

    @PostMapping("/clientes")
    public ResponseEntity<Cliente> crearCliente(@RequestBody Cliente cliente) {
        return ResponseEntity.ok(clienteRepo.save(cliente));
    }
}
