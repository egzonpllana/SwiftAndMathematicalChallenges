import UIKit

/// A custom UIView subclass representing a flippable page.
///
/// `FlippablePageView` manages the display and animation of a single flippable page, consisting of a front and back view.
/// It supports configurable properties such as corner radius, animation time, and flip functionality.
///
/// Usage:
/// ```swift
/// let flippablePage = FlippablePageView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
/// let pageModel = FlippablePageModel(frontSide: frontView, backSide: backView)
/// flippablePage.configure(withPage: pageModel, canFlipPage: true, pageCornerRadius: 18, flipAnimationTime: 0.6)
/// flippablePage.flipPage()
/// ```
///
/// - Note: Ensure that `FlippablePageModel` instances are properly configured before using them in `FlippablePageView`.
class FlippablePageView: UIView, FlippablePageViewProtocol {

    // MARK: - Properties -

    // The left half of the view
    private let transparentView = UIView()

    // The right half front view of the page
    private var frontPageView: UIView = UIView()

    // The right half back view of the page
    private var backPageView: UIView = UIView()

    // The model representing the book page
    private var page: FlippablePageModel?

    // Animator for handling the page flip animation
    private var animator: UIViewPropertyAnimator?

    // The time it takes to fully animate page flip
    private (set) var flipAnimationTime: Double = 0.5

    // Corner radius for the page
    private var pageCornerRadius: CGFloat = 18 {
        didSet {
            // Update the corner radius when changed
            self.layer.cornerRadius = pageCornerRadius
        }
    }

    // Boolean to check if the page can be flipped
    private(set) var canFlipPage: Bool = true

    // Tracks the current visible side of the page
    private(set) var activePageSide: FlippablePageSide = .right

    // MARK: - Initializers -
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup the view components
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Setup the view components
        setupView()
    }

    // MARK: - Layout -
    override func layoutSubviews() {
        super.layoutSubviews()
        // Setup the layout of page views
        setupPagesLayout()
    }

    // MARK: - Methods -
    /// Configures the flippable page view with the provided page model and properties.
    ///
    /// - Parameters:
    ///   - page: The `FlippablePageModel` instance representing the page.
    ///   - canFlipPage: A Boolean indicating whether the page can be flipped. Defaults to `true`.
    ///   - pageCornerRadius: The corner radius for the page. Defaults to `18`.
    ///   - flipAnimationTime: The time it takes to fully animate the page flip. Defaults to `0.6`.
    func configure(
        withPage page: FlippablePageModel,
        canFlipPage: Bool = true,
        pageCornerRadius: CGFloat = 18,
        flipAnimationTime: Double = 0.6
    ) {
        self.page = page
        self.canFlipPage = canFlipPage
        self.pageCornerRadius = pageCornerRadius
        self.flipAnimationTime = flipAnimationTime
    }

    /// Flips the page with an animation.
    ///
    /// - Parameter page: The side of the page to flip to. If `nil`, toggles to the next side.
    func flipPage(toPageSide page: FlippablePageSide? = nil) {
        // Ensure the page can be flipped
        guard canFlipPage else { return }

        if let page, page.nextSide != activePageSide { return }

        // Initialize a 3D transform
        var transform = CATransform3DIdentity
        // Apply perspective to the transform
        transform.m34 = -1.0 / 500.0

        // Toggle the active side
        activePageSide = activePageSide.nextSide

        // Apply rotation based on the active side
        transform = CATransform3DRotate(
            transform,
            activePageSide.angle,
            0,
            1,
            0
        )
        print("## page?.angle: ", activePageSide.angle)

        // Stop any ongoing animation
        animator?.stopAnimation(true)

        // Initialize the animator with the defined duration and linear curve
        animator = UIViewPropertyAnimator(
            duration: flipAnimationTime,
            curve: .linear
        ) {
            // Apply the 3D transform to the layer
            self.layer.transform = transform
        }

        // Toggle the visibility of page views at the midpoint of the animation
        DispatchQueue.main.asyncAfter(
            deadline: .now() + flipAnimationTime / 2
        ) {
            self.backPageView.isHidden.toggle()
            self.frontPageView.isHidden.toggle()
        }
        animator?.startAnimation()
    }

    // Method to set up the view's subviews and properties
    private func setupView() {
        // setup layer attributes
        setupLayer()

        // setup subviews
        setupSubView()
    }

    private func setupLayer() {
        // Set the corner radius
        layer.cornerRadius = pageCornerRadius
        // Clip the subviews to the layer’s bounds
        layer.masksToBounds = true
        // Set the border width
        layer.borderWidth = 0
        // Set the border color
        layer.borderColor = UIColor.black.cgColor
    }

    private func setupSubView() {
        // Set the background color of the transparent view
        transparentView.backgroundColor = .clear
        // Hide the back view initially
        backPageView.isHidden = true
        // Add transparent view as a subview
        addSubview(transparentView)
        // Add back view as a subview
        addSubview(backPageView)
        // Add front view as a subview
        addSubview(frontPageView)
    }

    private func setupPagesLayout() {
        // set page view holders frames
        let halfWidth = bounds.width / 2 // Calculate half the width of the view
        transparentView.frame = CGRect(
            x: 0,
            y: 0,
            width: halfWidth,
            height: bounds.height
        )
        frontPageView.frame = CGRect(
            x: halfWidth,
            y: 0,
            width: halfWidth,
            height: bounds.height
        )
        backPageView.frame = CGRect(
            x: halfWidth,
            y: 0,
            width: halfWidth,
            height: bounds.height
        )

        // setup page views on top of page holders
        guard let page else { return } // Ensure there's a page model
        // Remove any existing subviews
        frontPageView.subviews.forEach { $0.removeFromSuperview() }
        backPageView.subviews.forEach { $0.removeFromSuperview() }

        // Get the front side of the page
        let frontSide = page.frontSide
        // Get the back side of the page
        let backSide = page.backSide
        // Set the frame for the front side
        let sideFrame: CGRect = .init(
            x: self.bounds.minX,
            y: self.bounds.minY,
            width: self.bounds.width/2,
            height: self.bounds.height
        )
        frontSide.frame = sideFrame
        // Set the frame for the back side
        backSide.frame = sideFrame

        // Add the front side to the front view
        frontPageView.addSubview(frontSide)
        // Add the back side to the back view
        backPageView.addSubview(backSide)
    }
}
