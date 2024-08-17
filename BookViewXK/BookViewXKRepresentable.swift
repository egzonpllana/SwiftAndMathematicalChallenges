//
//  Created by Egzon PLLANA on 2.8.24.
//

import SwiftUI

/// A SwiftUI wrapper for the `BookViewXK` class, enabling its use within SwiftUI views.
///
/// `BookViewXKRepresentable` allows for the integration of `BookViewXK`, a custom UIView subclass, within SwiftUI layouts. This struct provides functionality to manage and flip through pages in the `BookViewXK`.
///
/// Usage:
/// ```swift
/// let pages = BookPagesFactory().createExamplePages()
/// let bookViewRepresentable = BookViewXKRepresentable(pages: pages)
/// ```
///
/// - Note: Ensure that `FlippablePageView` instances are properly configured before setting them in the `BookViewXK`.
struct BookViewXKRepresentable: UIViewRepresentable {
    private let bookView = BookViewXK()
    var pages: [FlippablePageView]

    var currentPage: Int {
        bookView.currentPageIndex
    }

    var pagesCount: Int {
        bookView.pagesCount
    }

    func makeUIView(context: Context) -> BookViewXK {
        bookView.setPages(pages)
        return bookView
    }

    func updateUIView(_ uiView: BookViewXK, context: Context) {
        // Update the view if necessary
    }

    /// Flips to the next page in the `BookViewXK`.
    func flipNextPage() {
        bookView.flipToNextPage()
    }
}
