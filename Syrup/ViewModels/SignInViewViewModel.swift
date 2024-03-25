import Foundation
import Combine

final class SignInViewViewModel {
    private var authServiceProtocol: AuthServiceProtocol?
    private(set) var userModel: UserModel?    
    private let userModelSubject = PassthroughSubject<UserModel?, Never>()
    var userModelPublisher: AnyPublisher<UserModel?, Never> {
        userModelSubject.eraseToAnyPublisher()
    }

    
    func signIn(with authServiceType: AuthServiceType) {
        authServiceProtocol = AuthServiceFactory.createAuthService(for: authServiceType)
        let firebaseAuthRepo = FirebaseAuthRepository()
        
        guard let authServiceProtocol = authServiceProtocol else {
            print("authServiceProtocol Error")
            return
        }
        
        Task {
            do {
                try await authServiceProtocol.signIn()
                
                if let currentUser = firebaseAuthRepo.getUserStatus()  {
                    userModel = UserModel(uid: currentUser.uid,
                                          userDisplayName: currentUser.displayName ?? "",
                                          userEmail: currentUser.email ?? "")
                    userModelSubject.send(userModel)
                }

                
            } catch {
                print("\(authServiceType) Sign In Error: \(error.localizedDescription)")
            }
        }
    }

}
