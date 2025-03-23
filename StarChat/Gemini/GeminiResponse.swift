struct GeminiResponse: Decodable {
	struct Candidate: Decodable {
		struct Content: Decodable {
			struct Part: Decodable {
				let text: String
			}
			let parts: [Part]
		}
		let content: Content
	}
	let candidates: [Candidate]
}
