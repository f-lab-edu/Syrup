import UIKit

final class SignInViewController: UIViewController {
    private let viewModel = SignInViewViewModel()
    
    private let googleSignInButton = {
        let button = UIButton()
        button.setTitle("Google Login", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()
    
    private let appleSignInButton = {
        let button = UIButton()
        button.setTitle("Apple Login", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        
        return button
    }()
    
    //TODO: View
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        configureUI()
        configureUIApple()
    }
    

    //TODO: View
    private func configureUI() {
        view.addSubview(googleSignInButton)
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        googleSignInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        googleSignInButton.addTarget(self, action: #selector(onGoogleSignInTapped), for: .touchUpInside)
    }
    
    //TODO: View
    private func configureUIApple() {
        view.addSubview(appleSignInButton)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        appleSignInButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        appleSignInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        appleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleSignInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 20).isActive = true
        
        appleSignInButton.addTarget(self, action: #selector(onAppleSignInTapped), for: .touchUpInside)
    }
    
    //TODO: ViewModel
    @objc private func onAppleSignInTapped() {
        print("Apple")
        viewModel.signIn(with: .apple)
    }
    
    //TODO: ViewModel
    @objc private func onGoogleSignInTapped() {
        print("Google")
        viewModel.signIn(with: .google)
    }
}

