package ma.projet.com.ambulanceservice.services;

import ma.projet.com.ambulanceservice.entities.Ambulance;
import ma.projet.com.ambulanceservice.entities.Driver;
import ma.projet.com.ambulanceservice.repositories.AmbulanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class AmbulanceService {

    @Autowired
    private AmbulanceRepository ambulanceRepository;

    // Méthode pour obtenir toutes les ambulances
    public List<Ambulance> getAllAmbulances() {
        return ambulanceRepository.findAll();
    }

    // Méthode pour obtenir une ambulance par ID
    public Optional<Ambulance> getAmbulanceById(Long id) {
        return ambulanceRepository.findById(id);
    }

    // Méthode pour ajouter une ambulance
    //public Ambulance addAmbulance(Ambulance ambulance) {
  //      return ambulanceRepository.save(ambulance);
   // }

    public Ambulance addAmbulance(Ambulance ambulance) {
        return ambulanceRepository.save(ambulance);
    }

    // Méthode pour mettre à jour une ambulance
    public Ambulance updateAmbulance(Long id, Ambulance ambulanceDetails) {
        if (ambulanceRepository.existsById(id)) {
            ambulanceDetails.setId(id);
            return ambulanceRepository.save(ambulanceDetails);
        }
        return null;
    }


    // Méthode pour supprimer une ambulance
    public void deleteAmbulance(Long id) {
        ambulanceRepository.deleteById(id);
    }

    // Méthode pour obtenir la localisation actuelle de l'ambulance à partir de son conducteur actif
    public Optional<double[]> getAmbulanceLocation(Long ambulanceId) {
        Optional<Ambulance> ambulanceOptional = ambulanceRepository.findById(ambulanceId);
        if (ambulanceOptional.isPresent()) {
            Ambulance ambulance = ambulanceOptional.get();
            List<Driver> drivers = ambulance.getDrivers();

            // Filtrer les conducteurs actifs
            Optional<Driver> activeDriver = drivers.stream()
                    .filter(driver -> "available".equalsIgnoreCase(driver.getStatus()))
                    .findFirst();
            if (activeDriver.isPresent()) {
                Driver driver = activeDriver.get();
                return Optional.of(new double[]{driver.getLatitude(), driver.getLongitude()});
            }
        }
        return Optional.empty(); // Si aucun conducteur actif ou ambulance inexistante
    }


    public List<Ambulance> getAvailableAmbulances() {
        return ambulanceRepository.findByStatus("available");
    }

}
