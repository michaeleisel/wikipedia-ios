import Foundation

public struct WidgetCache: Codable {

	// MARK: - Properties

	public var settings: WidgetSettings
	public var featuredContent: WidgetFeaturedContent?
	public var exploreContent: WidgetExploreContent?

	// MARK: - Public

	public init(settings: WidgetSettings, featuredContent: WidgetFeaturedContent?, exploreContent: WidgetExploreContent?) {
		self.settings = settings
		self.featuredContent = featuredContent
		self.exploreContent = exploreContent
	}

}
