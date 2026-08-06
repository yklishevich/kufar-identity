import SwiftUI
import ProfileUI
import SessionInterface
import SharedKernel

public enum ProfileAssembly {

    public static func makeDestinations(session: any SessionStore) -> some ViewModifier {
        ProfileDestinations(session: session)
    }

    @MainActor
    public static func makeProfileScreen(
        userID: User.ID,
        session: any SessionStore
    ) -> some View {
        ProfileScreen(userID: userID, session: session)
    }
}
