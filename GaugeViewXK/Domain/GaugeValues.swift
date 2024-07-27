//
//  Created by Egzon PLLANA on 26.7.24.
//

import Foundation

/// Represents the values to be displayed on the gauge.
enum GaugeValues {
    case range(start: CGFloat, end: CGFloat, parts: Int)
    case values([CGFloat])

    /// Computes the minimum and maximum values from the gauge values.
    /// - Returns: A tuple containing the minimum and maximum values.
    func minMax() -> (min: CGFloat, max: CGFloat)? {
        switch self {
        case .range(let start, let end, _):
            return (min: start, max: end)
        case .values(let values):
            guard let minValue = values.min(), let maxValue = values.max() else {
                return nil
            }
            return (min: minValue, max: maxValue)
        }
    }
}
