import Foundation
import GoogleSignIn

final class GoogleAuthService: AuthServiceProtocol {
    func signIn() async throws {
        try await signInWithGoogle()
    }
    
    func signInWithGoogle() async throws {
        guard let topVC = Utilities.topViewController() else {
            print("TopViewController not existing")
            return
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            print("no id token")
            return
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let firebaseAuthRepo = FirebaseAuthRepository()
        guard let credentials = firebaseAuthRepo.getCredentials(idToken: idToken, accessToken: accessToken) else {
            print("No Credentials")
            return
        }
        try await firebaseAuthRepo.signIntoFirebase(credential: credentials)
    }
}


