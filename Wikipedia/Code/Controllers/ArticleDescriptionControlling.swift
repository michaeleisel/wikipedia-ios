
import Foundation

struct ArticleDescriptionWarningTypes: OptionSet {
    let rawValue: Int

    static let length = ArticleDescriptionWarningTypes(rawValue: 1 << 0)
    static let casing = ArticleDescriptionWarningTypes(rawValue: 1 << 1)
}

protocol ArticleDescriptionControlling {
    var descriptionSource: ArticleDescriptionSource { get }
    var article: WMFArticle { get }
    var articleLanguage: String { get }
    func publishDescription(_ description: String, completion: @escaping (Result<Void, Error>) -> Void)
    func currentDescription(completion: @escaping (String?) -> Void)
    func errorTextFromError(_ error: Error) -> String
    func learnMoreViewControllerWithTheme(_ theme: Theme) -> UIViewController?
    var descriptionMaxLength: Int { get }
    func warningTypesForDescription(_ description: String?) -> ArticleDescriptionWarningTypes
}

extension ArticleDescriptionControlling {
    var articleDisplayTitle: String? { return article.displayTitle }
    var descriptionMaxLength: Int { return 90 }
    
    func descriptionIsTooLong(_ description: String?) -> Bool {
        let isDescriptionLong = (description?.count ?? 0) > descriptionMaxLength
        return isDescriptionLong
    }
}
