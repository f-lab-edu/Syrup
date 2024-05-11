    import UIKit


    import UIKit

    class CustomMessageCell: UITableViewCell {
        
        static let identifier = "CustomMessageCell"
        var textLeading: NSLayoutConstraint!
        var textTrailing: NSLayoutConstraint!
        var imageLeading: NSLayoutConstraint!
        var imageTrailing: NSLayoutConstraint!
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(systemName: "person")
            return imageView
        }()
        
        let bubbleView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 10
            view.backgroundColor = .systemBlue
            
            return view
            
        }()
        
        let chatTextLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "Hello World jfhsjdfhsjdfsjdf jsdhfkjsdhfkjsd fsjdfhiwjefnjkwe fjsd dfjshdfkjwhejkfhkjdfhsdfhls fhsjkdfhksjdfh"
            
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configureUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureUI() {
            addSubview(profileImageView)
            addSubview(bubbleView)
            addSubview(chatTextLabel)
            
            NSLayoutConstraint.activate([
                profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
                profileImageView.heightAnchor.constraint(equalToConstant: 32),
                profileImageView.widthAnchor.constraint(equalToConstant: 32),
                
                chatTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                chatTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                chatTextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                
                bubbleView.topAnchor.constraint(equalTo: chatTextLabel.topAnchor, constant: -8),
                bubbleView.leadingAnchor.constraint(equalTo: chatTextLabel.leadingAnchor, constant: -8),
                bubbleView.trailingAnchor.constraint(equalTo: chatTextLabel.trailingAnchor, constant: 8),
                bubbleView.bottomAnchor.constraint(equalTo: chatTextLabel.bottomAnchor, constant: 8),
                
            ])
            
            imageLeading = profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
            imageTrailing = profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            
            textLeading = chatTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
            textTrailing = chatTextLabel.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -8)
        }
        
        func configureForMessage(message: String, isUser: Bool) {
            chatTextLabel.text = message
            if isUser {
                bubbleView.backgroundColor = .systemBlue
                imageTrailing.isActive = true
                textTrailing.isActive = true
            } else {
                bubbleView.backgroundColor = .systemGray
                imageLeading.isActive = true
                textLeading.isActive = true
            }
        }
    }
