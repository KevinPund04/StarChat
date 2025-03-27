import SwiftUI

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel					//@StateObject erstellt und verwaltet eine Instanz des ObservedObject
	
	var chat: Chat
	
	var body: some View {
		
		VStack {
			ScrollViewReader { proxy in
				ScrollView {
					LazyVStack(alignment: .leading, spacing: viewModel.lazyVStackspacing) {
						ForEach(viewModel.chat.messages) { message in
							let messageViewModel = MessageViewModel(message: message)
							MessageView(viewModel: messageViewModel)
								.id(message.id)
						}
					}
					.padding()
				}
				.onChange(of: viewModel.chat.messages.count) {
					withAnimation {
						proxy.scrollTo(viewModel.chat.messages.last?.id, anchor: .bottom)
					}
				}

			}
			
			Divider()

			HStack {
				TextField("Nachricht eingeben...", text: $viewModel.newMessage)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding()
				Button(action: {
					if viewModel.emptyMessage.isEmpty { return }
					
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
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .principal) {
				HStack{
					Image(chat.imageName)
						.resizable()
						.scaledToFit()
						.frame(width: 40, height: 40)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.gray, lineWidth: 1))
					Text(viewModel.chat.name)
							.font(.headline)
					}
				}
		}
	}
}
