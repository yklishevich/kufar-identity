import SwiftUI
import ProfileInterface
import SessionInterface

package struct ProfileDestinations: ViewModifier {
    private let session: any SessionStore

    package init(session: any SessionStore) {
        self.session = session
    }

    package func body(content: Content) -> some View {
        content.navigationDestination(for: ProfileRoute.self) { route in
            switch route {
            case .profile(let userID):
                ProfileScreen(userID: userID, session: session)
            case .settings:
                SettingsScreen(session: session)
            }
        }
    }
}
