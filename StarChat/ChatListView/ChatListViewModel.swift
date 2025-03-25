import SwiftUI

class ChatListViewModel: ObservableObject {
	@Published var chats: [Chat] = []
	
	var sortedChats: [Chat] {
		chats.sorted { $0.name < $1.name }
	}
	
	init() {
		loadChats()
	}
	
	func loadChats() {
		self.chats = ChatStorage.shared.loadAllChats()
	}
}
