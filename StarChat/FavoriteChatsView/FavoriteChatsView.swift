import SwiftUI

struct FavoriteChatsView: View {
	
	@StateObject var viewModel = FavoriteChatsViewModel()
	
	var body: some View {
		NavigationStack {
			List(viewModel.favoriteChats) { chat in
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
				.contextMenu {
					Button(role: .destructive) {
						viewModel.clearChat(chatName: chat.name)
						viewModel.loadFavoriteChats()
					} label: {
						Label("Chatverlauf löschen", systemImage: "trash")
					}
				}
			}
			.navigationTitle("Favoriten")
			.onAppear {
				viewModel.loadFavoriteChats()
			}
		}
	}
}
