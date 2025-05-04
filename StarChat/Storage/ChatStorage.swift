import Foundation

class ChatStorage {
	static let shared = ChatStorage()
	private let fileManager = FileManager.default
	private var chatsDirectory: URL {
		fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Chats")
	}
	
	private init() {
		createChatsDirectory()
		copyChatsToDocumentsIfNeeded()
	}
	
	private func createChatsDirectory() {
		if !fileManager.fileExists(atPath: chatsDirectory.path) {
			do {
				try fileManager.createDirectory(at: chatsDirectory, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print("Fehler beim Erstellen des Chats-Ordners: \(error.localizedDescription)")
			}
		}
	}
	
	private func copyChatsToDocumentsIfNeeded() {
		do {
			// Hole die vorhandenen Dateien im Dokumentenverzeichnis
			let existingFiles = try fileManager.contentsOfDirectory(atPath: chatsDirectory.path)

			// Hole den Resources-Pfad
			guard let resourcesPath = Bundle.main.resourcePath else {
				print("Konnte den Resources-Pfad nicht finden.")
				return
			}

			// Hole alle JSON-Dateien aus den Ressourcen
			let resourcesFiles = try fileManager.contentsOfDirectory(atPath: resourcesPath).filter { $0.hasSuffix(".json") }

			for file in resourcesFiles {
				let sourceURL = URL(fileURLWithPath: resourcesPath).appendingPathComponent(file)
				let destinationURL = chatsDirectory.appendingPathComponent(file)

				// Überprüfen, ob die Datei bereits existiert
				if existingFiles.contains(file) {
					print("\(file) existiert bereits im Dokumentenverzeichnis.")
					continue
				}

				// Datei kopieren
				do {
					try fileManager.copyItem(at: sourceURL, to: destinationURL)
					print("Erfolgreich kopiert: \(file)")
				} catch {
					print("Fehler beim Kopieren von \(file): \(error.localizedDescription)")
				}
			}
		} catch {
			print("Fehler beim Überprüfen der Dateien: \(error.localizedDescription)")
		}
	}


	private func copyChatsFromResourcesIfNeeded() {
		
		guard let resourcesPath = Bundle.main.resourcePath else { return }
		do {
			let files = try fileManager.contentsOfDirectory(atPath: resourcesPath)
			for file in files where file.hasSuffix(".json") {
				let destinationURL = chatsDirectory.appendingPathComponent(file)
				if !fileManager.fileExists(atPath: destinationURL.path) {
					let sourcesURL = URL(fileURLWithPath: resourcesPath).appendingPathComponent(file)
					do {
						try fileManager.copyItem(at: sourcesURL, to: destinationURL)
					} catch {
						print("Fehler beim Kopieren von \(file): \(error.localizedDescription)")
					}
				}
			}
		} catch {
			print("Fehler beim Durchsuchen des Resources-Ordners: \(error.localizedDescription)")
		}
	}
	
	func saveChat(_ chat: Chat) {
		
		let safeFileName = chat.name.replacingOccurrences(of: " ", with: "_")
		
		let fileURL = chatsDirectory.appendingPathComponent("\(safeFileName).json")
//		print("Speichert Chat unter \(fileURL.path)")
		
		do {
			let data = try JSONEncoder().encode(chat)
			try data.write(to: fileURL)
//			print("Chat gespeichert für \(chat.name)")
		} catch {
			print("Fehler beim Speichern des Chats: \(error.localizedDescription)")
		}
	}
	
	func loadChat(name: String) -> Chat? {
		
		let safeFileName = name.replacingOccurrences(of: " ", with: "_")
		
		let fileURL = chatsDirectory.appendingPathComponent("\(safeFileName).json")
		
		print("📂 Lade Chat von: \(fileURL.path)") // Debug-Info
		
		guard fileManager.fileExists(atPath: fileURL.path) else {
			print("❌ Datei nicht gefunden: \(fileURL.path)")
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
		var loadedChatNames = Set<String>()

		let allFiles: [URL]
		
		do {
			let bundleFiles = try fileManager.contentsOfDirectory(atPath: Bundle.main.resourcePath!)
				.filter { $0.hasSuffix(".json") }
				.compactMap { Bundle.main.url(forResource: $0.replacingOccurrences(of: ".json", with: ""), withExtension: "json") }
			
			let documentFiles = try fileManager.contentsOfDirectory(at: chatsDirectory, includingPropertiesForKeys: nil)
			
			// Nur die Dateien aus dem Dokumentenordner nehmen, falls sie schon existieren
			let documentFileNames = Set(documentFiles.map { $0.lastPathComponent })
			
			// Falls eine Datei im Dokumenten-Ordner existiert, die Bundle-Version ignorieren
			let filteredBundleFiles = bundleFiles.filter { !documentFileNames.contains($0.lastPathComponent) }
			
			allFiles = filteredBundleFiles + documentFiles
		} catch {
			print("Fehler beim Durchsuchen der Verzeichnisse: \(error.localizedDescription)")
			return []
		}
		
		for fileURL in allFiles {
			do {
				let data = try Data(contentsOf: fileURL)
				let chat = try JSONDecoder().decode(Chat.self, from: data)
//				print("\(chat.name) - \(chat.isFavorite)")
				
				if !loadedChatNames.contains(chat.name) {
					chats.append(chat)
					loadedChatNames.insert(chat.name)
				}
			} catch {
				print("Fehler beim Laden von \(fileURL.lastPathComponent): \(error.localizedDescription)")
			}
		}
		
		return chats
	}
	
	func clearChatHistory(for chatName: String) {
		guard var chat = loadChat(name: chatName) else {
			print("Chat nicht gefunden: \(chatName)")
			return
		}
		
		chat.messages = []
		saveChat(chat)
	}

}
