//
//  Created by Egzon PLLANA on 31.7.24.
//

import UIKit

/// An enumeration representing the sides of a page.
enum FlippablePageSide {
    /// Represents the left side of the page.
    case left
    /// Represents the right side of the page.
    case right

    /// The rotation angle corresponding to the page side.
    var angle: CGFloat {
        switch self {
        case .left:
            return -.pi // Rotate to -180 degrees for the left side.
        case .right:
            return 0.0 // Rotate 0 degrees for the right side.
        }
    }

    /// The next side after the current side.
    var nextSide: Self {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}
