import Foundation
import SharedKernel

public enum ProfileRoute: Hashable, Codable, Sendable, CaseIterable {
    case profile(User.ID)
    case settings

    public static var allCases: [ProfileRoute] {
        [.profile("sample"), .settings]
    }
}
