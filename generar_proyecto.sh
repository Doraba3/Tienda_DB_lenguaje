#!/bin/bash
# ================================================
# Script: generar_proyecto.sh
# Proyecto: TiendaSantiago
# Autor: ChatGPT (Sebastián Mosquera)
# ================================================

echo "🚀 Generando proyecto TiendaSantiago..."

# 1️⃣ Crear estructura de carpetas
mkdir -p src/main/java/com/tienda/santiago/{controller,entity,repository,service}
mkdir -p src/main/resources
mkdir -p postman

# 2️⃣ Crear pom.xml
cat > pom.xml <<'POM'
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.tienda.santiago</groupId>
  <artifactId>TiendaSantiago</artifactId>
  <version>1.0.0</version>
  <properties>
    <java.version>17</java.version>
    <spring-boot.version>3.3.3</spring-boot.version>
  </properties>
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>${spring-boot.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
      <scope>runtime</scope>
    </dependency>
    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <optional>true</optional>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
    </plugins>
  </build>
</project>
POM

# 3️⃣ application.properties
cat > src/main/resources/application.properties <<'APP'
spring.datasource.url=jdbc:h2:mem:tienda_db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.hibernate.ddl-auto=update
spring.h2.console.enabled=true
spring.jpa.show-sql=true
APP

# 4️⃣ Clase principal
cat > src/main/java/com/tienda/santiago/TiendaSantiagoApplication.java <<'MAIN'
package com.tienda.santiago;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TiendaSantiagoApplication {
    public static void main(String[] args) {
        SpringApplication.run(TiendaSantiagoApplication.class, args);
    }
}
MAIN

# 5️⃣ Entidades (ejemplo)
cat > src/main/java/com/tienda/santiago/entity/Cliente.java <<'ENT'
package com.tienda.santiago.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "clientes")
public class Cliente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private String nombre;
    @Column(nullable = false, unique = true)
    private String email;

    @OneToOne(mappedBy = "cliente", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Direccion direccion;

    @OneToMany(mappedBy = "cliente", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Pedido> pedidos = new ArrayList<>();

    public void setDireccion(Direccion d) {
        this.direccion = d;
        if (d != null) d.setCliente(this);
    }
}
ENT

cat > src/main/java/com/tienda/santiago/entity/Direccion.java <<'DIR'
package com.tienda.santiago.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "direcciones")
public class Direccion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String calle;
    private String ciudad;
    private String pais;
    private String zip;

    @OneToOne
    @JoinColumn(name = "cliente_id", unique = true)
    private Cliente cliente;
}
DIR

# 6️⃣ Controlador simple
cat > src/main/java/com/tienda/santiago/controller/TiendaController.java <<'CTRL'
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
CTRL

# 7️⃣ Repository
cat > src/main/java/com/tienda/santiago/repository/ClienteRepository.java <<'REP'
package com.tienda.santiago.repository;

import com.tienda.santiago.entity.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {}
REP

echo "✅ Proyecto TiendaSantiago generado con éxito."
