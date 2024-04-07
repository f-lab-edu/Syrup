import Foundation
import FirebaseAuth

enum SyrupLoginError: Error {
    case serverError
    case userDisabled
    case unknownError
}



final class FirebaseAuthRepository {
    func signIntoFirebase(credential: AuthCredential) async throws {
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            print("AuthResult", authResult.user)
        } catch let error as NSError {
            let syrupError = mapFirebaseErrorToSyrupError(error)
            throw syrupError
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
    
    private func mapFirebaseErrorToSyrupError(_ error: NSError) -> SyrupLoginError {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            return .unknownError
        }
        
        switch errorCode {
        case .invalidCredential, .operationNotAllowed:
            return .serverError
        case .userDisabled:
            return .userDisabled
        default:
            return .unknownError
        }
    }

}



