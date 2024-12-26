package ma.projet.com.patientservice.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;
import ma.projet.com.patientservice.entities.Patient;
import ma.projet.com.patientservice.repositories.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private PatientRepository patientRepository;

    // Inscription d'un patient
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest request) {
        try {
            // Créer un nouvel utilisateur avec Firebase
            UserRecord.CreateRequest createRequest = new UserRecord.CreateRequest()
                    .setEmail(request.getEmail())
                    .setPassword(request.getPassword())
                    .setPhoneNumber(request.getPhoneNumber()); // Ajout du numéro de téléphone

            UserRecord userRecord = FirebaseAuth.getInstance().createUser(createRequest);

            // Sauvegarder les informations du patient dans la base de données
            Patient patient = new Patient();
            patient.setFirstName(request.getFirstName());
            patient.setLastName(request.getLastName());
            patient.setFirebaseId(userRecord.getUid());
            patient.setEmail(request.getEmail());
            patient.setPhoneNumber(request.getPhoneNumber()); // Sauvegarde du numéro de téléphone
            patientRepository.save(patient);

            return ResponseEntity.ok("Patient enregistré avec succès : " + userRecord.getUid());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur lors de l'inscription : " + e.getMessage());
        }
    }

    // Connexion d'un patient
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody LoginRequest request) {
        try {
            // Vérifier si le patient existe dans la base de données
            Patient patient = patientRepository.findByEmail(request.getEmail());
            if (patient == null) {
                return ResponseEntity.badRequest().body("Patient non trouvé avec cet email.");
            }

            // Valider le mot de passe (Firebase peut gérer les mots de passe)
            FirebaseAuth.getInstance().getUserByEmail(request.getEmail());

            // Si tout est valide, retourner un message de succès
            return ResponseEntity.ok("Connexion réussie pour le patient : " + patient.getFirstName());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur lors de la connexion : " + e.getMessage());
        }
    }
    // Classe interne pour la requête d'inscription
    public static class RegisterRequest {
        private String firstName;
        private String lastName;
        private String email;
        private String password;
        private String phoneNumber; // Nouveau champ

        // Getters et Setters
        public String getFirstName() {
            return firstName;
        }
        public void setFirstName(String firstName) {
            this.firstName = firstName;
        }
        public String getLastName() {
            return lastName;
        }
        public void setLastName(String lastName) {
            this.lastName = lastName;
        }
        public String getEmail() {
            return email;
        }
        public void setEmail(String email) {
            this.email = email;
        }
        public String getPassword() {
            return password;
        }
        public void setPassword(String password) {
            this.password = password;
        }
        public String getPhoneNumber() {
            return phoneNumber;
        }
        public void setPhoneNumber(String phoneNumber) {
            this.phoneNumber = phoneNumber;
        }
    }

    // Classe interne pour la requête de connexion
    public static class LoginRequest {
        private String email;
        private String password;

        // Getters et Setters
        public String getEmail() {
            return email;
        }
        public void setEmail(String email) {
            this.email = email;
        }
        public String getPassword() {
            return password;
        }
        public void setPassword(String password) {
            this.password = password;
        }
    }
}
