//
//  Created by Egzon PLLANA on 1.8.24.
//

import SwiftUI
struct BookPageViewRepresentable: UIViewRepresentable {
    let bookPageView = FlippablePageView()

    func makeUIView(context: Context) -> FlippablePageView {
        let frontView: UIView = .init()
        frontView.backgroundColor = .purple
        let backView: UIView = .init()
        backView.backgroundColor = .blue
        let page: FlippablePageModel = .init(
            frontSideView: frontView,
            backSideView: backView
        )
        bookPageView.configure(withPage: page)
        return bookPageView
    }

    func updateUIView(_ uiView: FlippablePageView, context: Context) {

    }

    func flipPage() {
        bookPageView.flipPage()
    }
}

struct ContentView: View {
    @State private var sliderValue: CGFloat = 0.0
    @State private var book = BookPageViewRepresentable()

    var body: some View {
        VStack {
            HStack {
                Text("Flippable page view")
                    .font(.title)
                    .padding()
                Spacer()
            }
            book
                .frame(width: 300, height: 200)
                .padding()
            Spacer()
                .frame(height: 50)
            Button(action: {
                book.flipPage()
            }) {
                Text("Flip the page")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
