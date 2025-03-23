import SwiftUI

class ChatListViewModel: ObservableObject {
	@Published var chats: [Chat] = []
	
	init() {
		loadChats()
	}
	
	func loadChats() {
		self.chats = ChatStorage.shared.loadAllChats()
	}
	
	func addChat(name: String, persona: String) {
		let newChat = Chat(name: name, persona: persona)
		chats.append(newChat)
		ChatStorage.shared.saveChat(newChat)
	}
}
