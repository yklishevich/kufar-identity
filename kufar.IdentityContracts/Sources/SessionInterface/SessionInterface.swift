import Foundation
import SharedKernel

/// Из того, что все зависят от авторизации, НЕ следует, что все зависят от фичи Auth.
///
/// Красный флаг на ревью: `import AuthInterface` внутри таба ради текущего
/// пользователя. Это не Auth — это сессия, и она здесь.
public enum SessionState: Equatable, Sendable {
    case unknown
    case signedOut
    case signedIn(User.ID)

    public var userID: User.ID? {
        if case .signedIn(let id) = self { return id }
        return nil
    }
}

public protocol SessionStore: AnyObject, Sendable {
    var state: SessionState { get }
    var updates: AsyncStream<SessionState> { get }
    func restore() async
    func signOut()
}
