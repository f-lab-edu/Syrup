import UIKit

class ChannelViewController: UIViewController {
    private var viewModel: ChannelViewViewModel
    var channel: ChannelModel
    lazy private var inputField: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.returnKeyType = .send
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    lazy private var tableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomMessageCell.self, forCellReuseIdentifier: CustomMessageCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        return table
    }()
    
    private let sendButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        let buttonImage = UIImage(systemName: "paperplane.fill")
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = .black
        return button
    }()
    
    init(channel: ChannelModel) {
         self.channel = channel
        self.viewModel = ChannelViewViewModel(channel.channelID)
         super.init(nibName: nil, bundle: nil)
     }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail Channel View")
        print("채널입니다", self.channel)
        viewModel.delegate = self
        view.backgroundColor = .white
        configureTableView()
        viewModel.getMessages(channel.channelID)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        view.addSubview(inputField)
        view.addSubview(sendButton)
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: inputField.topAnchor, constant: -5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            inputField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
            inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
//            inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            inputField.heightAnchor.constraint(lessThanOrEqualToConstant: 120),
            
            sendButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
//            sendButton.leadingAnchor.constraint(equalTo: inputField.trailingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            sendButton.centerYAnchor.constraint(equalTo: inputField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    @objc private func sendButtonTapped() {
        guard let message = inputField.text, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("No message typed")
            return
        }
        viewModel.sendMessage(message, channel.channelID)
        inputField.text = ""
    }
}

//MARK: TextField Delegate
extension ChannelViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("ViewDidChange")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("didEndEditing")
    }
}

//MARK: TableView Delegates
extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomMessageCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
//한 곳에서 일관적으로 처리하기 UI 업데이트 (main queue) 콜백
extension ChannelViewController: ChannelViewViewModelDelegate {
    func didUpdateData(_ viewModel: ChannelViewViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
