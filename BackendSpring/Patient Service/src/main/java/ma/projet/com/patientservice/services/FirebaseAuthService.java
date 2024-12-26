package ma.projet.com.patientservice.services;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import org.springframework.stereotype.Service;
@Service
public class FirebaseAuthService {

    public FirebaseToken verifyToken(String idToken) throws Exception {
        try {
            return FirebaseAuth.getInstance().verifyIdToken(idToken);
        } catch (FirebaseAuthException e) {
            throw new Exception("Erreur lors de la vérification du token: " + e.getMessage(), e);
        }
    }

    public String getUid(String idToken) throws Exception {
        FirebaseToken decodedToken = verifyToken(idToken);
        return decodedToken.getUid();
    }
}
