package ma.projet.com.ambulanceservice.repositories;

import ma.projet.com.ambulanceservice.entities.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DriverRepository extends JpaRepository<Driver , Long> {
    Optional<Driver> findByEmail(String email);
    @Query(value = "SELECT * FROM driver d WHERE " +
            "(6371 * acos(cos(radians(:latitude)) * cos(radians(d.latitude)) * " +
            "cos(radians(d.longitude) - radians(:longitude)) + " +
            "sin(radians(:latitude)) * sin(radians(d.latitude)))) < :radius",
            nativeQuery = true)
    List<Driver> findNearbyDrivers(
            @Param("latitude") double latitude,
            @Param("longitude") double longitude,
            @Param("radius") double radius
    );
}
