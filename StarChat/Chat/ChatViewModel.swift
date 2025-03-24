import SwiftUI

class ChatViewModel: ObservableObject {
	@Published var chat: Chat
	@Published var newMessage: String = ""
	
	private let apiKey = "key"
	
	init(chat: Chat) {
		self.chat = chat
	}
	
	func sendMessage(_ userMessage: String) {
		let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)"
		

		var chatHistory: [[String: Any]] = []
		let systemPrompt = "Du bist \(chat.name). \(chat.persona)"
		//MARK: - chatHistory enthält die gesamte Unterhaltung
		
		
		chatHistory.append([
			"role": "model",
			"parts": [["text": systemPrompt]]
		])
		//MARK: - Jede Nachricht wird als user oder model (KI) gespeichert. Im parts-array steht dann die dazugehörige Nachricht. systemPrompt sagt wie sich die KI verhalten soll.
		
		chatHistory.append(contentsOf: chat.messages.map { message in
			[
				"role": message.isUser ? "user" : "model",
				"parts": [["text": message.text]]
			]
		})
		//MARK: - Fügt die Nachricht in das chatHistory-array hinzu.
		
		
		chatHistory.append([
			"role": "user",
			"parts": [["text": userMessage]]
		])
		//MARK: - Hier wird die Nachricht von den User am ende hinzugefügt. So weis sie KI auf welche Nachricht Sie antworten muss.
		
		
		let requestBody: [String: Any] = ["contents": chatHistory]
	
		guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
			print("Fehler: JSON konnte nicht erstellt werden")
			return
		}
		//MARK: - der requestBody (Dictionary) wird in JSON umgewandelt. Die API kann nur JSON-Dateien bearbeiten und keine Dictionarys oder Arrays von Swift.
		
		var request = URLRequest(url: URL(string: endpoint)!)
		request.httpMethod = "POST"													//POST wird verwendet um Daten zu senden
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")	//Sagt der API, das wir JSON-Daten schicken
		request.httpBody = jsonData													//fügt den eigentlichen Inhalt (JSON-Daten) hinzu
		//MARK: - Ein URL-request wird erstellt um eine Netzwerkanfrage zu konfigurieren, bevor die abgeschickt wird.
		
		
		DispatchQueue.main.async {
			let userMessageObj = Message(text: userMessage, isUser: true)
			self.chat.messages.append(userMessageObj)
			self.saveChat()
		}
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print("Fehler: \(error?.localizedDescription ?? "Unbekannt")")
				return
			}
			
			// 🟢 Debug: Rohdaten als String ausgeben
			if let jsonString = String(data: data, encoding: .utf8) {
				print("📜 Antwort von API: \(jsonString)")
			}
			
			do {
				let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
				if let botText = decodedResponse.candidates.first?.content.parts.first?.text {
					DispatchQueue.main.async {
						let botMessage = Message(text: botText, isUser: false)
						self.chat.messages.append(botMessage)
						self.saveChat()
					}
				}
			} catch {
				print("Fehler beim Decodieren der Antwort: \(error)")
			}
		}.resume()
	}
	
	func saveChat() {
		ChatStorage.shared.saveChat(chat)
	}
}
