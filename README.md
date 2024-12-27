

# **AmbuBook** - Plateforme de réservation d'ambulances

## **Description**
AmbuBook est une plateforme de gestion et de réservation d'ambulances utilisant une architecture microservices. Le système comporte plusieurs services et interfaces pour permettre une interaction fluide entre patients, conducteurs d'ambulances et administrateurs.

---

## **Table des Matières**
- [Architecture Logicielle](#architecture-logicielle)
- [Services](#services)
- [Frontend](#frontend)
- [Backend](#backend)
- [Instructions pour Démarrer](#instructions-pour-démarrer)
- [Vidéo Démonstrative](#vidéo-démo)
- [Contributions](#contributions)
- [Contributeurs](#contributeurs)

---

## **Architecture Logicielle**
L'application est basée sur une architecture microservices comprenant :
- **API Gateway** : Point d'entrée pour communiquer avec les services backend.
- **Services Backend** :
  - **PatientService** : Gestion des données des patients.
  - **AmbulanceService** : Gestion des conducteurs et des ambulances.
  - **ReservationService** : Gestion des réservations.
- **Frontend** :
  - Application **Mobile** pour les patients et les conducteurs (localisation et gestion des réservations).
  - Application **Web** pour les administrateurs (gestion des ambulances, conducteurs, patients et réservations).

---

## **Services**
### PatientService
- Gère les données des patients.
- Permet de définir la localisation du patient et de passer une réservation.

### AmbulanceService
- Gère les informations sur les conducteurs et les ambulances.
- Traite les localisations des conducteurs pour les demandes de réservation.

### ReservationService
- Permet la gestion des réservations (création, mise à jour et historique).

### API Gateway
- Centralise les communications entre le frontend et les microservices backend.

---

## **Frontend**
### Technologies utilisées :
- **Mobile** : Flutter ou React Native.
  - **Patient** : Définir la localisation et effectuer des réservations.
  - **Driver** : Localisation en temps réel et gestion des demandes.
- **Web (Admin)** : Angular ou React.js.
  - Gestion des conducteurs, ambulances, patients et réservations.

---

## **Backend**
### Technologies utilisées :
- **Spring Boot** pour chaque microservice.
- **Base de données MySQL** pour stocker les informations.
- **Framework de sécurité** : Spring Security ou JWT pour l'authentification.

### Structure du projet backend :
1. **com.example.patientservice**
   - Contient le modèle, le contrôleur et le repository pour les patients.
2. **com.example.ambulanceservice**
   - Contient le modèle, le contrôleur et le repository pour les ambulances et conducteurs.
3. **com.example.reservationservice**
   - Contient le modèle, le contrôleur et le repository pour les réservations.


---

## **Instructions pour Démarrer**
### Prérequis :
- **Node.js** et **Angular CLI** (pour le frontend web).
- **Flutter/React Native** (pour le frontend mobile).
- **Docker** et **Docker Compose**.
- **Java 17** et **Maven** (pour les services backend).

### Étapes :
1. **Cloner le projet** :
   ```bash
   git clone https://github.com/AssmaeAlida/AmbulanceBooking-MicroService.git
   cd <project_directory>
   ```


2. **Démarrer le frontend** :
   - Pour l'interface mobile :
     ```bash
     cd MobileApp
     flutter run
     ```
   - Pour l'interface web :
     ```bash
     cd WebApp
     npm install
     ng serve
     ```

4. **Accéder à l'application** :
   - API Gateway : [http://localhost:8080](http://localhost:8088)
   - Frontend Web : [http://localhost:4200](http://localhost:4200)

---

## **Vidéo Démo**
Lien vers la démonstration vidéo : .

---

## **Contributions**
Nous accueillons vos contributions pour améliorer ce projet. Suivez ces étapes :
1. Forkez le dépôt.
2. Créez une branche pour votre fonctionnalité : `git checkout -b feature/nom-fonctionnalité`.
3. Envoyez vos modifications : `git push origin feature/nom-fonctionnalité`.
4. Créez une Pull Request.

---

## **Contributeurs**
- **[Assmae Alida](#)** (GitHub)
- **[Zineb Hijaoui](#)** (GitHub)
- **[Salema Arraouen](#)** (GitHub)
- **[Halima Benchouk](#)** (GitHub)
- **[Doha Tahir](#)** (GitHub)

