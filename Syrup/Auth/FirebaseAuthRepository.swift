import Foundation
import FirebaseAuth



final class FirebaseAuthRepository {
    func signIntoFirebase(credential: AuthCredential) async throws {
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            print("AuthResult", authResult.user)
        } catch let error as NSError {
            handleFirebaseAuthError(error)
        }
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
    
    private func handleFirebaseAuthError(_ error: NSError) {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            print("An error occurred: \(error.localizedDescription)")
            return
        }
        
        switch errorCode {
        case .invalidCredential:
            print("Invalid credential.")
        case .operationNotAllowed:
            print("Operation not allowed.")
        case .userDisabled:
            print("User disabled.")
        default:
            print("Unhandled Firebase Auth Error: \(errorCode.rawValue) - \(error.localizedDescription)")
            break
        }
    }
}


