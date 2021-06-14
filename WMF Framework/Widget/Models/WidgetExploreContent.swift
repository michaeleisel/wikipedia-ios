import Foundation

public struct WidgetExploreContent: Codable {

	// MARK: - Nested Types

	public struct ContinueReadingArticle: Codable {
		let title: String
		let description: String?
		let contentURL: URL?
		let imageURL: URL?
		var imageData: Data?
	}

	// MARK: - Properties

	public let continueReadingArticle: ContinueReadingArticle?

}
