import Foundation
//코드 중복 생성하고 분기
//공통 프로토콜로 처리 필요
final class SignInViewViewModel {
    var authServiceProtocol: AuthServiceProtocol?
    
    func signIn(with authServiceType: AuthServiceType) {
//        let authService = AuthServiceFactory
        //Task 어떤 Thread에서 도는지?
        //Combine을 통한 update, publish, subscribing data binding
        //Data 동기화, race condition 조심
        
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
            //임시로 설정
            authServiceProtocol = AuthServiceFactory.createAuthService(for: .apple)
            
            Task {
                do {
                    //Reference Count
                    try await authServiceProtocol?.signIn()
                } catch let error {
                    print("Apple Sign In Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
