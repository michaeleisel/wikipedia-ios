
import SwiftUI

@available(iOS 13.0, *)
struct NotificationCenterListView: View {
    
    let dataProvider: PushNotificationsDataProvider
    
    @FetchRequest(sortDescriptors: [])
    private var notifications: FetchedResults<EchoNotification>
    
    @SwiftUI.State var initiallyLoaded = false
    
    var body: some View {
        List {
            if !initiallyLoaded {
                if #available(iOS 14.0, *) {
                    ProgressView()
                } else {
                    // Fallback on earlier versions
                }
            }
            ForEach(notifications, id: \.self) { notification in
                Text(notification.agentName ?? "Unknown agent name")
            }
        }
        .onAppear {
            dataProvider.fetchNotifications { result in
                switch result {
                case .success():
                    print("success!")
                    DispatchQueue.main.async {
                        initiallyLoaded = true
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
@available(iOS 13.0, *)
struct NotificationCenterListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCenterListView(dataProvider: PushNotificationsDataProvider.preview)
    }
}
