//
//  SignupViewModel.swift
//  Example
//
//  Created by hokuron on 2020/01/12.
//  Copyright © 2020 hokuron. All rights reserved.
//

import Foundation

final class SignupViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var passwordConfirmation = ""

    @Published var modalMessage = ""

    @Published var usernameError = ""
    @Published var passwordError = ""

    func validate() {
        // TODO: `FailureReason`を保持する`Identifierable`なstructを`Failureとして指定する。そのstructは`Alert`を返すcomputed propを保持する。
        let validator = SignupValidator(username: username, password: password, passwordConfirmation: passwordConfirmation) { a in a }
        switch validator.validateWithFailure() {
        case
        }
    }

    func validateForModal() {
        let validator = SignupValidator(username: username, password: password, passwordConfirmation: passwordConfirmation) {
            return $0.localizedDescription
        }

        modalMessage = validator.validateWithFailure() ?? ""
    }
}

extension SignupValidator.FailureReason: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return NSLocalizedString("SIGNUP_ERROR_USERNAME_PRESENCE", comment: "")
        case .password(.empty):
            return NSLocalizedString("SIGNUP_ERROR_PASSWORD_PRESENCE", comment: "")
        case .password(.length):
            return NSLocalizedString("SIGNUP_ERROR_PASSWORD_LENGTH", comment: "")
        case .password(.confirmation):
            return NSLocalizedString("SIGNUP_ERROR_PASSWORD_CONFIRMATION", comment: "")
        }
    }
}
