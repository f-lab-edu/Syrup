import Foundation
import FirebaseAuth

final class FirebaseAuthRepository {
    func signIntoFirebase(credential: AuthCredential) async throws {
        
        let authResult = try await Auth.auth().signIn(with: credential)
        print("AuthResult", authResult.user)

        guard let currentUser = Auth.auth().currentUser else { return }
        let user = UserModel(uid: currentUser.uid,
                             userDisplayName: currentUser.displayName ?? "",
                             userEmail: currentUser.email ?? "")
        print(user)
    }
    
    func getCredentialsForGoogle(idToken: String, accessToken: String) -> AuthCredential? {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        return credential
    }
    
    func getCredentialsForApple(idToken: String, nonce: String, fullName: PersonNameComponents) -> OAuthCredential? {
        let credentials = OAuthProvider.appleCredential(withIDToken: idToken, rawNonce: nonce, fullName: fullName)
        return credentials
    }
    
    
    func getUserStatus() -> User? {
        return Auth.auth().currentUser
    }
}


