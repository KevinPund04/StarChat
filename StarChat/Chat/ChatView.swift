import SwiftUI

struct ChatView: View {
	let chat: Chat
	@StateObject private var viewModel = ChatViewModel()
	@State private var userInput = ""

	var body: some View {
		VStack {
			ScrollView {
				ForEach(viewModel.messages) { message in
					HStack {
						if message.isUser { Spacer() }
						Text(message.text)
							.padding()
							.background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
							.cornerRadius(10)
						if !message.isUser { Spacer() }
					}
					.padding(.horizontal)
				}
			}
			
			HStack {
				TextField("Nachricht eingeben...", text: $userInput)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				Button("Senden") {
					viewModel.sendMessage(userInput, for: chat)
					userInput = ""
				}
			}
			.padding()
		}
		.navigationTitle(chat.name)
	}
}
