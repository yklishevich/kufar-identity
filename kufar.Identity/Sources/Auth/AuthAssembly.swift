import SwiftUI
import AuthData
import AuthUI
import SessionInterface
import NetworkingInterface

/// Фасад вместо реэкспорта.
///
/// KeychainSessionStore объявлен в AuthData, но композиция импортирует Auth.
/// `@_exported import AuthData` тоже сработал бы, но подчёркнутый атрибут
/// неровно ведёт себя в module interfaces. Фабрика лучше: возвращает
/// `any SessionStore`, и переезд с кейчейна не трогает AppComposition.
public enum AuthAssembly {

    public static func makeSession(client: any HTTPPerforming) -> any SessionStore {
        KeychainSessionStore(client: client)
    }

    public static func makeInterceptor(
        token: @escaping @Sendable () -> String?
    ) -> any RequestInterceptor {
        AuthInterceptor(token: token)
    }

    public static func makeDestinations(session: any SessionStore) -> some ViewModifier {
        AuthDestinations(session: session)
    }

    @MainActor
    public static func makeLoginScreen(session: any SessionStore) -> some View {
        LoginScreen(session: session)
    }
}
