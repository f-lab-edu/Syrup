import UIKit

class DetailChannelViewController: UIViewController {
    
    var channel: ChannelModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.channel)
        print("Detail Channel View")
        
        view.backgroundColor = .white
    }
}
