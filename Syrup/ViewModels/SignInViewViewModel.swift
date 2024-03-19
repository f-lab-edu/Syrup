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
                    print("Google Sign In Error: \(error.localizedDescription)")
                }
            }
    
        case .apple:
            print("apple sign in")
            let appleAuthService = AuthServiceFactory.createAuthService(for: .apple)
            Task {
                do {
                    try await appleAuthService.signIn()
                } catch let error {
                    print("Apple Sign In Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
