
import Foundation

@objc(WMFPushNotificationsController)
class PushNotificationsController: NSObject {
    @objc var deviceToken: Data? {
        didSet {
            guard _deviceToken == nil,
                  deviceToken != nil else {
                assertionFailure("Expecting to only set device token once per lifecycle of app.")
                return
            }
            
            _deviceToken = deviceToken
        }
    }
    private var _deviceToken: Data?
    
    let authenticationManager: WMFAuthenticationManager
    let echoFetcher: EchoNotificationsFetcher
    let dataProvider: PushNotificationsDataProvider
    
    @objc init(authenticationManager: WMFAuthenticationManager) {
        self.authenticationManager = authenticationManager
        self.echoFetcher = EchoNotificationsFetcher()
        self.dataProvider = PushNotificationsDataProvider(echoFetcher: echoFetcher, inMemory: false)
    }
}
