import SwiftUI

struct MessageView: View {
	
	@ObservedObject var viewModel: MessageViewModel
	
	var body: some View {
		HStack {
			if viewModel.message.isUser {
				Spacer()
				Text(viewModel.message.text)
					.padding()
					.background(Color.blue.opacity(viewModel.backgroundColorOpacity))
					.foregroundColor(.white)
					.cornerRadius(viewModel.cornerRadius)
					.frame(maxWidth: viewModel.textMaxWidth, alignment: .trailing)
			} else {
				Text(viewModel.message.text)
					.padding()
					.background(Color.white.opacity(viewModel.backgroundColorOpacity))
					.foregroundColor(.black)
					.cornerRadius(viewModel.cornerRadius)
					.frame(maxWidth: viewModel.textMaxWidth, alignment: .leading)
				Spacer()
			}
		}
	}
}
