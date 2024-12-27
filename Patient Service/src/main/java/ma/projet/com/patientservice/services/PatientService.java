package ma.projet.com.patientservice.services;

import ma.projet.com.patientservice.entities.Patient;
import ma.projet.com.patientservice.repositories.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    private RestTemplate restTemplate;


    // Ajouter un nouveau patient
    public Patient createPatient(Patient patient) {
        return patientRepository.save(patient);
    }

    // Récupérer un patient par ID
    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }

    // Mettre à jour la localisation d'un patient
    public Patient updatePatientLocation(Long id, Double latitude, Double longitude) {
        // Recherche du patient dans la base de données
        Patient patient = patientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé avec l'ID: " + id));

        // Mise à jour des coordonnées du patient
        patient.setLatitude(latitude);
        patient.setLongitude(longitude);

        // Sauvegarde et renvoi du patient mis à jour
        return patientRepository.save(patient);
    }


    // Lister tous les patients
    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    // Supprimer un patient par ID
    public void deletePatient(Long id) {
        if (!patientRepository.existsById(id)) {
            throw new RuntimeException("Patient non trouvé pour suppression");
        }
        patientRepository.deleteById(id);
    }




}
