import SwiftUI
import AuthInterface
import SessionInterface
import DesignComponents
import DesignTokens

package struct LoginScreen: View {
    private let session: any SessionStore
    @State private var isWorking = false

    package init(session: any SessionStore) {
        self.session = session
    }

    package var body: some View {
        VStack(spacing: Spacing.l) {
            Spacer()
            Text("Kufar").font(.largeTitle.weight(.bold))
            Text("Демо архитектуры")
                .foregroundStyle(Palette.secondaryText)

            PrimaryButton("Войти", systemImage: "person.badge.key") {
                isWorking = true
                Task {
                    await session.restore()
                    isWorking = false
                }
            }
            .disabled(isWorking)
            .padding(.horizontal, Spacing.xl)
            Spacer()
        }
    }
}

struct ReauthSheet: View {
    private let session: any SessionStore

    init(session: any SessionStore) {
        self.session = session
    }

    var body: some View {
        SectionCard {
            Text("Сессия истекла").font(Typography.title)
            PrimaryButton("Войти снова", systemImage: "arrow.clockwise") {
                Task { await session.restore() }
            }
        }
        .padding()
    }
}

package struct AuthDestinations: ViewModifier {
    private let session: any SessionStore

    package init(session: any SessionStore) {
        self.session = session
    }

    package func body(content: Content) -> some View {
        content.navigationDestination(for: AuthRoute.self) { route in
            switch route {
            case .login:  LoginScreen(session: session)
            case .reauth: ReauthSheet(session: session)
            }
        }
    }
}
