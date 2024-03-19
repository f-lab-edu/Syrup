import Foundation

final class AppleAuthService: AuthServiceProtocol {
    func signIn() async throws {
        print("Apple Auth sign in")
    }
}
