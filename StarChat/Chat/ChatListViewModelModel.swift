import SwiftUI

struct Message: Identifiable {
	let id = UUID()
	let text: String
	let isUser: Bool
}

class ChatViewModel: ObservableObject {
	@Published var messages: [Message] = []
	private let apiKey = "AIzaSyAKkPfT8MXfV3e7X0E5qDox1PGKdZqsT5I"

	func sendMessage(_ userMessage: String, for chat: Chat) {
		let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)"
		
		var chatHistory: [[String: Any]] = []
		
		let systemPrompt = "Du bist \(chat.name). \(chat.persona)"
		chatHistory.append([
			"role": "model",
			"parts": [["text": systemPrompt]]
		])
		
		chatHistory.append(contentsOf: messages.map { message in
			[
			"role": message.isUser ? "user" : "model",
			"parts": [["text": message.text]]
			]
		})
		
		chatHistory.append([
			"role": "user",
			"parts": [["text": userMessage]]
		])
		
		let requestBody: [String: Any] = [
			"contents": chatHistory
		]
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
			print("❌ Fehler: JSON konnte nicht erstellt werden")
			return
		}

		var request = URLRequest(url: URL(string: endpoint)!)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		
		if let jsonString = String(data: jsonData, encoding: .utf8) {
			print("📩 Gesendeter Request: \(jsonString)")
		}
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print("Fehler: \(error?.localizedDescription ?? "Unbekannt")")
				return
			}
			
			// Debug: Gib die API-Antwort als String aus
			if let rawResponse = String(data: data, encoding: .utf8) {
				print("Raw API Response: \(rawResponse)")
			}
			
			do {
				let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
				if let botText = decodedResponse.candidates.first?.content.parts.first?.text {
					DispatchQueue.main.async {
						self.messages.append(Message(text: botText, isUser: false))
					}
				}
			} catch {
				print("Fehler beim Decodieren der Antwort: \(error)")
				
				if let rawResponse = String(data: data, encoding: .utf8) {
					print("📩 Raw API Response: \(rawResponse)")
				}
			}
		}.resume()
		
		DispatchQueue.main.async {
			let userMessageObj = Message(text: userMessage, isUser: true)
			self.messages.append(userMessageObj)
		}
	}
}
