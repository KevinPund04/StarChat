import Foundation

struct ChatMessage: Identifiable, Codable {
	let id: UUID
	let text: String
	let isUser: Bool
	
	init(id: UUID = UUID(), text: String, isUser: Bool) {
		self.id = id
		self.text = text
		self.isUser = isUser
	}
}
