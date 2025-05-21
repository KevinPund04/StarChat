import SwiftUI

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel
	@Environment(\.isTabBarHidden) private var isTabBarHidden
	@State private var isImageExpanded = false
	@State private var hasScrolledToBottom = false
	var chat: Chat
	
	var body: some View {
		VStack {
			messageListView()
			messageInputView()
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar(.hidden, for: .tabBar)
		.toolbar { toolbarContent }
		.onAppear { isTabBarHidden.wrappedValue = true }
		.onDisappear { isTabBarHidden.wrappedValue = false }
		.sheet(isPresented: $isImageExpanded) {
			FullScreenImageView(imageName: chat.imageName)
		}
	}
	
	@ViewBuilder
	private func messageListView() -> some View {
		ScrollViewReader { proxy in
			ScrollView {
				LazyVStack(alignment: .leading, spacing: viewModel.lazyVStackspacing) {
					ForEach(viewModel.chat.messages) { message in
						let messageViewModel = MessageViewModel(message: message)
						MessageView(viewModel: messageViewModel)
							.id(message.id)
							.contextMenu {
								Button(action: {
									UIPasteboard.general.string = message.text
								}) {
									Label("Kopieren", systemImage: "doc.on.doc")
								}
							}
					}
				}
				.padding()
				.onAppear {
					if !hasScrolledToBottom {
						DispatchQueue.main.async {
								proxy.scrollTo(viewModel.chat.messages.last?.id, anchor: .bottom)
								hasScrolledToBottom = true
						}
					}
				}
			}
			.onChange(of: viewModel.chat.messages.count) {
				withAnimation {
					proxy.scrollTo(viewModel.chat.messages.last?.id, anchor: .top)
				}
			}
		}
	}
	
	@ViewBuilder
	private func messageInputView() -> some View {
		Divider()
		HStack {
			TextField("Nachricht eingeben...", text: $viewModel.newMessage)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding()
			Button(action: sendMessage) {
				Image(systemName: "paperplane.fill")
					.foregroundColor(.blue)
					.padding()
			}
		}
		.padding(.horizontal)
	}
	
	private func sendMessage() {
		if viewModel.newMessage.isEmpty { return }
		viewModel.sendMessage(viewModel.newMessage)
		viewModel.newMessage = ""
	}
	
	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			HStack {
				Button(action: { isImageExpanded = true }) {
					Image(chat.imageName)
						.resizable()
						.scaledToFit()
						.frame(width: 40, height: 40)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.gray, lineWidth: 1))
				}
				Text(viewModel.chat.name)
					.font(.headline)
				Spacer()
			}
		}
		ToolbarItem(placement: .navigationBarTrailing) {
			Button(action: { viewModel.toggleFavorite() }) {
				Image(systemName: viewModel.chat.isFavorite ? "star.fill" : "star")
					.foregroundColor(.yellow)
			}
		}
	}
	struct FullScreenImageView: View {
		let imageName: String
		@Environment(\.dismiss) var dismiss  // Ermöglicht das Schließen des Sheets
		
		var body: some View {
			ZStack {
				Color.black.ignoresSafeArea()
				Image(imageName)
					.resizable()
					.scaledToFit()
					.padding()
					.onTapGesture { dismiss() }  // Tippen, um das Bild zu schließen
			}
		}
	}
}
