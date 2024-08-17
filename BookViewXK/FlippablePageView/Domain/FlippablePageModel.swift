//
//  Created by Egzon PLLANA on 31.7.24.
//

import UIKit

struct FlippablePageModel: Identifiable {
    let id: String
    let frontSide: UIView
    let backSide: UIView

    init(
        frontSideView: UIView,
        backSideView: UIView,
        id: String = UUID().uuidString
    ) {
        self.frontSide = frontSideView
        self.backSide = backSideView
        self.id = id
    }
}
