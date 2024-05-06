import UIKit


import UIKit

class CustomMessageCell: UITableViewCell {
    
    static let identifier = "CustomMessageCell"
    
    private let channelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .tintColor
        return imageView
    }()
    
    private let channelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: UIImage, and label: String) {
        self.channelImageView.image = image
        self.channelLabel.text = label
    }
    
    private func configureUI() {
        self.contentView.addSubview(channelImageView)
        self.contentView.addSubview(channelLabel)
        
        channelImageView.translatesAutoresizingMaskIntoConstraints = false
        channelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            channelImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            channelImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            channelImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            
            channelImageView.heightAnchor.constraint(equalToConstant: 90),
            channelImageView.widthAnchor.constraint(equalToConstant: 90),
            
            
            channelLabel.leadingAnchor.constraint(equalTo: self.channelImageView.trailingAnchor, constant: 16),
            channelLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            channelLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            channelLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
        ])
    }
}
