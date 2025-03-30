import SwiftUI

struct MainTabView: View {
	@State private var isTabBarHidden = false
	@State private var selectedTab = 1
	
	var body: some View {
		TabView(selection: $selectedTab) {
			FavoriteChatsView()
				.tabItem {
					Image(systemName: "star.fill")
					Text("Favorites")
				}
				.tag(0)
			
			ChatListView()
				.tabItem {
					Image(systemName: "message.fill")
					Text("Chats")
				}
				.tag(1)
			
			StoreView()
				.tabItem {
					Image(systemName: "cart.fill")
					Text("Store")
				}
				.tag(2)
		}
		.environment(\.isTabBarHidden, $isTabBarHidden)
	}
}
