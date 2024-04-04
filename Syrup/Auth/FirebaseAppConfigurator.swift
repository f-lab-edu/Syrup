//import Foundation
//import FirebaseCore
//import GoogleSignIn
//
//final class FirebaseConfigurator {
//    static func configure() {
//        FirebaseApp.configure()
//    }
//    
//    static var clientID: String? {
//        return FirebaseApp.app()?.options.clientID
//    }
//}
//
//final class GoogleSignInConfigurator {
//    static func configure(with clientID: String) {
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//    }
//}
