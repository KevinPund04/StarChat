import Foundation

struct Chat: Identifiable {
	let id = UUID()
	let name: String
	let persona: String
	var messages: [Message]
}
