package ma.projet.com.reservationservice.controllers;

import ma.projet.com.reservationservice.entities.Reservation;
import ma.projet.com.reservationservice.services.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;
@RestController
@RequestMapping("/reservations")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    // Classe pour recevoir les données JSON de la requête
    public static class ReservationRequest {
        public Long patientId;
        public Long ambulanceId;
    }

    // Endpoint pour créer une réservation
    @PostMapping("/create")
    public ResponseEntity<Reservation> createReservation(@RequestBody ReservationRequest request) {
        Reservation reservation = reservationService.createReservation(request.patientId, request.ambulanceId);
        return ResponseEntity.ok(reservation);
    }

    // Endpoint pour récupérer une réservation par ID
    @GetMapping("/{id}")
    public ResponseEntity<Reservation> getReservationById(@PathVariable Long id) {
        Optional<Reservation> reservation = reservationService.getReservationById(id);
        return reservation.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

}
