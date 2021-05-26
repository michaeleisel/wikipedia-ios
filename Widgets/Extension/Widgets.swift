import WidgetKit
import SwiftUI

@main
struct WikipediaWidgets: WidgetBundle {

	@WidgetBundleBuilder
	var body: some Widget {
        ExploreWidget()
        FeaturedArticleWidget()
		PictureOfTheDayWidget()
		OnThisDayWidget()
        TopReadWidget()        
	}

}
