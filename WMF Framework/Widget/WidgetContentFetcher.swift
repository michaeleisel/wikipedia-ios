import Foundation
import Combine

public final class WidgetContentFetcher {

	// MARK: - Nested Type

	public enum FetcherError: Error {
		case urlFailure
		case contentFailure
	}

	// MARK: - Properties

	public static let shared = WidgetContentFetcher()

	let session = URLSession.shared
	let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy/MM/dd"
		return dateFormatter
	}()

	// MARK: - Public

	public func fetchFeaturedContent(language: String, date: Date, completion: @escaping (Result<WidgetFeaturedContent, FetcherError>) -> Void) {
		let formattedDate = dateFormatter.string(from: date)
		guard let featuredURL = URL(string: "https://en.wikipedia.org/api/rest_v1/feed/featured/\(formattedDate)") else {
			completion(.failure(.urlFailure))
			return
		}

		let task = session.dataTask(with: featuredURL) { data, response, error in
			if let data = data, let decoded = try? JSONDecoder().decode(WidgetFeaturedContent.self, from: data) {
				completion(.success(decoded))
				return
			}

			completion(.failure(.contentFailure))
		}

		task.resume()
	}

	public func fetchImageDataFrom(imageSource: WidgetFeaturedContent.FeaturedArticleContent.ImageSource, completion: @escaping (Result<Data, FetcherError>) -> Void) {
		guard let imageURL = URL(string: imageSource.source) else {
			completion(.failure(.urlFailure))
			return
		}

		let task = session.dataTask(with: imageURL) { data, response, error in
			if let data = data {
				completion(.success(data))
				return
			}

			completion(.failure(.contentFailure))
		}

		task.resume()
	}

}
