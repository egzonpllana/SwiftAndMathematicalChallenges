import SwiftUI

/// A SwiftUI view that displays an example book view with flipping functionality.
struct ExampleBookViewXK: View {

    // MARK: - Properties -
    @State private var bookView: BookViewXKRepresentable?
    @State private var offset: CGFloat = 0.0
    @State private var scale: CGFloat = Constants.defaultScale
    @State private var buttonTitle: String = Constants.buttonTitleSeeNextPage

    // MARK: - View -
    var body: some View {
        VStack {
            Spacer().frame(height: 60)
            bookViewBuilder
                .frame(height: Constants.bookHeight)
            Spacer().frame(height: 80)
            bookDetailsView
            ratingView
                .padding([.top], 4)
            descriptionView
                .padding([.top])
            categoriesView
            Spacer()
            flipButton
                .padding(8)
        }
        .padding()
        .navigationTitle(Constants.bookDetails)
        .toolbar {
            // left placement
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: Constants.arrowLeftIcon)
                    .foregroundColor(.black)
            }
            // right placement
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Image(systemName: Constants.heartIcon)
                    .foregroundColor(.black)
                Image(systemName: Constants.cartBadgePlusIcon)
                    .foregroundColor(.black)
            }
        }
        .onAppear {
            initializeBookView()
        }
    }

    // MARK: - Methods -
    private func flipToNextPage() {
        guard let currentPage = bookView?.currentPage,
              let pagesCount = bookView?.pagesCount else { return }

        if currentPage == 0 {
            // Reset offset and scale for the first page.
            offset = .zero
            scale = Constants.defaultScale
        } else if currentPage == (pagesCount - 1) {
            // Adjust offset and scale for the last page.
            offset = UIScreen.main.bounds.width / Constants.offsetScaleFactor
            scale = Constants.zoomedScale
        }

        // Flip to the next page.
        bookView?.flipNextPage()
        if currentPage == pagesCount-1 {
            buttonTitle = Constants.buttonTitleOrder
        }
    }

    /// Initializes the bookView with example pages.
    private func initializeBookView() {
        let pages = BookPagesFactory().createExamplePages()
        scale = Constants.zoomedScale
        bookView = BookViewXKRepresentable(pages: pages)
        offset = -(UIScreen.main.bounds.width / Constants.offsetScaleFactor)
    }

    private var bookViewBuilder: some View {
        bookView
            .scaleEffect(scale)
            .offset(x: offset, y: .zero)
            .animation(.easeInOut(duration: Constants.animationTime), value: offset)
            .animation(.easeInOut(duration: Constants.animationTime), value: scale)
    }

    private var descriptionView: some View {
        HStack {
            Rectangle()
                .frame(width: 3)
                .frame(maxHeight: .infinity)
                .foregroundColor(.gray.opacity(0.3))
            VStack(alignment: .leading) {
                HStack {
                    Text(Constants.descriptionText)
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(Constants.price14_12)
                        .bold()
                        .foregroundStyle(Color.gray.opacity(0.9))
                }
                Spacer()
                    .frame(height: 8)
                Text(Constants.bookDescription)
                    .italic()
            }
        }
    }

    private var bookDetailsView: some View {
        Group {
            Text(Constants.bookTitle.uppercased())
                .font(.title)
            Text(Constants.bookSubtitle.uppercased())
            Text(Constants.bookAuthor)
                .font(.caption)
        }
    }

    private var flipButton: some View {
        Button(action: {
            flipToNextPage()
        }) {
            Text(buttonTitle)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(20)
        }
    }

    private var ratingView: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= 4 ? Constants.starFillIcon : Constants.starIcon)
                    .foregroundColor(index <= 4 ? .yellow : .gray)
                    .font(.caption)
            }
        }
    }

    private var categoriesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryView(title: Constants.categoryFictional, backgroundColor: Color.yellow.opacity(0.2))
                CategoryView(title: Constants.categoryNovel, backgroundColor: Color.red.opacity(0.1))
                CategoryView(title: Constants.categoryThriller, backgroundColor: Color.gray.opacity(0.1))
                CategoryView(title: Constants.categoryMystery, backgroundColor: Color.blue.opacity(0.1))
                CategoryView(title: Constants.categoryScienceFiction, backgroundColor: Color.green.opacity(0.1))
            }
            .padding([.top], 4)
        }
    }
}

// MARK: - Preview -
#Preview {
    NavigationView {
        ExampleBookViewXK()
    }
}

// MARK: - Private related models -
private extension ExampleBookViewXK {
    struct CategoryView: View {
        let title: String
        let backgroundColor: Color

        var body: some View {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .cornerRadius(12)
                .foregroundColor(.gray)
                .font(.headline)
        }
    }
}

// MARK: - Constants -
private extension ExampleBookViewXK {

    /// A set of constant values used for configuring the view.
    private enum Constants {
        static let offsetScaleFactor = 2.9
        static let animationTime = 0.5
        static let defaultScale = 1.0
        static let zoomedScale = 1.5
        static let spacerHeight = 124.0
        static let bookHeight = 220.0

        static let buttonTitleSeeNextPage = "See next page"
        static let buttonTitleOrder = "Order"
        static let bookTitle = "Harry Potter"
        static let bookSubtitle = "and the deathly hallows"
        static let bookAuthor = "by J. K. Rowling"
        static let bookDescription = "Harry Potter and the Deathly Hallows' is the seventh and final book in J.K. Rowling's Harry Potter series. It follows Harry Potter as he embarks on a quest to find and destroy Horcruxes, objects containing pieces of Voldemort's soul, which are crucial to his immortality. Joined by his friends Hermione Granger and Ron Weasley, Harry faces numerous challenges, uncovers secrets about his past, and prepares for the ultimate showdown with Voldemort. The story culminates in the Battle of Hogwarts, where Harry confronts Voldemort in a decisive confrontation, bringing the series to a thrilling conclusion."

        static let descriptionText = "Description"
        static let bookDetails = "Book Details"
        static let price14_12 = "$14.12"

        static let categoryFictional = "Fictional"
        static let categoryNovel = "Novel"
        static let categoryThriller = "Thriller"
        static let categoryMystery = "Mystery"
        static let categoryScienceFiction = "Science Fiction"

        static let cartBadgePlusIcon = "cart.badge.plus"
        static let heartIcon = "heart.fill"
        static let heartFillIcon = "heart.fill"
        static let arrowLeftIcon = "arrow.left"
        static let starIcon = "star"
        static let starFillIcon = "star.fill"
    }
}
