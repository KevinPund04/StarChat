import SwiftUI

struct ChatListView: View {
	@StateObject private var viewModel = ChatListViewModel()
	
	var body: some View {
		NavigationView {
			List(viewModel.chats) { chat in
				NavigationLink(destination: ChatView(chat: chat)) {
					Text(chat.name)
				}
			}
			.navigationTitle("Chats")
		}
	}
}
