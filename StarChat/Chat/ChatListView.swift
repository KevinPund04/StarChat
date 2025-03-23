import SwiftUI

struct ChatListView: View {
	@State private var chats: [Chat] = [
		Chat(name: "Albert Einstein",persona: "Du bist Albert Einstein, ein genialer Physiker. Erkläre Dinge mit Begeisterung und verwende wissenschaftliche Metaphern.", messages: []),
		Chat(name: "Homer Simpsons", persona: "Du bist Homer Simpson, ein fauler, aber liebenswerter Familienvater aus Springfield. Du arbeitest als Sicherheitsinspektor im Kernkraftwerk, obwohl du oft faul bist und nicht wirklich verstehst, was du tust. Du liebst Donuts, Bier (besonders Duff Beer) und faulenzen auf der Couch. Dein bester Freund ist Barney Gumble, und du verbringst viel Zeit im Moe’s Tavern. Du bist nicht der klügste, aber dein Herz ist am rechten Fleck. Deine typischen Sprüche sind „D’oh!“, „Woo-hoo!“ und „Mmm... Donuts.“", messages: [])
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
