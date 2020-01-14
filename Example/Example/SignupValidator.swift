//
//  SignupValidator.swift
//  Example
//
//  Created by hokuron on 2020/01/12.
//  Copyright © 2020 hokuron. All rights reserved.
//

import Foundation
import Validator

struct SignupValidator<Failure>: Validatable {

    enum FailureReason {

        enum Password {
            case empty, length, confirmation
        }

        case emptyUsername
        case password(Password)
    }

    private let validators: [AnyValidatable<Failure>]

    init(username: String?, password: String?, passwordConfirmation: String?, failure: @escaping (FailureReason) -> Failure) {
        self.validators = [
            AnyValidatable(ValidationRules.Presence(name: (), value: username) { failure(.emptyUsername) }),
            AnyValidatable(ValidationRules.Length(name: (), value: password, range: 8...) { failure(.password(.length)) }),
            AnyValidatable(
                ValidationRules.Confirmation(name: (), confirmationName: (), value: password, confirmationValue: passwordConfirmation) {
                    switch $0 {
                    case .none:
                        return failure(.password(.empty))
                    case .unmatched:
                        return failure(.password(.confirmation))
                    }
                }
            )
        ]
    }

    func validateWithFailure() -> Failure? {
        return validators.lazy.compactMap { $0.validateWithFailure() }.first
    }
}


