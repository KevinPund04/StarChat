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
			print("❌ Fehler beim Speichern des Chats: \(error.localizedDescription)")
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
			print("❌ Fehler beim Laden des Chats: \(error.localizedDescription)")
			return nil
		}
	}
	
	func loadAllChats() -> [Chat] {
		do {
			let files = try fileManager.contentsOfDirectory(at: chatsDirectory, includingPropertiesForKeys: nil)
			return files.compactMap { fileURL in
				guard let data = try? Data(contentsOf: fileURL) else { return nil }
				return try? JSONDecoder().decode(Chat.self, from: data)
			}
		} catch {
			print("❌ Fehler beim Laden aller Chats: \(error.localizedDescription)")
			return []
		}
	}
}
