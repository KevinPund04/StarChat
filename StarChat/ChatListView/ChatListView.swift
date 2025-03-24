import SwiftUI

struct ChatListView: View {
	@StateObject private var viewModel = ChatListViewModel()
	
	var body: some View {
		NavigationView {
			List(viewModel.chats) { chat in
				let chatViewModel = ChatViewModel(chat: chat)
				NavigationLink(destination: ChatView(viewModel: chatViewModel, chat: chat)) {
					Text(chat.name)
				}
			}
			.navigationTitle("Chats")
		}
	}
}
