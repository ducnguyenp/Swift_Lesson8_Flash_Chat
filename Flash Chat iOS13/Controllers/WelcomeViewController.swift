import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: CLTypingLabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        
        titleLabel.text = "⚡️FlashChat"
        navigationController?.isNavigationBarHidden = true
    }
}
