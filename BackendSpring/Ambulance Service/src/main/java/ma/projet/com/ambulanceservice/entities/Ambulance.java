package ma.projet.com.ambulanceservice.entities;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.util.List;

@Entity
public class Ambulance {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String matricule;
    private String status; // "available", "in mission"

    @OneToMany(mappedBy = "ambulance", cascade = CascadeType.ALL)
    @JsonManagedReference  // mappedBy indique que la relation est gérée côté Driver
    private List<Driver> drivers; // Un conducteur peut avoir plusieurs ambulances

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Driver> getDrivers() {
        return drivers;
    }

    public void setDrivers(List<Driver> drivers) {
        this.drivers = drivers;
    }
}
