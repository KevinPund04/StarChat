import SwiftUI

struct StoreView: View {
	let bundles = [
		(name: "Starter Bundle", price: "1.99€"),
		(name: "Pro Bundle", price: "4.99€"),
		(name: "Mega Bundle", price: "9.99€"),
		(name: "Ultimate Bundle", price: "19.99€")
	]
	
	let columns = [
		GridItem(.flexible(), spacing: 16),
		GridItem(.flexible(), spacing: 16)
	]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns, spacing: 16) {
				ForEach(bundles, id: \.name) { bundle in
					VStack {
						Text(bundle.name)
							.font(.headline)
							.padding(.top, 8)
						Spacer()
						Text(bundle.price)
							.font(.title2)
							.fontWeight(.bold)
							.padding(.bottom, 8)
					}
					.frame(width: 150, height: 100)
					.background(Color.blue.opacity(0.2))
					.cornerRadius(15)
				}
			}
			.padding()
		}
	}
}

struct StoreView_Previews: PreviewProvider {
	static var previews: some View {
		StoreView()
	}
}

