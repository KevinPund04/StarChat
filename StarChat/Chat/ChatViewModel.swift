import SwiftUI

class ChatViewModel: ObservableObject {
	@Published var chats: [Chat] = []
	@Published var newMessage: String = ""
	private let apiKey = "AIzaSyAKkPfT8MXfV3e7X0E5qDox1PGKdZqsT5I"
	
	init() {
		loadChats()
	}
	
	func sendMessage(_ userMessage: String, for chat: Chat) {
		let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)"
		
		var chatHistory: [[String: Any]] = []
		let systemPrompt = "Du bist \(chat.name). \(chat.persona)"
		
		chatHistory.append([
			"role": "model",
			"parts": [["text": systemPrompt]]
		])
		
		chatHistory.append(contentsOf: chat.messages.map { message in
			[
				"role": message.isUser ? "user" : "model",
				"parts": [["text": message.text]]
			]
		})
		
		chatHistory.append([
			"role": "user",
			"parts": [["text": userMessage]]
		])
		
		let requestBody: [String: Any] = ["contents": chatHistory]
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
			print("❌ Fehler: JSON konnte nicht erstellt werden")
			return
		}
		
		var request = URLRequest(url: URL(string: endpoint)!)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		
		DispatchQueue.main.async {
			let userMessageObj = Message(text: userMessage, isUser: true)
			if let index = self.chats.firstIndex(where: { $0.id == chat.id }) {
				self.chats[index].messages.append(userMessageObj)
				self.saveChat(self.chats[index])
			}
		}
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print("Fehler: \(error?.localizedDescription ?? "Unbekannt")")
				return
			}
			
			if let rawResponse = String(data: data, encoding: .utf8) {
				print("Raw API Response: \(rawResponse)")
			}
			
			do {
				let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
				if let botText = decodedResponse.candidates.first?.content.parts.first?.text {
					DispatchQueue.main.async {
						let botMessage = Message(text: botText, isUser: false)
						if let index = self.chats.firstIndex(where: { $0.id == chat.id }) {
							self.chats[index].messages.append(botMessage)
							self.saveChat(self.chats[index])
						}
					}
				}
			} catch {
				print("Fehler beim Decodieren der Antwort: \(error)")
			}
		}.resume()
	}
	
	func loadChats() {
		self.chats = ChatStorage.shared.loadAllChats()
	}
	
	func saveChat(_ chat: Chat) {
		ChatStorage.shared.saveChat(chat)
	}
}
