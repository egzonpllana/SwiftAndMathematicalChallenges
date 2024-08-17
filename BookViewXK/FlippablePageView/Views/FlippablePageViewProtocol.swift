//
//  Created by Egzon PLLANA on 1.8.24.
//

import Foundation

/// Protocol defining the behavior of a flippable page view.
///
/// `FlippablePageViewProtocol` provides the required properties and methods for any view that can represent a flippable page.
/// It includes functionality for configuring the page view, flipping the page with animations, and accessing the current state of the page.
protocol FlippablePageViewProtocol {
    /// The currently active side of the page.
    var activePageSide: FlippablePageSide { get }

    /// The duration for the flip animation.
    var flipAnimationTime: Double { get }

    /// A boolean indicating whether the page can be flipped.
    var canFlipPage: Bool { get }

    /// Flips the page to the specified side with an animation.
    ///
    /// - Parameter page: The side of the page to flip to. If nil, flips to the opposite side.
    /// - Note: The method checks if the page can be flipped before performing the animation.
    func flipPage(toPageSide page: FlippablePageSide?)

    /// Configures the page view with the specified parameters.
    ///
    /// - Parameters:
    ///   - page: The model representing the book page.
    ///   - canFlipPage: A boolean indicating whether the page can be flipped.
    ///   - pageCornerRadius: The corner radius for the page.
    ///   - flipAnimationTime: The duration for the flip animation.
    func configure(
        withPage page: FlippablePageModel,
        canFlipPage: Bool,
        pageCornerRadius: CGFloat,
        flipAnimationTime: Double
    )
}

extension FlippablePageViewProtocol {
    func flipPage() {
        self.flipPage(toPageSide: nil)
    }
}
