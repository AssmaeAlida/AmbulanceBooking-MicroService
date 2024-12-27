package ma.projet.com.ambulanceservice.controllers;

import ma.projet.com.ambulanceservice.entities.Ambulance;
import ma.projet.com.ambulanceservice.services.AmbulanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/ambulances")
@CrossOrigin(origins = "http://localhost:3001")
public class AmbulanceController {

    @Autowired
    private AmbulanceService ambulanceService;

    // Endpoint pour obtenir toutes les ambulances
    @GetMapping("/all")
    public List<Ambulance> getAllAmbulances() {
        return ambulanceService.getAllAmbulances();
    }

    // Endpoint pour obtenir une ambulance par ID
    @GetMapping("/{id}")
    public ResponseEntity<Ambulance> getAmbulanceById(@PathVariable Long id) {
        Optional<Ambulance> ambulance = ambulanceService.getAmbulanceById(id);
        return ambulance.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Endpoint pour ajouter une ambulance
//    @PostMapping("/add")
//    public ResponseEntity<Ambulance> addAmbulance(@RequestBody Ambulance ambulance) {
//        Ambulance newAmbulance = ambulanceService.addAmbulance(ambulance);
//        return new ResponseEntity<>(newAmbulance, HttpStatus.CREATED);
//    }

    @PostMapping(value = "/add", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Ambulance> addAmbulance(@RequestBody Ambulance ambulance) {
        Ambulance newAmbulance = ambulanceService.addAmbulance(ambulance);
        return new ResponseEntity<>(newAmbulance, HttpStatus.CREATED);
    }



    // Endpoint pour mettre à jour une ambulance
    @PutMapping("/{id}")
    public ResponseEntity<Ambulance> updateAmbulance(@PathVariable Long id, @RequestBody Ambulance ambulanceDetails) {
        Ambulance updatedAmbulance = ambulanceService.updateAmbulance(id, ambulanceDetails);
        return updatedAmbulance != null ? ResponseEntity.ok(updatedAmbulance) : ResponseEntity.notFound().build();
    }

    // Endpoint pour supprimer une ambulance
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAmbulance(@PathVariable Long id) {
        ambulanceService.deleteAmbulance(id);
        return ResponseEntity.noContent().build();
    }
    // Méthode pour obtenir la localisation d'une ambulance
    @GetMapping("/{id}/location")
    public ResponseEntity<double[]> getAmbulanceLocation(@PathVariable Long id) {
        return ambulanceService.getAmbulanceLocation(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }



}
