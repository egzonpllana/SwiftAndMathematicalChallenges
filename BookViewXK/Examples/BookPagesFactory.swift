//
//  Created by Egzon PLLANA on 2.8.24.
//

import UIKit

/// A factory for creating and configuring `FlippablePageView` instances.
///
/// `BookPagesFactory` provides methods to create example pages for a book, including blank pages and a cover page.
/// It helps in setting up the pages with appropriate images and configurations.
struct BookPagesFactory {
    /// Inserts blank pages into the provided array of `FlippablePageView` instances.
    ///
    /// - Parameters:
    ///   - pages: The array of `FlippablePageView` instances to which blank pages will be added.
    ///   - amount: The number of blank pages to insert. Defaults to 3.
    func insertBlankPages(_ pages: inout [FlippablePageView], amount: Int = 3) {
        for index in 0...amount {
            let pageView = FlippablePageView()
            let pageModel = FlippablePageModel(
                frontSideView: makeImageView(with: .frontBlank(page: index+1)),
                backSideView: makeImageView(with: (index == amount) ? .frontSecond : .rearBlank)
            )
            pageView.configure(withPage: pageModel, pageCornerRadius: 4)
            pages.append(pageView)
        }
    }

    /// Inserts the first cover page into the provided array of `FlippablePageView` instances.
    ///
    /// - Parameter pages: The array of `FlippablePageView` instances to which the first cover page will be added.
    func insertBookFirstCover(_ pages: inout [FlippablePageView]) {
        let frontImageView = makeImageView(with: .frontFirst)
        let rearImageView = makeImageView(with: .rearBlank)

        let bookCover = FlippablePageView()
        let pageModel = FlippablePageModel(
            frontSideView: frontImageView,
            backSideView: rearImageView
        )
        bookCover.configure(withPage: pageModel, pageCornerRadius: 4)
        pages.append(bookCover)
    }

    /// Creates example pages for a book, including a cover page and several blank pages.
    ///
    /// - Returns: An array of `FlippablePageView` instances representing the example pages.
    func createExamplePages() -> [FlippablePageView] {
        var pages: [FlippablePageView] = []
        insertBookFirstCover(&pages)
        insertBlankPages(&pages)
        return pages
    }

    /// Creates and configures a UIImageView with the specified image name.
    ///
    /// - Parameter name: The name of the image to be used in the UIImageView.
    /// - Returns: A configured UIImageView instance.
    private func makeImageView(with name: ImageName) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: name.imageName)
        return imageView
    }

    /// Enum representing different image names used for page sides.
    enum ImageName {
        case frontFirst
        case frontSecond
        case frontBlank(page: Int)
        case rearBlank
        case customWithExtension(String)

        /// The actual image name as a string.
        var imageName: String {
            switch self {
            case .frontFirst: return "harry-poter-front-cover.png"
            case .frontSecond: return "harry-poter-front-second-cover.png"
            case .frontBlank(let page): return "blank-page-front-\(page).png"
            case .rearBlank: return "blank-page-rear.png"
            case .customWithExtension(let imageResource): return imageResource
            }
        }
    }
}
