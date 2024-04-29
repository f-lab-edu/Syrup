import UIKit

class DetailChannelViewController: UIViewController {
    private let viewModel = DetailChannelViewViewModel()
    var channel: ChannelModel?
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
    
    lazy private var tablewView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        
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
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail Channel View")
        view.backgroundColor = .white
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tablewView)
        view.addSubview(inputField)
        view.addSubview(sendButton)
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tablewView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tablewView.bottomAnchor.constraint(equalTo: inputField.topAnchor),
            tablewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tablewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
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
        let message = inputField.text
        
        guard let message = message else {
            print("No messages typed")
            return
        }
        viewModel.sendMessage(message)
    }
}

//MARK: TextField Delegate
extension DetailChannelViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("ViewDidChange")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("didEndEditing")
    }
}

//MARK: TableView Delegates
extension DetailChannelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "helo"
        return cell
    }
}

extension DetailChannelViewController: DetailChannelViewViewModelDelegate {
    func didUpdateData(_ detailChannel: DetailChannelViewViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
