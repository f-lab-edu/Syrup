import Foundation
import AuthenticationServices
import CryptoKit

struct SignInWithAppleResult {
    let token: String
    let nonce: String
    let name: String?
    let email: String?
}

final class AppleAuthService: NSObject, AuthServiceProtocol {
    fileprivate var currentNonce: String?
    private var completionHandler: ((Result<SignInWithAppleResult, Error>) -> Void)? = nil
    
    func signIn() async throws {
        print("Apple Auth Service Sign In")
        let firebaseAuthRepo = FirebaseAuthRepository()
        let authResult = try await self.signInWithApple()
        
        guard let credential = firebaseAuthRepo.getCredentialsForApple(idToken: authResult.token, nonce: authResult.nonce) else {
            print("No Credential from Apple tokens")
            return
        }
        try await firebaseAuthRepo.signIntoFirebase(credential: credential)
    }
    
    private func signInWithApple() async throws -> SignInWithAppleResult {
        try await withCheckedThrowingContinuation { continuation in
            self.presentAppleAuthorizationController { result in
                switch result {
                case .success(let signInAppleResult):
                    continuation.resume(returning: signInAppleResult)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
    
    private func presentAppleAuthorizationController(completion: @escaping (Result<SignInWithAppleResult, Error>) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        guard (Utilities.topViewController()?.view.window) != nil else {
            fatalError("topVC not found for AppleAuthService")
        }
        
        return Utilities.topViewController()!.view.window!
    }
}

extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            print("Apple Token : ", appleIDCredential, idTokenString)
            
            let name = appleIDCredential.fullName?.givenName
            let email = appleIDCredential.email
            let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce, name: name, email: email)
            completionHandler?(.success(tokens))
            
        }
        print("didCompleteWithAuthorization called")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
        completionHandler?(.failure(error))
    }
}





