import Foundation

final class SignInViewViewModel {
    private var authServiceProtocol: AuthServiceProtocol?
    
    func signIn(with authServiceType: AuthServiceType) {
//        let authService = AuthServiceFactory.createAuthService(for: authServiceType)
        authServiceProtocol = AuthServiceFactory.createAuthService(for: authServiceType)
        
        guard let authServiceProtocol = authServiceProtocol else {
            print("authServiceProtocol Error")
            return
        }
        
        Task {
            do {
                try await authServiceProtocol.signIn()
            } catch {
                print("\(authServiceType) Sign In Error: \(error.localizedDescription)")
            }
        }
    }

}
