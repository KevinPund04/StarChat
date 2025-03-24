import Foundation

struct Chat: Identifiable, Codable {
	let id: UUID = UUID()
	let name: String
	let persona: String
	var messages: [Message]
	
	init(name: String, persona: String, messages: [Message] = []) {
		self.name = name
		self.persona = persona
		self.messages = messages
	}
}
