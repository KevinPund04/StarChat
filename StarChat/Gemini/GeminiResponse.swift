struct GeminiResponse: Decodable {
	struct Candidate: Decodable {
		struct Content: Decodable {
			struct Part: Decodable {
				let text: String
			}
			let parts: [Part]					//parts ist ein Array, da eine Antwort aus mehreren Teilen bestehen kann.
		}
		let content: Content					//content erhält die eigentliche Antwort von der API.
	}
	let candidates: [Candidate]					//liefert die möglichen Antworten von der API. Obwohl in der Regel nur eine Antwort zurück kommt, kann es später mal mehrer erhalten.
}
