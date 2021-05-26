import SwiftUI
import WidgetKit
import WMF

// MARK: - Widget

struct FeaturedArticleWidget: Widget {
	private let kind: String = WidgetController.SupportedWidget.featuredArticle.identifier

	public var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: FeaturedArticleProvider(), content: { entry in
			FeaturedArticleView(entry: entry)
		})
		.configurationDisplayName(FeaturedArticleWidget.LocalizedStrings.widgetTitle)
		.description(FeaturedArticleWidget.LocalizedStrings.widgetDescription)
		.supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
	}
}

// MARK: - Data Provider

final class FeaturedArticleWidgetData {

	// MARK: - Public

	static func fetchFeaturedArticleWidgetData() {
		let widgetController = WidgetController.shared
	}

}

// MARK: - Timeline Entry

struct FeaturedArticleEntry: TimelineEntry {
	var date: Date

	/*



	*/
}

// MARK: - Timeline Provider

struct FeaturedArticleProvider: TimelineProvider {
	typealias Entry = FeaturedArticleEntry

	func placeholder(in context: Context) -> FeaturedArticleEntry {
		return FeaturedArticleEntry(date: Date())
	}

	func getSnapshot(in context: Context, completion: @escaping (FeaturedArticleEntry) -> Void) {
		completion(FeaturedArticleEntry(date: Date()))
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<FeaturedArticleEntry>) -> Void) {
		completion(Timeline(entries: [FeaturedArticleEntry(date: Date())], policy: .atEnd))
	}
}

// MARK: - View

struct FeaturedArticleView: View {
	var entry: FeaturedArticleEntry

	var body: some View {
		Text("Hello \(entry.date)")
	}
	
}
