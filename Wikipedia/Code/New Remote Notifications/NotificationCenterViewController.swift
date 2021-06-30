
import UIKit

class NotificationCenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let label = UILabel(frame: .zero)
        label.text = "Testing from UIKit"
        view.addCenteredSubview(label)
    }
}
