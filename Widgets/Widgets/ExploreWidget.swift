import SwiftUI
import WidgetKit
import WMF

// MARK: - Widget

struct ExploreWidget: Widget {
	private let kind: String = WidgetController.SupportedWidget.explore.identifier

	public var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: ExploreWidgetProvider(), content: { entry in
			ExploreWidgetView(entry: entry)
		})
		.configurationDisplayName(ExploreWidget.LocalizedStrings.widgetTitle)
		.description(ExploreWidget.LocalizedStrings.widgetDescription)
		.supportedFamilies([.systemMedium,])
	}
}

// MARK: - Data Provider

final class ExploreWidgetData {

	// MARK: - Public

	static func fetchFeaturedArticleWidgetData() {

	}

}

// MARK: - Timeline Entry

struct ExploreWidgetEntry: TimelineEntry {
	var date: Date
	var content: WidgetFeaturedContent.FeaturedArticleContent?

	/*



	*/
}

// MARK: - Timeline Provider

struct ExploreWidgetProvider: TimelineProvider {
	typealias Entry = FeaturedArticleEntry

	func placeholder(in context: Context) -> FeaturedArticleEntry {
		return FeaturedArticleEntry(date: Date(), content: nil)
	}

	func getSnapshot(in context: Context, completion: @escaping (FeaturedArticleEntry) -> Void) {
		let wc = WidgetContentFetcher.shared
		wc.fetchFeaturedContent(language: "en", date: Date(), completion: { result in
			switch result {
			case .success(let content):
				completion(FeaturedArticleEntry(date: Date(), content: content.featuredArticle))
			case .failure(_):
			completion(FeaturedArticleEntry(date: Date(), content: nil))
			}
		})
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<FeaturedArticleEntry>) -> Void) {
		let wc = WidgetContentFetcher.shared
		wc.fetchFeaturedContent(language: "en", date: Date(), completion: { result in
			switch result {
			case .success(let content):
			completion(Timeline(entries: [FeaturedArticleEntry(date: Date(), content: content.featuredArticle)], policy: .atEnd))
			case .failure(_):
			completion(Timeline(entries: [FeaturedArticleEntry(date: Date(), content: nil)], policy: .atEnd))
			}
		})
	}
}

// MARK: - View

struct ExploreWidgetView: View {
	@Environment(\.colorScheme) private var colorScheme

	var entry: FeaturedArticleEntry
	var contentURL: URL? {
		if let urlString = entry.content?.contentURL.desktop.page {
			return URL(string: urlString)
		}
		return nil
	}

	var continueReading: some View {
		Text("Content with Continue Reading")
	}

	var exploreActions: some View {
		// Text("Actions").background(Color(colorScheme == .light ? Theme.light.colors.paperBackground : Theme.dark.colors.paperBackground))
		HStack {
			Link(destination: URL(string: "wikipedia://search")!, label: {
				Text("Search")
			})
			Link(destination: URL(string: "wikipedia://random")!, label: {
				Text("Random")
			})
			Link(destination: URL(string: "wikipedia://places")!, label: {
				Text("Places")
			})
			Link(destination: URL(string: "wikipedia://saved")!, label: {
				Text("Saved")
			})
		}
	}

	var body: some View {
		VStack {
			if true {
				continueReading
			}
			exploreActions
		}
	}

}
