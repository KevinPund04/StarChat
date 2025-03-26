import SwiftUI

class MessageViewModel: ObservableObject {
	@Published var message: Message
	
	init(message: Message) {
		self.message = message.text.isEmpty ? Message(text: "Keine Nachricht", isUser: false) : message
	}
	
	let cornerRadius: CGFloat = 10
	let textMaxWidth: CGFloat = 250
	let backgroundColorOpacity: CGFloat = 0.7
}
