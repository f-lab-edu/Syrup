import UIKit

class DetailChannelViewController: UIViewController {
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
        button.setTitle("Continue with Google", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .black
//        let googleLogo = UIImage(named: "googlelogo")?.resize(to: CGSize(width: 15, height: 15))
        let buttonImage = UIImage(systemName: "paperplane")
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
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
        
        NSLayoutConstraint.activate([
            tablewView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tablewView.bottomAnchor.constraint(equalTo: inputField.topAnchor),
            tablewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tablewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            inputField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
            inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            inputField.heightAnchor.constraint(lessThanOrEqualToConstant: 120),
        ])
    }
}

//MARK: TextField Delegate
extension DetailChannelViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("ViewDidChange")
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
