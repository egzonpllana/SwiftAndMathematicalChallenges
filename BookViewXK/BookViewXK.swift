import UIKit
import SwiftUI

/// A custom UIView subclass designed to display and manage a collection of flippable pages in a book-like format.
///
/// `BookViewXK` provides functionality for handling the layout and display of multiple `FlippablePageView` instances, allowing users to flip through them with animations and shadows.
///
/// Usage:
/// ```swift
/// let bookView = BookViewXK(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
/// let page1 = FlippablePageView()
/// let page2 = FlippablePageView()
/// bookView.setPages([page1, page2])
/// bookView.flipToNextPage()
/// ```
///
/// - Note: Ensure that `FlippablePageView` instances are properly configured before setting them in the `BookViewXK`.
class BookViewXK: UIView {

    // MARK: - Properties -
    private var pages: [FlippablePageView] = []
    private (set) var currentPageIndex: Int = 0
    private (set) var pagesCount = 0

    public var currentPage: FlippablePageView? {
        guard currentPageIndex >= 0 && currentPageIndex < pages.count else { return nil }
        return pages[currentPageIndex]
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupPagesLayout()
    }

    // MARK: - Private methods -
    private func setupView() {
        // background
        self.backgroundColor = .clear

        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }

    private func setupPagesLayout() {
        subviews.forEach { $0.removeFromSuperview() }
        pages.forEach({ $0.frame = self.bounds })
        pages.enumerated().reversed().forEach { index, page in
            addSubview(page)
        }
    }

    // MARK: - Public Methods -
    /// Sets the pages to be displayed within the view.
    ///
    /// - Parameter pages: An array of `FlippablePageView` instances to be displayed.
    public func setPages(_ pages: [FlippablePageView]) {
        self.pages = pages
        self.pagesCount = pages.count
    }

    /// Flips to the next page in the collection.
    public func flipToNextPage() {
        guard currentPageIndex < pages.count else { return }
        let currentPage = pages[currentPageIndex]
        currentPage.flipPage()
        currentPageIndex += 1

        hidePagesThatAreNotVisible()
    }
}

// MARK: - Private methods -
private extension BookViewXK {
    private func hidePagesThatAreNotVisible() {
        let indexOffset = 2
        let animationDelayOffset: TimeInterval = 0.05

        guard currentPageIndex - indexOffset >= 0 else { return }

        let pageIndex = currentPageIndex - indexOffset
        let page = pages[pageIndex]
        let delayTime = page.flipAnimationTime - animationDelayOffset

        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            page.isHidden = true
        }
    }
}

// MARK: - Preview -
#Preview {
    let pages = BookPagesFactory().createExamplePages()
    return BookViewXKRepresentable(pages: pages)
        .frame(width: 400, height: 250)
        .offset(x: -100)
}
