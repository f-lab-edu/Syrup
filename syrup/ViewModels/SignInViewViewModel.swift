import Foundation
import Combine

enum SignInError: Error {
    case userNotFound
    case serverError(String)
    case unknownError
}


final class SignInViewViewModel {
    private var authServiceProtocol: AuthServiceProtocol?
    private(set) var userModel: UserModel?
    private let userModelSubject = PassthroughSubject<UserModel?, SignInError>()
    var userModelPublisher: AnyPublisher<UserModel?, SignInError> {
        userModelSubject.eraseToAnyPublisher()
    }
    
    private func handleSignInSuccess() async {
        let firebaseAuthRepo = FirebaseAuthRepository()
        
        guard let currentUser = firebaseAuthRepo.getUserStatus() else {
            userModelSubject.send(completion: .failure(SignInError.userNotFound))
            return
        }
        let userModel = UserModel(uid: currentUser.uid,
                                  userDisplayName: currentUser.displayName ?? "",
                                  userEmail: currentUser.email ?? "")
        let userDataExists = await FirestoreRepository.shared.checkUserDataExists(userUID: userModel.uid)
        
        if !userDataExists {
            FirestoreRepository.shared.saveUserData(userResult: userModel)
        }
        
        userModelSubject.send(userModel)
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
