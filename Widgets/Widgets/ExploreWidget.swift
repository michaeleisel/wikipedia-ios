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
		.supportedFamilies([.systemMedium])
	}
}

// MARK: - Timeline Entry

struct ExploreWidgetEntry: TimelineEntry {
	var date: Date
}

// MARK: - Timeline Provider

struct ExploreWidgetProvider: TimelineProvider {
	typealias Entry = ExploreWidgetEntry

	func placeholder(in context: Context) -> ExploreWidgetEntry {
		return ExploreWidgetEntry(date: Date())
	}

	func getSnapshot(in context: Context, completion: @escaping (ExploreWidgetEntry) -> Void) {
		completion(ExploreWidgetEntry(date: Date()))
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<ExploreWidgetEntry>) -> Void) {
		completion(Timeline(entries: [ExploreWidgetEntry(date: Date())], policy: .atEnd))
	}
}

// MARK: - View

struct ExploreWidgetView: View {
	@Environment(\.colorScheme) private var colorScheme

	var entry: ExploreWidgetEntry

	var hasContinueReadingContent: Bool {
		return true
	}

	var titleColor: Color {
		return Color(colorScheme == .light ? Theme.light.colors.primaryText : Theme.dark.colors.primaryText)
	}

	var subtitleColor: Color {
		return Color(colorScheme == .light ? Theme.light.colors.secondaryText : Theme.dark.colors.secondaryText)
	}

	var continueReading: some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Text(ExploreWidget.LocalizedStrings.widgetContinueReadingTitle)
					.font(.headline)
					.bold()
					.foregroundColor(titleColor)
				Spacer()
			}
			HStack(alignment: .center) {
				VStack(alignment: .leading, spacing: 4) {
					Text("Article title")
						.font(.caption)
						.bold()
						.lineLimit(1)
						.truncationMode(.tail)
						.foregroundColor(titleColor)
					Text("Article description")
						.font(.caption2)
						.lineLimit(1)
						.truncationMode(.tail)
						.foregroundColor(subtitleColor)
				}
				Spacer()
				Image(systemName: "sleep")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.background(Rectangle().background(Color.gray).cornerRadius(6))
			}
		}
		.padding([.top, .leading, .trailing])
	}

	var exploreActions: some View {
		HStack() {
			Spacer().frame(width: 10)
			Link(destination: URL(string: "wikipedia://search")!, label: {
				Image(systemName: "magnifyingglass")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.background(Ellipse().foregroundColor(.blue))
			})
			Spacer()
			Link(destination: URL(string: "wikipedia://random")!, label: {
				Image(systemName: "magnifyingglass")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.background(Ellipse().foregroundColor(.blue))
			})
			Spacer()
			Link(destination: URL(string: "wikipedia://places")!, label: {
				Image(systemName: "magnifyingglass")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.background(Ellipse().foregroundColor(.blue))
			})
			Spacer()
			Link(destination: URL(string: "wikipedia://saved")!, label: {
				Image(systemName: "magnifyingglass")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.background(Ellipse().foregroundColor(.blue))
			})
			Spacer().frame(width: 10)
		}
		.background(Color.gray)
	}

	var exploreContainer: some View {
		ZStack {
			Rectangle()
				.cornerRadius(8)
				.padding([!hasContinueReadingContent ? .all : .leading, .trailing, .bottom])
				.foregroundColor(Color(colorScheme == .light ? Theme.light.colors.paperBackground : Theme.dark.colors.paperBackground))
				.diffuseShadow()
		}
	}

	var body: some View {
		VStack {
			if hasContinueReadingContent {
				continueReading
			}
			exploreContainer
		}
	}

}
