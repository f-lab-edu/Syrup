import Foundation
import UIKit

class ChannelListViewController: UIViewController, ChannelErrorDelegate {
    
    private let viewModel = ChannelListViewViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(CustomChannelCell.self, forCellReuseIdentifier: CustomChannelCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        print("View Will Appear")
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChannelListViewCon did load")
        view.backgroundColor = .systemCyan
        setupNavigationBar()
        setupTableView()
        viewModel.delegate = self
        viewModel.errorDelegate = self
 
    }
    
    private func setupNavigationBar() {
        title = "Channels"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createChannelButtonTapped)),
        ]
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        configureTableViewUI()
    }
    
    func didEncounterError(_ error: Error) {
        showAlert(withMessage: error.localizedDescription)
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        DispatchQueue.main.async { [weak self] _ in
//            present(alert, animated: true)
//        }

    }
    
    
    @objc func createChannelButtonTapped() {
        print("Button 1 tapped!")
        Task {
            await viewModel.createChannel(aiServiceType: .geminiAI)
        }
    }
    
    private func configureTableViewUI() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    @objc private func onCreateButtonTapped() {
        print("Create Button Tapped")
        Task {
            await viewModel.createChannel(aiServiceType: .geminiAI)
        }
    }
    
    private func deleteChannel(at index: Int) {
        print("Delete Button Tapped")
        Task {
            await viewModel.deleteChannel(at: index)
        }
    }
}


extension ChannelListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomChannelCell.identifier, for: indexPath) as? CustomChannelCell else {
            fatalError("TableView Custom Cell Deque Error")
        }
        cell.selectionStyle = .none
        let image = UIImage(systemName: "questionmark")
        //Last Chat Message and Image 넣는 곳
        cell.configure(with: image!, and: "hi")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt", indexPath.row.description)
        print(viewModel.channelList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
        
        let channel = viewModel.channelList[indexPath.row]
        let detailVC = ChannelViewController(channel: channel)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        Task {
            await viewModel.deleteChannel(at: indexPath.row)
        }
    }
}

extension ChannelListViewController: ChannelListViewViewModelDelegate {
    func didUpdateData(_ channel: ChannelListViewViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
