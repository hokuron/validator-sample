public protocol Validatable {

    associatedtype Failure

    func validateWithFailure() -> Failure?
}

extension Validatable {

    public func validate() -> Bool {
        validateWithFailure() == nil
    }
}

public protocol ValidationRule: Validatable {

    func validate() -> Bool
}

public protocol ValidationFailureProvider where Self: ValidationRule {

    associatedtype Name

    var name: Name { get }
    var failure: (Name) -> Failure { get }
}

extension ValidationRule where Self: ValidationFailureProvider {

    public func validateWithFailure() -> Failure? {
        return validate() ? nil : failure(name)
    }
}
