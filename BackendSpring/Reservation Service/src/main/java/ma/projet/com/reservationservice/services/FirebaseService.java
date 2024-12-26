package ma.projet.com.reservationservice.services;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.IOException;

@Service
public class FirebaseService {
    @PostConstruct
    public void init() throws IOException {
        FileInputStream serviceAccount =
                new FileInputStream("src/main/resources/serviceAccountKey.json");
        FirebaseOptions options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseApp.initializeApp(options);
            System.out.println("Firebase Admin SDK initialisé !");

        }
    }
    // Envoi de notification
    public void sendNotificationToDriver(String messageBody) {
        Message message = Message.builder()
                .putData("title", "Nouvelle réservation d'ambulance")
                .putData("body", messageBody)
                .build();

        try {
            FirebaseMessaging.getInstance().send(message);  // Envoie de la notification
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
