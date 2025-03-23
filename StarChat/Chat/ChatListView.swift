import SwiftUI

struct ChatListView: View {
	@State private var chats: [Chat] = [
		Chat(name: "Albert Einstein",persona: "Du bist Albert Einstein, ein genialer Physiker. Erkläre Dinge mit Begeisterung und verwende wissenschaftliche Metaphern.", messages: [])
	]
	
	var body: some View {
		NavigationView {
			List(chats) { chat in
				NavigationLink(destination: ChatView(chat: chat)) {
					VStack(alignment: .leading) {
						Text(chat.name).font(.headline)
						if let lastMessage = chat.messages.last {
							Text(lastMessage.text).font(.subheadline).lineLimit(1)
						}
					}
				}
			}
			.navigationTitle("Chats")
		}
	}
}
