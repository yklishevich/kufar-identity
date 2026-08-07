import Foundation
import SessionInterface
import NetworkingInterface
import SharedKernel

/// Реализация SessionStore. В настоящем проекте — Keychain плюс refresh токена.
/// Импортируется только таргетом Auth: ни одна фича её не видит.
package final class KeychainSessionStore: SessionStore, @unchecked Sendable {
    private let lock = NSLock()
    private var storage: SessionState = .unknown
    private let stream: AsyncStream<SessionState>
    private let continuation: AsyncStream<SessionState>.Continuation

    package init(client: any HTTPPerforming) {
        _ = client
        (stream, continuation) = AsyncStream.makeStream(of: SessionState.self)
    }

    package var state: SessionState {
        lock.lock(); defer { lock.unlock() }
        return storage
    }

    package var updates: AsyncStream<SessionState> { stream }

    package func restore() async {
        try? await Task.sleep(for: .milliseconds(400))
        emit(.signedIn("u-1"))
    }

    package func signOut() {
        emit(.signedOut)
    }

    package func accessToken() -> String? {
        state.userID.map { "demo-token-\($0)" }
    }

    private func emit(_ new: SessionState) {
        lock.lock()
        storage = new
        lock.unlock()
        continuation.yield(new)
    }
}

/// Реализует протокол, объявленный в Networking — уровнем НИЖЕ.
/// Зависимость сборки идёт вниз, вызов в рантайме — вверх.
/// Компилятор видит только стрелку вниз.
package struct AuthInterceptor: RequestInterceptor {
    private let token: @Sendable () -> String?

    package init(token: @escaping @Sendable () -> String?) {
        self.token = token
    }

    package func adapt(_ request: URLRequest) async throws -> URLRequest {
        var request = request
        if let token = token() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    package func retry(_ request: URLRequest, dueTo error: any Error) async -> RetryDecision {
        .giveUp
    }
}
