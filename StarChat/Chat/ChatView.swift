import SwiftUI

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel					//@StateObject erstellt und verwaltet eine Instanz des ObservedObject
	var chat: Chat

	var body: some View {
		VStack {
			ScrollView {
				LazyVStack(alignment: .leading, spacing: viewModel.lazyVStackspacing) {
					ForEach(viewModel.chat.messages) { message in
						HStack {
							if message.isUser {
								Spacer()
								Text(message.text)
									.padding()
									.background(Color.blue.opacity(viewModel.backgroundColorOpacity))
									.foregroundColor(.white)
									.cornerRadius(viewModel.cornerRadius)
									.frame(maxWidth: viewModel.textMaxWidth, alignment: .trailing)
							} else {
								Text(message.text)
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
				.padding()
			}

			Divider()

			HStack {
				TextField("Nachricht eingeben...", text: $viewModel.newMessage)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding()

				Button(action: {
					viewModel.sendMessage(viewModel.newMessage)
					viewModel.newMessage = ""
				}) {
					Image(systemName: "paperplane.fill")
						.foregroundColor(.blue)
						.padding()
				}
			}
			.padding(.horizontal)
		}
		.navigationTitle(viewModel.chat.name)
	}
}
