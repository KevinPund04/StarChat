import SwiftUI

struct ChatRowView: View {
	let chat: Chat
	@ObservedObject var viewModel: ChatListViewModel

	var body: some View {
		let chatViewModel = ChatViewModel(chat: chat)
		NavigationLink(destination: ChatView(viewModel: chatViewModel, chat: chat)) {
			HStack {
				Image(chat.imageName)
					.resizable()
					.scaledToFit()
					.frame(width: 40, height: 40)
					.clipShape(Circle())
					.overlay(Circle().stroke(Color.gray, lineWidth: 1))

				Text(chat.name)
			}
		}
		.contextMenu {
			Button(role: .destructive) {
				viewModel.clearChat(chatName: chat.name)
				viewModel.loadChats()
			} label: {
				Label("Chatverlauf löschen", systemImage: "trash")
			}
		}
	}
}
