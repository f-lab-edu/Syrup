import Foundation
import UIKit

class ChannelListViewController: UIViewController, DataDelegate, ChannelErrorDelegate {
    
    private let viewModel = ChannelListViewViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGreen
        tableView.allowsSelection = true
        tableView.register(CustomChannelCell.self, forCellReuseIdentifier: CustomChannelCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        print("View Will Appear")
        super.viewWillAppear(animated)
        Task {
            await viewModel.getChannels()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChannelListViewCon did load")
        view.backgroundColor = .systemCyan
        setupNavigationBar()
        setupTableView()
        viewModel.delegate = self
        viewModel.errorDelegate = self
        
        Task {
            await viewModel.getChannels()
        }
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
        present(alert, animated: true)
    }
    
    
    func didUpdateData(_ data: [ChannelModel]) {
        print("deleagte 구현 \(data)")
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func createChannelButtonTapped() {
        print("Button 1 tapped!")
        Task {
            await viewModel.createChannel(aiServiceType: .geminiAI)
            await viewModel.getChannels()
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
        let image = UIImage(systemName: "questionmark")
        //Last Chat Message and Image 넣는 곳
        cell.configure(with: image!, and: "hi")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt", indexPath.row.description)
        print(viewModel.channelList[indexPath.row])
        
        let detailVC = DetailChannelViewController()
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.channel = viewModel.channelList[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        Task {
            await viewModel.deleteChannel(at: indexPath.row)
            
            DispatchQueue.main.async {
                tableView.beginUpdates()
                self.viewModel.channelList.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
}
