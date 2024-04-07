import UIKit
import AuthenticationServices
import Combine

final class SignInViewController: UIViewController {
    private let viewModel = SignInViewViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let googleSignInButton = {
        let button = UIButton()
        button.setTitle("Continue with Google", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .black
        let googleLogo = UIImage(named: "googlelogo")?.resize(to: CGSize(width: 15, height: 15))
        button.setImage(googleLogo, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .black)
        button.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUIForGoogleButton()
        configureUIForAppleButton()
        subscribeToUserModelPublisher()
    }
    
    private func configureUIForGoogleButton() {
        view.addSubview(googleSignInButton)
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            googleSignInButton.heightAnchor.constraint(equalToConstant: 64),
            googleSignInButton.widthAnchor.constraint(equalToConstant: 200),
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        googleSignInButton.addTarget(self, action: #selector(onGoogleSignInTapped), for: .touchUpInside)
    }
    
    private func configureUIForAppleButton() {
        view.addSubview(appleSignInButton)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appleSignInButton.heightAnchor.constraint(equalToConstant: 64),
            appleSignInButton.widthAnchor.constraint(equalToConstant: 200),
            appleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleSignInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 20)
        ])
        
        appleSignInButton.addTarget(self, action: #selector(onAppleSignInTapped), for: .touchUpInside)
    }
    
    @objc private func onAppleSignInTapped() {
        viewModel.signIn(with: .apple)
    }
    
    @objc private func onGoogleSignInTapped() {
        viewModel.signIn(with: .google)
    }
    
    private func navigateToChannelListViewController() {
        let channelListViewController = ChannelListViewController()
        //User back button + swipe gesture block
        navigationController?.setViewControllers([channelListViewController], animated: true)
    }
    
    private func subscribeToUserModelPublisher() {
        // Subscribe to the userModelPublisher
        viewModel.userModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userModel in
                if let userModel = userModel {
                    print("User signed in: \(userModel)")
                    self?.navigateToChannelListViewController()
                } else {
                    print("No userModel found")
                }
            }
            .store(in: &cancellables)
    }
}


