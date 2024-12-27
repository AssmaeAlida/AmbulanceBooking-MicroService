package ma.projet.com.reservationservice.repositories;

import ma.projet.com.reservationservice.entities.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    @Query("SELECT r FROM Reservation r WHERE r.ambulanceId = :driverId AND r.status = 'PENDING'")
    List<Reservation> findPendingByDriverId(@Param("driverId") Long driverId);

}
