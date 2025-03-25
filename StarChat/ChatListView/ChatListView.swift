import SwiftUI

struct ChatListView: View {
	@StateObject private var viewModel = ChatListViewModel()
	
	var body: some View {
		NavigationView {
			List(viewModel.filteredChat) { chat in
				let chatViewModel = ChatViewModel(chat: chat)
				NavigationLink(destination: ChatView(viewModel: chatViewModel, chat: chat)) {
					Text(chat.name)
				}
			}
			.searchable(text: $viewModel.searchChat, prompt: "Chat suchen")
			.navigationTitle("Chats")
		}
	}
}
