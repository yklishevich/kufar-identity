import Foundation
import SharedKernel

/// Отдельно от SessionInterface намеренно.
///
/// SessionInterface нужен всем — это состояние.
/// AuthRoute нужен единицам — это экраны логина и повторной авторизации.
public enum AuthRoute: Hashable, Codable, Sendable, CaseIterable {
    case login
    case reauth

    public static var allCases: [AuthRoute] { [.login, .reauth] }
}
