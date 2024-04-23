import UIKit

final class SettingsViewController: UIViewController {
    
    private let signOutButton = {
        let button = UIButton()
        button.setTitle("SignOut button", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .white
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(signOutButton)
        
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signOutButton.widthAnchor.constraint(equalToConstant: 150),
            signOutButton.heightAnchor.constraint(equalToConstant: 100),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        signOutButton.addTarget(self, action: #selector(onSignOutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func onSignOutButtonTapped() {
        print("tapped")
    }
}
