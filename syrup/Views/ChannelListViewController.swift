import Foundation
import UIKit

class ChannelListViewController: UIViewController {
    
    private let tempSignOutButton = {
        let button = UIButton()
        button.setTitle("sign out", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChannelListViewCon did load")
        view.backgroundColor = .systemCyan
        configureTempSignOutButton()
    }
    
    private func configureTempSignOutButton() {
        view.addSubview(tempSignOutButton)
        tempSignOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempSignOutButton.heightAnchor.constraint(equalToConstant: 64),
            tempSignOutButton.widthAnchor.constraint(equalToConstant: 200),
            tempSignOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempSignOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tempSignOutButton.addTarget(self, action: #selector(onSignOutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func onSignOutButtonTapped() {
        do {
            let firebaseAuthRepo = FirebaseAuthRepository()
            try firebaseAuthRepo.signOut()
            let signInViewController = SignInViewController()
            navigationController?.setViewControllers([signInViewController], animated: true)
        } catch let error {
            print("sign out error occured \(error.localizedDescription)")
        }
       
    }
}

