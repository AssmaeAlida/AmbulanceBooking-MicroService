package ma.projet.com.ambulanceservice.controllers;

import com.google.firebase.auth.FirebaseAuthException;
import ma.projet.com.ambulanceservice.entities.Driver;
import ma.projet.com.ambulanceservice.services.DriverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/drivers")
@CrossOrigin(origins = "http://localhost:3001")
public class DriverController {

    @Autowired
    private DriverService driverService;

    // Endpoint pour obtenir tous les conducteurs
    @GetMapping("/all")
    public List<Driver> getAllDrivers() {
        return driverService.getAllDrivers();
    }

    // Endpoint pour obtenir un conducteur par ID
    @GetMapping("/{id}")
    public ResponseEntity<Driver> getDriverById(@PathVariable Long id) {
        Optional<Driver> driver = driverService.getDriverById(id);
        return driver.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Endpoint pour ajouter un conducteur
    @PostMapping("/add")
    public ResponseEntity<Driver> addDriver(@RequestBody Driver driver) {
        Driver newDriver = driverService.addDriver(driver);
        return new ResponseEntity<>(newDriver, HttpStatus.CREATED);
    }

    // Endpoint pour mettre à jour un conducteur
    @PutMapping("/{id}")
    public ResponseEntity<Driver> updateDriver(@PathVariable Long id, @RequestBody Driver driverDetails) {
        Driver updatedDriver = driverService.updateDriver(id, driverDetails);
        return updatedDriver != null ? ResponseEntity.ok(updatedDriver) : ResponseEntity.notFound().build();
    }

    // Endpoint pour supprimer un conducteur
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDriver(@PathVariable Long id) {
        driverService.deleteDriver(id);
        return ResponseEntity.noContent().build();
    }
    @PutMapping("/{id}/location")
    public ResponseEntity<Driver> updateDriverLocation(
            @PathVariable Long id,
            @RequestParam double latitude,
            @RequestParam double longitude) {
        Driver updatedDriver = driverService.updateDriverLocation(id, latitude, longitude);
        if (updatedDriver != null) {
            return ResponseEntity.ok(updatedDriver);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Endpoint pour enregistrer un nouveau driver
    @PostMapping("/register")
    public ResponseEntity<String> registerDriver(@RequestBody Map<String, String> request) {
        String name = request.get("name");
        String phoneNumber = request.get("phoneNumber");
        String email = request.get("email");
        String password = request.get("password");
        Long ambulanceId = Long.parseLong(request.get("ambulanceId"));

        try {
            String result = driverService.registerDriver(name, phoneNumber, email, password, ambulanceId);
            return ResponseEntity.ok(result);
        } catch (FirebaseAuthException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error: " + e.getMessage());
        }
    }

    // Endpoint pour connecter un driver
    @PostMapping("/login")
    public ResponseEntity<String> loginDriver(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String password = request.get("password");

        String result = driverService.loginDriver(email, password);
        if (result.contains("successful")) {
            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
        }
    }

    @GetMapping("/nearby")
    public ResponseEntity<List<Driver>> getNearbyDrivers(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(defaultValue = "10.0") double radius) {
        List<Driver> nearbyDrivers = driverService.getNearbyDrivers(latitude, longitude, radius);
        return ResponseEntity.ok(nearbyDrivers);
    }
}
