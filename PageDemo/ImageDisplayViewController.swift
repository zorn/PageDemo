import UIKit

class ImageDisplayViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    
    var imageName: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    fileprivate func updateUI() {
        guard let imageName = imageName else {
            return
        }
        imageView.image = UIImage(named: imageName)
        imageTitleLabel.text = imageName
    }
    
}
