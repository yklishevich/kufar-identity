#if DEBUG
import Foundation
import SessionInterface
import SharedKernel

/// #if DEBUG вокруг ВСЕГО содержимого — намеренно.
///
/// В SPM нет `.when(configuration: .debug)`: условия работают по платформам
/// и трейтам, поэтому этот таргет линкуется и в релиз. В релизе от него
/// остаётся пустой модуль.
///
/// Гарантия от утечки в прод: правило на ревью — `import *Testing`
/// вне тестов и вне `#if DEBUG` есть красный флаг.
public final class StubSession: SessionStore, @unchecked Sendable {
    private let lock = NSLock()
    private var storage: SessionState
    private let stream: AsyncStream<SessionState>
    private let continuation: AsyncStream<SessionState>.Continuation

    public init(_ initial: SessionState = .signedIn("42")) {
        storage = initial
        // Поток создаётся в init, а не лениво: иначе первое событие
        // теряется, если restore() успел выполниться до подписки.
        (stream, continuation) = AsyncStream.makeStream(of: SessionState.self)
    }

    public var state: SessionState {
        lock.lock(); defer { lock.unlock() }
        return storage
    }

    public var updates: AsyncStream<SessionState> { stream }

    public func restore() async {
        emit(state)
    }

    public func signOut() {
        emit(.signedOut)
    }

    public func emit(_ new: SessionState) {
        lock.lock()
        storage = new
        lock.unlock()
        continuation.yield(new)
    }
}
#endif
