public enum ValidationRules {
}

// MARK: - Presence

extension ValidationRules {

    public struct Presence<Name, Value, Failure>: ValidationRule, ValidationFailureProvider {

        public var name: Name
        public var value: Value?
        public var failure: (Name) -> Failure

        public init(name: Name, value: Value?, failure: @escaping (Name) -> Failure) {
            self.name = name
            self.value = value
            self.failure = failure
        }

        public func validate() -> Bool {
            return value != nil
        }
    }
}

// MARK: For Collections

extension ValidationRules.Presence where Value: Collection {

    public func validate() -> Bool {
        return !(value?.isEmpty ?? true)
    }
}

// MARK: - Length

extension ValidationRules {

    public struct Length<Name, Value, Failure, Range>: ValidationRule, ValidationFailureProvider where Value: Collection, Range: RangeExpression, Range.Bound == Int {

        public var name: Name
        public var value: Value?
        public var range: Range
        public var failure: (Name) -> Failure

        public init(name: Name, value: Value?, range: Range, failure: @escaping (Name) -> Failure) {
            self.name = name
            self.value = value
            self.range = range
            self.failure = failure
        }

        public func validate() -> Bool {
            return range ~= value?.count ?? 0
        }
    }
}

// MARK: - Similarity

extension ValidationRules {

    public struct Similarity<Name1, Name2, Value: Equatable, Failure>: ValidationRule, ValidationFailureProvider {

        public var name: (Name1, Name2)
        public var value: (Value, Value)
        public var failure: ((Name1, Name2)) -> Failure

        public init(name: Name, value: (Value, Value), failure: @escaping ((Name1, Name2)) -> Failure) {
            self.name = name
            self.value = value
            self.failure = failure
        }

        public func validate() -> Bool {
            return value.0 == value.1
        }
    }
}

// MARK: - Confirmation

extension ValidationRules {

    public struct Confirmation<Name1, Name2, Value: Equatable, Failure>: ValidationRule {

        public enum FailureReason {
            case none(Name1)
            case unmatched(Name1, Name2)
        }

        public var presence: Presence<Name1, Value, FailureReason>
        public var similarity: Similarity<Name1, Name2, Value?, FailureReason>

        public var failure: (FailureReason) -> Failure

        public func validateWithFailure() -> Failure? {
            return (presence.validateWithFailure() ?? similarity.validateWithFailure()).map(failure)
        }
    }
}

// MARK: Convenience Initializer

extension ValidationRules.Confirmation {

    public init(name: Name1, confirmationName: Name2, value: Value?, confirmationValue: Value?, failure: @escaping (FailureReason) -> Failure) {
        self.init(
            presence: .init(name: name, value: value) { .none($0) },
            similarity: .init(name: (name, confirmationName), value: (value, confirmationValue)) { .unmatched($0, $1) },
            failure: failure
        )
    }
}
