package ma.projet.com.patientservice.controllers;

import ma.projet.com.patientservice.entities.Patient;
import ma.projet.com.patientservice.services.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/patients")
@CrossOrigin(origins = "http://localhost:3001")
public class PatientController {

    @Autowired
    private PatientService patientService;

    // Endpoint pour ajouter un patient
    @PostMapping("/create")
    public ResponseEntity<Patient> createPatient(@RequestBody Patient patient) {
        Patient newPatient = patientService.createPatient(patient);
        return ResponseEntity.ok(newPatient);
    }

    // Endpoint pour récupérer un patient par ID
    @GetMapping("/{id}")
    public ResponseEntity<Patient> getPatientById(@PathVariable Long id) {
        return patientService.getPatientById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Endpoint pour mettre à jour la localisation
    @PutMapping("/{id}/location")
    public ResponseEntity<Patient> updatePatientLocation(
            @PathVariable Long id,
            @RequestParam Double latitude,
            @RequestParam Double longitude) {
        // Vérification de l'existence du patient avant de le mettre à jour
        Patient updatedPatient = patientService.updatePatientLocation(id, latitude, longitude);
        return ResponseEntity.ok(updatedPatient);
    }


    // Endpoint pour lister tous les patients
    @GetMapping("/")
    public ResponseEntity<List<Patient>> getAllPatients() {
        List<Patient> patients = patientService.getAllPatients();
        return ResponseEntity.ok(patients);
    }

    // Endpoint pour supprimer un patient
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePatient(@PathVariable Long id) {
        patientService.deletePatient(id);
        return ResponseEntity.noContent().build();
    }
    // Endpoint pour obtenir les conducteurs à proximité


    // Endpoint pour envoyer une demande d'aide

}
