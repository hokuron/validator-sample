public struct AnyValidatable<Failure>: Validatable {

    private class AnyBox<Failure> {
        func validateWithFailureReason() -> Failure? { fatalError() }
    }

    private final class Box<T: Validatable>: AnyBox<T.Failure> {
        let base: T

        init(_ base: T) {
            self.base = base
        }

        override func validateWithFailureReason() -> T.Failure? {
            base.validateWithFailure()
        }
    }

    private let base: AnyBox<Failure>

    public init<T: Validatable>(_ base: T) where T.Failure == Failure {
        self.base = Box(base)
    }

    public func validateWithFailure() -> Failure? {
        return base.validateWithFailureReason()
    }
}
