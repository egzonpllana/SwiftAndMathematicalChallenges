//
//  Created by Egzon PLLANA on 26.7.24.
//

import Foundation
import SwiftUI

/// A SwiftUI view that wraps the GaugeViewXK.
struct GaugeViewXKRepresentable: UIViewRepresentable {
    @Binding var goToValue: Double

    // Optional parameters with default values
    var gaugeValues: GaugeValues = .range(start: 0, end: 500, parts: 10)
    var gaugeColor: GaugeColor = .gradient([.red, .yellow, .green])
    var gaugeWidth: CGFloat = 18
    var gaugeBackgroundColor: UIColor = .clear
    var indicatorColor: UIColor = UIColor(Color.primary)
    var indicatorWidth: CGFloat = 4
    var labelColor: UIColor = UIColor(Color.primary)
    var labelFont: UIFont = .systemFont(ofSize: 12)
    var animationTime: Double = 10

    /// Creates the UIView instance.
    func makeUIView(context: Context) -> GaugeViewXK {
        return GaugeViewXK(
            gaugeValues: gaugeValues,
            gaugeColor: gaugeColor,
            gaugeBackgroundColor: gaugeBackgroundColor,
            gaugeWidth: gaugeWidth,
            indicatorColor: indicatorColor,
            indicatorWidth: indicatorWidth,
            labelColor: labelColor,
            labelFont: labelFont,
            animationTime: animationTime
        )
    }

    /// Updates the UIView instance with new values.
    func updateUIView(_ uiView: GaugeViewXK, context: Context) {
        uiView.setValue(goToValue)
    }
}

#Preview {
    @State var value: Double = 30
    return GaugeViewXKRepresentable(goToValue: $value)
}
