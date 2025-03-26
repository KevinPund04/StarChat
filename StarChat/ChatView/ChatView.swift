import SwiftUI

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel					//@StateObject erstellt und verwaltet eine Instanz des ObservedObject
	var chat: Chat

	var body: some View {
		VStack {
			ScrollView {
				LazyVStack(alignment: .leading, spacing: viewModel.lazyVStackspacing) {
					ForEach(viewModel.chat.messages) { message in
						let messageViewModel = MessageViewModel(message: message)
						MessageView(viewModel: messageViewModel)
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
					let trimmedMessage = viewModel.newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
					if trimmedMessage.isEmpty { return }
					
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
