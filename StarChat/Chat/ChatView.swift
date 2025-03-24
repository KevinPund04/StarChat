import SwiftUI

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel
	var chat: Chat

	var body: some View {
		VStack {
			ScrollView {
				LazyVStack(alignment: .leading, spacing: 8) {
					ForEach(viewModel.chat.messages) { message in
						HStack {
							if message.isUser {
								Spacer()
								Text(message.text)
									.padding()
									.background(Color.blue.opacity(0.7))
									.foregroundColor(.white)
									.cornerRadius(10)
									.frame(maxWidth: 250, alignment: .trailing)
							} else {
								Text(message.text)
									.padding()
									.background(Color.white.opacity(0.7))
									.foregroundColor(.black)
									.cornerRadius(10)
									.frame(maxWidth: 250, alignment: .leading)
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
