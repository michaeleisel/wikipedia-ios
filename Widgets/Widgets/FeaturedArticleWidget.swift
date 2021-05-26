import SwiftUI
import WidgetKit
import WMF
import UIKit

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

	}

}

// MARK: - Timeline Entry

struct FeaturedArticleEntry: TimelineEntry {
	var date: Date
	var content: WidgetFeaturedContent.FeaturedArticleContent?

	/*

	*/
}

// MARK: - Timeline Provider

struct FeaturedArticleProvider: TimelineProvider {
	typealias Entry = FeaturedArticleEntry

	func placeholder(in context: Context) -> FeaturedArticleEntry {
		return FeaturedArticleEntry(date: Date(), content: nil)
	}

	func getSnapshot(in context: Context, completion: @escaping (FeaturedArticleEntry) -> Void) {
		let wc = WidgetContentFetcher.shared
		wc.fetchFeaturedContent(language: "en", date: Date(), completion: { result in
			switch result {
			case .success(var content):
				if let imageSource = content.featuredArticle?.thumbnailSource {
					wc.fetchImageDataFrom(imageSource: imageSource) { result in
						switch result {
						case .success(let data):
							content.featuredArticle?.thumbnailSource?.data = data
							completion(FeaturedArticleEntry(date: Date(), content: content.featuredArticle))
						case .failure(_):
							completion(FeaturedArticleEntry(date: Date(), content: content.featuredArticle))
						}
					}
				} else {
					completion(FeaturedArticleEntry(date: Date(), content: content.featuredArticle))
				}
			case .failure(_):
			completion(FeaturedArticleEntry(date: Date(), content: nil))
			}
		})
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<FeaturedArticleEntry>) -> Void) {
		let wc = WidgetContentFetcher.shared
		wc.fetchFeaturedContent(language: "en", date: Date(), completion: { result in
			switch result {
			case .success(var content):
				if let imageSource = content.featuredArticle?.thumbnailSource {
					wc.fetchImageDataFrom(imageSource: imageSource) { result in
						switch result {
						case .success(let data):
							content.featuredArticle?.thumbnailSource?.data = data
							completion(Timeline(entries: [FeaturedArticleEntry(date: Date(), content: content.featuredArticle)], policy: .atEnd))
						case .failure(_):
							completion(Timeline(entries: [FeaturedArticleEntry(date: Date(), content: content.featuredArticle)], policy: .atEnd))
						}
					}
				} else {
					completion(Timeline(entries: [FeaturedArticleEntry(date: Date(), content: content.featuredArticle)], policy: .atEnd))
				}
			case .failure(_):
			completion(Timeline(entries: [FeaturedArticleEntry(date: Date(), content: nil)], policy: .atEnd))
			}
		})
	}
}

// MARK: - View

struct FeaturedArticleView: View {
	var entry: FeaturedArticleEntry
	var contentURL: URL? {
		if let urlString = entry.content?.contentURL.desktop.page {
			return URL(string: urlString)
		}
		return nil
	}

	var body: some View {
		VStack {
			Text("\(entry.content?.displayTitle ?? "-")")
			if let imageData = entry.content?.thumbnailSource?.data {
				Image(uiImage: UIImage(data: imageData) ?? UIImage())
			}
		}
		.widgetURL(contentURL)
	}
}
