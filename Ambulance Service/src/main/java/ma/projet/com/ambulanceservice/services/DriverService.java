package ma.projet.com.ambulanceservice.services;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import ma.projet.com.ambulanceservice.entities.Ambulance;
import ma.projet.com.ambulanceservice.entities.Driver;
import ma.projet.com.ambulanceservice.repositories.AmbulanceRepository;
import ma.projet.com.ambulanceservice.repositories.DriverRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DriverService {

    @Autowired
    private DriverRepository driverRepository;

    @Autowired
    private AmbulanceRepository ambulanceRepository;

    // Méthode pour obtenir tous les conducteurs
    public List<Driver> getAllDrivers() {
        return driverRepository.findAll();
    }

    // Méthode pour obtenir un conducteur par ID
    public Optional<Driver> getDriverById(Long id) {
        return driverRepository.findById(id);
    }

    // Méthode pour ajouter un conducteur
    public Driver addDriver(Driver driver) {
        return driverRepository.save(driver);
    }

    // Méthode pour mettre à jour un conducteur
    public Driver updateDriver(Long id, Driver driverDetails) {
        if (driverRepository.existsById(id)) {
            driverDetails.setId(id);
            return driverRepository.save(driverDetails);
        }
        return null;
    }
    // Méthode pour mettre à jour la localisation d'un conducteur
    public Driver updateDriverLocation(Long id, double latitude, double longitude) {
        Optional<Driver> driverOptional = driverRepository.findById(id);
        if (driverOptional.isPresent()) {
            Driver driver = driverOptional.get();
            driver.setLatitude(latitude);
            driver.setLongitude(longitude);
            return driverRepository.save(driver);
        }
        return null;
    }


    // Méthode pour supprimer un conducteur
    public void deleteDriver(Long id) {
        driverRepository.deleteById(id);
    }

    public String registerDriver(String name, String phoneNumber, String email, String password, Long ambulanceId) throws FirebaseAuthException {
        // Créer un utilisateur Firebase
        UserRecord.CreateRequest createRequest = new UserRecord.CreateRequest()
                .setEmail(email)
                .setPassword(password);

        UserRecord userRecord = FirebaseAuth.getInstance().createUser(createRequest);

        // Vérifier l'existence de l'ambulance
        Optional<Ambulance> ambulanceOptional = ambulanceRepository.findById(ambulanceId);
        if (ambulanceOptional.isEmpty()) {
            throw new IllegalArgumentException("Ambulance not found with ID: " + ambulanceId);
        }

        // Enregistrer les informations supplémentaires dans la base de données
        Driver driver = new Driver();
        driver.setFirebaseId(userRecord.getUid());
        driver.setName(name);
        driver.setPhoneNumber(phoneNumber);
        driver.setEmail(email);
        driver.setPassword(password); // Stockage temporaire, à remplacer par un hachage sécurisé.
        driver.setAmbulance(ambulanceOptional.get()); // Associer l'ambulance sélectionnée

        driverRepository.save(driver);

        return "Driver registered successfully with Firebase ID: " + userRecord.getUid();
    }


    // Connexion d'un driver avec email et password
    public String loginDriver(String email, String password) {
        Optional<Driver> driverOptional = driverRepository.findByEmail(email);

        if (driverOptional.isPresent()) {
            Driver driver = driverOptional.get();
            if (driver.getPassword().equals(password)) {
                return "Login successful for driver with email: " + email;
            } else {
                return "Incorrect password.";
            }
        } else {
            return "Driver not found. Please register first.";
        }
    }
    public List<Driver> getNearbyDrivers(double latitude, double longitude, double radius) {
        return driverRepository.findNearbyDrivers(latitude, longitude, radius);
    }
}
