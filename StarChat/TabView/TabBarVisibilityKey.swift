import SwiftUI

private struct TabBarVisibilityKey: EnvironmentKey {
	static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
	var isTabBarHidden: Binding<Bool> {
		get { self[TabBarVisibilityKey.self] }
		set { self[TabBarVisibilityKey.self] = newValue}
	}
}
