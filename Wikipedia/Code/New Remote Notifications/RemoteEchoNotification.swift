
import Foundation

struct RemoteEchoNotificationResponse: Decodable {
    let query: RemoteEchoNotificationQuery
}

struct RemoteEchoNotificationQuery: Decodable {
    let notifications: RemoteEchoNotificationsList
}

struct RemoteEchoNotificationsList: Decodable {
    let list: [RemoteEchoNotification]
}

struct RemoteEchoNotification: Decodable {
    
    enum EchoType: String, Decodable {
        case thankYouEdit = "thank-you-edit"
        case reverted
        case editUserTalk = "edit-user-talk"
    }
    
    let wiki: String
    let id: UInt
    let type: RemoteEchoNotification.EchoType
    let timestamp: Date
    let title: String
    let agentId: UInt
    let agentName: String
    let revId: UInt
    let readDate: Date?
    let header: String
    
    enum OuterKeys: String, CodingKey {
        case wiki
        case id
        case type
        case revId = "revid"
        case readDate = "read"
        case timestamp
        case title
        case agent
        case info = "*"
    }
    
    enum InfoKeys: String, CodingKey {
        case header
    }
    
    enum TimestampKeys: String, CodingKey {
        case utciso8601
    }
    
    enum TitleKeys: String, CodingKey {
        case full
    }
    
    enum AgentKeys: String, CodingKey {
        case id
        case name
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let timestampContainer = try outerContainer.nestedContainer(keyedBy: TimestampKeys.self,
                                                                    forKey: .timestamp)
        let titleContainer = try outerContainer.nestedContainer(keyedBy: TitleKeys.self,
                                                                      forKey: .title)
        let agentContainer = try outerContainer.nestedContainer(keyedBy: AgentKeys.self,
                                                                forKey: .agent)
        
        let infoContainer = try outerContainer.nestedContainer(keyedBy: InfoKeys.self, forKey: .info)

        self.wiki = try outerContainer.decode(String.self, forKey: .wiki)
        self.id = try outerContainer.decode(UInt.self, forKey: .id)
        self.type = try outerContainer.decode(EchoType.self, forKey: .type)
        self.revId = try outerContainer.decode(UInt.self, forKey: .revId)
        let readDate = try outerContainer.decode(String.self, forKey: .readDate)
        self.readDate = nil //for now, convert readDate above
        let timestampDate = try timestampContainer.decode(String.self, forKey: .utciso8601)
        self.timestamp = Date() //for now, convert timestampDate above
        self.title = try titleContainer.decode(String.self, forKey: .full)
        self.agentId = try agentContainer.decode(UInt.self, forKey: .id)
        self.agentName = try agentContainer.decode(String.self, forKey: .name)
        self.header = try infoContainer.decode(String.self, forKey: .header)
      }
}
