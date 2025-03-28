import SwiftUI

struct MainTabView: View {
	@State private var isTabBarHidden = false
	var body: some View {
		TabView {
			ChatListView()
				.tabItem {
					Image(systemName: "message.fill")
					Text("Chats")
				}
			
			StoreView()
				.tabItem {
					Image(systemName: "cart.fill")
					Text("Store")
				}
		}
		.environment(\.isTabBarHidden, $isTabBarHidden)
	}
}
