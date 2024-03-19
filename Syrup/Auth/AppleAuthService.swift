import Foundation
import AuthenticationServices
import CryptoKit

final class AppleAuthService: NSObject, AuthServiceProtocol {
    fileprivate var currentNonce: String?
    
    func signIn() async throws {
        print("Apple Auth Service Sign In")
        startAppleLogin()
    }
    //Reference, 
    func startAppleLogin() {
        guard let topVC = Utilities.topViewController() else {
            print("TopVC None")
            return
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        //레퍼런스 킵해야할 변수인지 appleIDProvider, authorizationController
        //맞다면 멤버변수로 뺴야함
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
//Viewcon이 필요없음
//UIView요구를 하지 않음
//Top-most viewcon이 필요
//
extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        //TopViewcontroller 값 확인 ViewCon과 다른지
        //guard로 force-unwrapping 하지말기 optional chaining with logs
        return Utilities.topViewController()!.view.window!
    }
}

extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //log 추가 확실히 필요
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
        }
        print("appleIDCredential None")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}




