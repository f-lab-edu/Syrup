import Foundation

final class SignInViewViewModel {
    func signIn(with authServiceType: AuthServiceType) {
        switch authServiceType {
        
        case .google:
            let googleAuthService = AuthServiceFactory.createAuthService(for: .google)
            Task {
                do {
                    try await googleAuthService.signIn()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
    
        case .apple:
            print("apple sign in")
        }
    }
}
