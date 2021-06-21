import Foundation

extension Bundle {
    @objc public static let wmf: Bundle = Bundle(path: Bundle.main.bundlePath + "/Frameworks/WMF.framework")!
    
    @objc(wmf_assetsFolderURL)
    public var assetsFolderURL: URL {
        return url(forResource: "assets", withExtension: nil)!
    }
}
