import SwiftUI

struct ChatView: View {
	@ObservedObject var viewModel = ChatViewModel()
	@State private var userInput: String = ""
	var chat: Chat
	
	var body: some View {
		VStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 8) {
					ForEach(chat.messages) { message in
						HStack {
							if message.isUser {
								Spacer()
								Text(message.text)
									.padding()
									.background(Color.blue.opacity(0.8))
									.foregroundColor(.white)
									.cornerRadius(10)
							} else {
								Text(message.text)
									.padding()
									.background(Color.gray.opacity(0.2))
									.cornerRadius(10)
								Spacer()
							}
						}
					}
				}
				.padding()
			}
			.frame(maxHeight: .infinity)
			
			HStack {
				TextField("Nachricht eingeben...", text: $userInput)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				Button("Senden") {
					guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
					viewModel.sendMessage(viewModel.newMessage, for: chat)
					userInput = ""
				}
				.padding(.horizontal)
			}
			.padding()
		}
		.navigationTitle(chat.name)
	}
}
