import Foundation

struct Chat: Identifiable, Codable {
	let id: UUID
	let name: String
	let persona: String
	var messages: [Message]
	
	init(id: UUID = UUID(), name: String, persona: String, messages: [Message] = []) {
		self.id = id
		self.name = name
		self.persona = persona
		self.messages = messages
	}
}
