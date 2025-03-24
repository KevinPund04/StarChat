import Foundation

class ChatStorage {
	static let shared = ChatStorage()
	private let fileManager = FileManager.default
	private var chatsDirectory: URL {
		fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Chats")
	}
	
	private init() {
		createChatsDirectory()
	}
	
	private func createChatsDirectory() {
		if !fileManager.fileExists(atPath: chatsDirectory.path) {
			do {
				try fileManager.createDirectory(at: chatsDirectory, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print("❌ Fehler beim Erstellen des Chats-Ordners: \(error.localizedDescription)")
			}
		}
	}
	
	func saveChat(_ chat: Chat) {
		let fileURL = chatsDirectory.appendingPathComponent("\(chat.name).json")
		do {
			let data = try JSONEncoder().encode(chat)
			try data.write(to: fileURL)
		} catch {
			print("Fehler beim Speichern des Chats: \(error.localizedDescription)")
		}
	}
	
	func loadChat(name: String) -> Chat? {
		let fileURL = chatsDirectory.appendingPathComponent("\(name).json")
		guard fileManager.fileExists(atPath: fileURL.path) else {
			return nil
		}
		
		do {
			let data = try Data(contentsOf: fileURL)
			return try JSONDecoder().decode(Chat.self, from: data)
		} catch {
			print("Fehler beim Laden des Chats: \(error.localizedDescription)")
			return nil
		}
	}
	
	func loadAllChats() -> [Chat] {
		var chats: [Chat] = []
		
		guard let resourcePath = Bundle.main.resourcePath else {
			print("Konnte den Ressourcenpfad nicht finden.")
			return []
		}
		
		do {
			let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
			
			for file in files where file.hasSuffix(".json") {
				let fileName = file.replacingOccurrences(of: ".json", with: "")
				
				if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
					do {
						let data = try Data(contentsOf: fileURL)
						let chat = try JSONDecoder().decode(Chat.self, from: data)
						chats.append(chat)
					}
					catch {
						print("Fehler beim Laden von \(file): \(error.localizedDescription)")
					}
				} else {
					print("Datei \(file) konnte nicht im Bundle gefunden werden.")
				}
			}
		} catch {
			print("Fehler beim Durchsuchen des Resource-Ordners: \(error.localizedDescription)")
		}
		
		return chats
	}
}
