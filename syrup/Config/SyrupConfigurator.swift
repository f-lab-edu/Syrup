import Foundation
import FirebaseCore
import GoogleSignIn

final class SyrupConfigurator {
    static let shared = SyrupConfigurator()
    
    private(set) var firebaseConfigurator: FirebaseConfigurator?
    private(set) var googleSignInConfigurator: GoogleSignInConfigurator?
    
    private init() {}
    
    func configure() {
        firebaseConfigurator = FirebaseConfigurator()
        firebaseConfigurator?.configure()
        
        guard let clientID = firebaseConfigurator?.clientID else {
            print("No clientID found")
            return
        }
        
        googleSignInConfigurator = GoogleSignInConfigurator(clientID: clientID)
        googleSignInConfigurator?.configure()
    }
}

final class FirebaseConfigurator {
    var clientID: String? {
        return FirebaseApp.app()?.options.clientID
    }
    
    func configure() {
        FirebaseApp.configure()
    }
}

final class GoogleSignInConfigurator {
    private let clientID: String
    
    init(clientID: String) {
        self.clientID = clientID
    }
    
    func configure() {
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
}
