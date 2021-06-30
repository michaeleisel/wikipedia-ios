
import Foundation

extension EchoNotification {
    
    @discardableResult
    static func makePreviews(count: Int) -> [EchoNotification] {
        var echoNotifications = [EchoNotification]()
        let viewContext = PushNotificationsDataProvider.preview.container.viewContext
        for index in 0..<count {
            let echoNotification = EchoNotification(context: viewContext)
            echoNotification.id = Int64(index)
            echoNotification.revId = Int64.random(in: 0...Int64.max)
            let agentId = Int64.random(in: 0...Int64.max)
            echoNotification.agentId = agentId
            echoNotification.agentName = "Name-\(agentId)"
            echoNotification.header = "Header Text"
            echoNotification.readDate = index % 2 == 0 ? Date() : nil
            echoNotification.timestamp = Date()
            echoNotification.title = "Title Text"
            echoNotification.type = "edit-user-talk"
            echoNotification.wiki = "enwiki"
            echoNotifications.append(echoNotification)
        }
        return echoNotifications
    }
    
    convenience init(remoteNotification: RemoteEchoNotification, moc: NSManagedObjectContext) {
        self.init(entity: EchoNotification.entity(), insertInto: moc)
        self.id = Int64(remoteNotification.id)
        self.revId = Int64(remoteNotification.revId)
        self.agentId = Int64(remoteNotification.agentId)
        self.agentName = remoteNotification.agentName
        self.header = remoteNotification.header
        self.readDate = remoteNotification.readDate
        self.timestamp = remoteNotification.timestamp
        self.title = remoteNotification.title
        self.type = remoteNotification.type.rawValue
        self.wiki = remoteNotification.wiki
    }
}
