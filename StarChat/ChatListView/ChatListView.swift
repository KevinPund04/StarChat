import SwiftUI

struct ChatListView: View {
	@StateObject private var viewModel = ChatListViewModel()
	@Environment(\.isTabBarHidden) private var isTabBarHidden

	var body: some View {
		NavigationStack {
			chatListView()
				.searchable(text: $viewModel.searchChat, prompt: "Chat suchen")
				.navigationTitle("Chats")
				.onAppear { viewModel.loadChats() }
		}
	}

	@ViewBuilder
	private func chatListView() -> some View {
		List(viewModel.filteredChat) { chat in
			ChatRowView(chat: chat, viewModel: viewModel)
		}
	}
}
