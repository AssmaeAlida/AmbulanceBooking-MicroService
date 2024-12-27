package ma.projet.com.reservationservice.services;

import ma.projet.com.reservationservice.entities.Reservation;
import ma.projet.com.reservationservice.repositories.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private RestTemplate restTemplate;
    // Créer une réservation
    public Reservation createReservation(Long patientId, Long ambulanceId) {
        // Vérifier l'existence du patient
        String patientServiceUrl = "http://localhost:8083/patients/" + patientId;

        try {
            restTemplate.getForObject(patientServiceUrl, Object.class);
        } catch (Exception e) {
            throw new RuntimeException("Erreur : Patient introuvable ou service patient non disponible !");
        }

        // Vérifier l'existence de l'ambulance
        String ambulanceServiceUrl = "http://localhost:8085/ambulances/" + ambulanceId;
        System.out.println("Appel à l'API ambulance : " + ambulanceServiceUrl);

        try {
            restTemplate.getForObject(ambulanceServiceUrl, Object.class);
        } catch (Exception e) {
            throw new RuntimeException("Erreur : Ambulance introuvable ou service ambulance non disponible !");
        }

        // Créer et enregistrer la réservation
        Reservation reservation = new Reservation();
        reservation.setPatientId(patientId);
        reservation.setAmbulanceId(ambulanceId);
        reservation.setReservationTime(LocalDateTime.now());
        reservation.setStatus("pending");

        return reservationRepository.save(reservation);
    }

    // Obtenir une réservation par ID
    public Optional<Reservation> getReservationById(Long id) {
        return reservationRepository.findById(id);
    }

    public List<Reservation> getAllReservations() {
        return reservationRepository.findAll();
    }
    // Mettre à jour le statut d'une réservation

    public Reservation confirmReservation(Long id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation introuvable !"));
        reservation.setStatus("confirmed");
        return reservationRepository.save(reservation);
    }

    public Reservation cancelReservation(Long id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation introuvable !"));
        reservation.setStatus("canceled");
        return reservationRepository.save(reservation);
    }
    public List<Reservation> getPendingReservationsForDriver(Long driverId) {
        return reservationRepository.findPendingByDriverId(driverId);
    }

}
