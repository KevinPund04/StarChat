import SwiftUI

class FavoriteChatsViewModel: ObservableObject {
	@Published var favoriteChats: [Chat] = []
	
	init() {
		loadFavoriteChats()
	}
	
	func loadFavoriteChats() {
		let allChats = ChatStorage.shared.loadAllChats()
		favoriteChats = allChats.filter({ $0.isFavorite })
//		print("Favorisierte Chats: \(favoriteChats)")
	}
	
	func clearChat(chatName: String) {
		ChatStorage.shared.clearChatHistory(for: chatName)
	}
}
