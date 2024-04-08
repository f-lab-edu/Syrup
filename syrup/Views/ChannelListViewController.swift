import Foundation
import UIKit

class ChannelListViewController: UIViewController {
    private let viewModel = ChannelListViewViewModel()
    
    private let tempSignOutButton = {
        let button = UIButton()
        button.setTitle("sign out", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()
    
    private let createButton = {
        let button = UIButton()
        button.setTitle("Create Channel", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()
    
    private let deleteButton = {
        let button = UIButton()
        button.setTitle("delete Channel", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()
    
    private let getButton = {
        let button = UIButton()
        button.setTitle("get Channels", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()
    
    private let listenButton = {
        let button = UIButton()
        button.setTitle("listen for Channels", for: .normal)
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
        configureCreateButton()
        configureCRUDButtons()
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
    
    private func configureCreateButton() {
        view.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 64),
            createButton.widthAnchor.constraint(equalToConstant: 200),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.topAnchor.constraint(equalTo: tempSignOutButton.bottomAnchor, constant: 20)
        ])
        
        createButton.addTarget(self, action: #selector(onCreateButtonTapped), for: .touchUpInside)
    }
    
    private func configureCRUDButtons() {
        view.addSubview(deleteButton)
        view.addSubview(getButton)
        view.addSubview(listenButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        getButton.translatesAutoresizingMaskIntoConstraints = false
        listenButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 64),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 20),
            getButton.heightAnchor.constraint(equalToConstant: 64),
            getButton.widthAnchor.constraint(equalToConstant: 200),
            getButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 20),
            listenButton.heightAnchor.constraint(equalToConstant: 64),
            listenButton.widthAnchor.constraint(equalToConstant: 200),
            listenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listenButton.topAnchor.constraint(equalTo: getButton.bottomAnchor, constant: 20)
        ])
        
        deleteButton.addTarget(self, action: #selector(onDeleteButtonTapped), for: .touchUpInside)
        getButton.addTarget(self, action: #selector(onGetButtonTapped), for: .touchUpInside)
        listenButton.addTarget(self, action: #selector(onlistenButtonTapped), for: .touchUpInside)
    }

    
    @objc private func onCreateButtonTapped() {
        print("Create Button Tapped")
        viewModel.createChannel(aiServiceType: .geminiAI)
    }
    
    @objc private func onDeleteButtonTapped() {
        print("Delete Button Tapped")
        viewModel.deleteChannel()
    }
    
    @objc private func onGetButtonTapped() {
        print("Get Button Tapped")
        viewModel.getChannel()
    }
    
    @objc private func onlistenButtonTapped() {
        print("Listen Button Tapped")
        viewModel.listenForChannelChanges()
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

