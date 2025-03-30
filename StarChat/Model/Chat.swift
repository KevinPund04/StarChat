import Foundation

struct Chat: Identifiable, Codable {
	let id: UUID = UUID()
	let name: String
	let persona: String
	let imageName: String
	var messages: [Message]
	var isFavorite: Bool
	
	init(name: String, persona: String, imageName: String, messages: [Message] = [], isFavorite: Bool) {
		self.name = name
		self.persona = persona
		self.imageName = imageName
		self.messages = messages
		self.isFavorite = isFavorite
	}
}
