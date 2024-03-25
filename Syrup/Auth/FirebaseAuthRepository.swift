import Foundation
import FirebaseAuth

final class FirebaseAuthRepository {
    func signIntoFirebase(credential: AuthCredential) async throws {
        let authResult = try await Auth.auth().signIn(with: credential)
        print("AuthResult", authResult.user)
    }
    
    func getCredentialsForGoogle(idToken: String, accessToken: String) -> AuthCredential? {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        return credential
    }
    
    func getCredentialsForApple(idToken: String, nonce: String) -> OAuthCredential? {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        return credential
    }
    
    
    func getUserStatus() -> User? {
        return Auth.auth().currentUser
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("sign out failed \(error.localizedDescription)")
        }
    }
}


