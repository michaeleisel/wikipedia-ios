
import UIKit

class NotificationCenterTableViewCell: UITableViewCell {
    
    private var titleLabel: UILabel?

    func configure(notification: EchoNotification) {
        addTitleLabelIfNeeded()
        titleLabel?.text = notification.agentName
    }
    
    private func addTitleLabelIfNeeded() {
        guard titleLabel == nil else {
            return
        }
        
        let titleLabel = UILabel(frame: .zero)
        self.titleLabel = titleLabel
        contentView.addSubview(titleLabel)
        contentView.wmf_addConstraintsToEdgesOfView(titleLabel)
    }

}
