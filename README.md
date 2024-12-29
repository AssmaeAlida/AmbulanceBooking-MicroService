

# **AmbuBook** - Plateforme de réservation d'ambulances

## **Description**
AmbuBook est une plateforme innovante de gestion et de réservation d'ambulances, conçue avec une architecture microservices. Le système comprend plusieurs services backend et interfaces frontend pour permettre une interaction fluide entre les patients, les conducteurs d'ambulances et les administrateurs. **Firebase** est utilisé uniquement pour l'authentification des utilisateurs.

---

## **Table des Matières**
- [Architecture Logicielle](#architecture-logicielle)
- [Services](#services)
- [Frontend](#frontend)
- [Backend](#backend)
- [Firebase Authentication](#firebase-authentication)
- [Instructions pour Démarrer](#instructions-pour-démarrer)
- [Vidéo Démonstrative](#vidéo-démo)
- [Contributions](#contributions)
- [Contributeurs](#contributeurs)

---

## **Architecture Logicielle**
L'application repose sur une architecture microservices composée des éléments suivants :
- **API Gateway** : Interface principale pour centraliser les communications entre les services.
- **Services Backend** :
  - **PatientService** : Gestion des données des patients.
  - **AmbulanceService** : Gestion des conducteurs et des ambulances.
  - **ReservationService** : Gestion des réservations.
- **Frontend** :
  - **Application Mobile** pour les patients (réservation et localisation) et les conducteurs (gestion des trajets et localisation en temps réel).
  - **Application Web** pour les administrateurs (gestion des conducteurs, ambulances, patients et réservations).
- **Firebase Authentication** : Utilisé pour l'authentification des utilisateurs (patients, conducteurs, administrateurs).

  ![White Colorful Modern Diagram Graph (1)](https://github.com/user-attachments/assets/55d63a62-20da-4739-a8a9-44b48926c4df)

---

## **Services**
### **PatientService**
- Gère les données des patients.
- Permet aux patients de définir leur localisation et d'effectuer des réservations.

### **AmbulanceService**
- Gère les informations des conducteurs et des ambulances.
- Traite les localisations des conducteurs pour répondre efficacement aux demandes des patients.

### **ReservationService**
- Permet la gestion des réservations, y compris la création, la mise à jour et le suivi.

### **API Gateway**
- Centralise toutes les communications entre le frontend et les microservices backend.

---

## **Frontend**
### **Technologies utilisées** :
1. **Application Mobile** : Développée avec **Flutter**.
   - **Module Patient** : Définir la localisation et effectuer une réservation.
   - **Module Conducteur** : Mise à jour de la localisation en temps réel et gestion des réservations assignées.
2. **Application Web** : Développée avec **React.js**.
   - Permet aux administrateurs de gérer les conducteurs, les ambulances, les patients et les réservations.

---

## **Backend**
### **Technologies utilisées** :
- **Spring Boot** pour développer les microservices.
- **Base de données MySQL** pour stocker les informations des patients, conducteurs, ambulances et réservations.
- **Sécurité** : Utilisation de JWT ou Spring Security pour gérer l'authentification et l'autorisation.

---

## **Firebase Authentication**
### **Fonctionnalités intégrées avec Firebase** :
1. **Authentification des utilisateurs** :
   - Firebase Authentication est utilisé pour gérer l'enregistrement, la connexion et la gestion des sessions des utilisateurs, y compris les patients, conducteurs et administrateurs.
   - Firebase permet d'implémenter des méthodes d'authentification par e-mail/mot de passe ou via des comptes externes tels que Google.

2. **Gestion des utilisateurs** :
   - Les utilisateurs (patients, conducteurs, administrateurs) peuvent se connecter via Firebase, ce qui simplifie la gestion des utilisateurs et garantit une sécurité fiable pour l'accès à l'application.

---

## **Instructions pour Démarrer**
### **Prérequis** :
- **Node.js** (v14 ou plus) et **npm** pour les dépendances frontend.
- **Flutter** pour les applications mobiles.
- **Java 17** et **Maven** pour le backend.
- **MySQL** pour la base de données.
- **Compte Firebase** pour activer l'authentification.

### **Étapes** :
1. **Cloner le projet** :
   ```bash
   git clone https://github.com/AssmaeAlida/AmbulanceBooking-MicroService.git
   cd AmbulanceBooking-MicroService
   ```

2. **Configurer Firebase Authentication** :
   - Créez un projet sur [Firebase Console](https://firebase.google.com/).
   - Activez **Firebase Authentication** et configurez les méthodes d'authentification (e-mail/mot de passe ).
   - Téléchargez le fichier `google-services.json` (pour Android) ou `GoogleService-Info.plist` (pour iOS) et placez-le dans le répertoire approprié de l'application mobile.

3. **Configurer la Base de Données** :
   - Assurez-vous que MySQL est installé et en cours d'exécution.
   - Configurez les informations de connexion MySQL dans les fichiers `application.properties` de chaque microservice backend.

4. **Lancer les Microservices Backend** :
   - Accédez à chaque dossier de microservice (e.g., `PatientService`) et exécutez :
     ```bash
     mvn spring-boot:run
     ```

5. **Lancer le Frontend** :
   - **Application Web** :
     ```bash
     cd WebApp
     npm install
     npm start
     ```
   - **Application Mobile** :
     ```bash
     cd MobileApp
     flutter run
     ```

6. **Accéder à l'Application** :
   - Frontend Web : [http://localhost:4200](http://localhost:4200).
   - API Gateway : [http://localhost:8080](http://localhost:8088).

---
## **Construire l'image Docker**
   - Utilisez la commande suivante pour construire l'image Docker :
     ```bash
     docker build -t mon-app-web .
     ```
## **Exécuter le conteneur**
   - Pour exécuter l'application dans un conteneur Docker, utilisez :
     ```bash
     docker run -p 8080:80 mon-app-web
     ```
     L'application sera accessible à l'adresse : http://localhost:8080
## **Vérifier le déploiement**
   - Ouvrez un navigateur web et accédez à http://localhost:8080 pour vérifier que votre application s'exécute correctement.


## **Vidéo Démo**
Une démonstration vidéo est disponible ici : 


  https://github.com/user-attachments/assets/a902d6c0-65bf-49fd-a15d-2c76fdce0903

   Une démonstration de l'Admin:
   
   https://github.com/user-attachments/assets/570444d6-b3fc-41e2-abfc-c9166b43c09d

---

## **Contributions**
Nous encourageons les contributions pour améliorer ce projet. Suivez les étapes ci-dessous :
1. Forkez le dépôt.
2. Créez une nouvelle branche :
   ```bash
   git checkout -b feature/nom-de-la-fonctionnalité
   ```
3. Effectuez vos modifications et envoyez-les :
   ```bash
   git commit -m "Ajout d'une nouvelle fonctionnalité"
   git push origin feature/nom-de-la-fonctionnalité
   ```
4. Créez une Pull Request sur le dépôt principal.

---

## **Contributeurs**
- **[Assmae Alida](https://github.com/AssmaeAlida)**
- **[Zineb Hijaoui](https://github.com/ZinebHijaoui)**
- **[Salema Arraouen](https://github.com/SalemaArraouen)**
- **[Halima Benchouk](https://github.com/HalimaBenchouk)**
- **[Doha Tahir](https://github.com/DohaTahir)**
