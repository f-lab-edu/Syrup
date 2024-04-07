import Foundation

protocol AuthServiceProtocol {
    func signIn() async throws
}

enum AuthServiceType {
    case google
    case apple
}

final class AuthServiceFactory {
    static func createAuthService(for type: AuthServiceType) -> AuthServiceProtocol {
        switch type {
        case .google:
            return GoogleAuthService()
        case .apple:
            return AppleAuthService()
        }
    }
}

