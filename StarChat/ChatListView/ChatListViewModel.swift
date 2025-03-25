import SwiftUI

class ChatListViewModel: ObservableObject {
	@Published var chats: [Chat] = []
	@Published var searchChat: String = ""
	
	
	var filteredChat: [Chat] {
		if searchChat.isEmpty {
			return chats.sorted { $0.name < $1.name }
		} else {
			return chats
				.filter { $0.name.localizedCaseInsensitiveContains(searchChat) }
				.sorted { $0.name < $1.name }
		}
	}
	
	init() {
		loadChats()
	}
	
	func loadChats() {
		self.chats = ChatStorage.shared.loadAllChats()
	}
}
