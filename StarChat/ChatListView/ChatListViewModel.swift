import SwiftUI

class ChatListViewModel: ObservableObject {
	@Published var chats: [Chat] = []
	
	init() {
		loadChats()
	}
	
	func loadChats() {
		self.chats = ChatStorage.shared.loadAllChats()
	}
}
