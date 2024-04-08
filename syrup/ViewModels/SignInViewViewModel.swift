import Foundation
import Combine



final class SignInViewViewModel {
    private var authServiceProtocol: AuthServiceProtocol?
    private(set) var userModel: UserModel?
    private let userModelSubject = PassthroughSubject<UserModel?, Never>()
    var userModelPublisher: AnyPublisher<UserModel?, Never> {
        userModelSubject.eraseToAnyPublisher()
    }
    
    private func handleSignInSuccess() async {
        let firebaseAuthRepo = FirebaseAuthRepository()
        
        guard let currentUser = firebaseAuthRepo.getUserStatus() else {
            return
        }
        
        let userModel = UserModel(uid: currentUser.uid,
                                  userDisplayName: currentUser.displayName ?? "",
                                  userEmail: currentUser.email ?? "")
        userModelSubject.send(userModel)
        
        let userDataExists = await FirestoreRepository.shared.checkUserDataExists(userUID: userModel.uid)
        
        if !userDataExists {
            FirestoreRepository.shared.saveUserData(userResult: userModel)
        }

    }
    
    
    func signIn(with authServiceType: AuthServiceType) {
        authServiceProtocol = AuthServiceFactory.createAuthService(for: authServiceType)

        guard let authServiceProtocol = authServiceProtocol else {
            print("authServiceProtocol Error")
            return
        }
        
        Task {
            do {
                
                try await authServiceProtocol.signIn()
                await handleSignInSuccess()
                
            } catch SyrupLoginError.serverError {
                print("Firebase server error occured.")
            } catch SyrupLoginError.userDisabled {
                print("Firebase user login disabled.")
            } catch {
                print("\(authServiceType) Sign In Error: \(error.localizedDescription)")
            }
        }
    }
}
