import SwiftUI

struct ChatListView: View {
	@StateObject private var viewModel = ChatListViewModel()
	@Environment(\.isTabBarHidden) private var isTabBarHidden
	
	var body: some View {
		NavigationStack {
			List(viewModel.filteredChat) { chat in
				let chatViewModel = ChatViewModel(chat: chat)
				NavigationLink(destination: ChatView(viewModel: chatViewModel, chat: chat)) {
					HStack{
						Image(chat.imageName)
							.resizable()
							.scaledToFit()
							.frame(width: 40, height: 40)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.gray, lineWidth: 1))
						
						Text(chat.name)
					}
				}
			}
			.searchable(text: $viewModel.searchChat, prompt: "Chat suchen")
			.navigationTitle("Chats")
			.onAppear {
				viewModel.loadChats()
			}
		}
	}
}
