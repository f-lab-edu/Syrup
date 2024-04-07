import Foundation
import GoogleSignIn

enum GoogleSignInError: Error {
    case topViewControllerNotFound
    case idTokenNotFound
    case accessTokenNotFound
    case credentialsNotFound
    case customError(description: String)
    
    var localizedDescription: String {
        switch self {
        case .topViewControllerNotFound:
            return "Unable to find the top view controller."
        case .idTokenNotFound:
            return "ID token is not available."
        case .accessTokenNotFound:
            return "Access token is not available."
        case .credentialsNotFound:
            return "Unable to retrieve credentials."
        case .customError(let description):
            return description
        }
    }
}

final class GoogleAuthService: AuthServiceProtocol {
    func signIn() async throws {
        try await signInWithGoogle()
    }
    
    @MainActor
    private func signInWithGoogle() async throws {
        guard let topVC = Utilities.topViewController() else {
            throw GoogleSignInError.topViewControllerNotFound
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw GoogleSignInError.idTokenNotFound
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let firebaseAuthRepo = FirebaseAuthRepository()
        guard let credentials = firebaseAuthRepo.getCredentialsForGoogle(idToken: idToken, accessToken: accessToken) else {
            throw GoogleSignInError.credentialsNotFound
        }
        try await firebaseAuthRepo.signIntoFirebase(credential: credentials)
    }
}



