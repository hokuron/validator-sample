import XCTest
@testable import Validator

final class ValidationRuleTests: XCTestCase {

    static var allTests = presenceTests + lengthTests + confirmationTests
}

// MARK: - Presence

extension ValidationRuleTests {

    func testPresence_notNil() {
        let validator = ValidationRules.Presence(name: "", value: 1) { _ in }
        XCTAssertTrue(validator.validate())
    }

    func testPresene_nil() {
        let v: Int? = nil
        let validator = ValidationRules.Presence(name: "", value: v) { _ in }
        XCTAssertFalse(validator.validate())
    }

    func testPresenceCollection_notEmpty() {
        let validator = ValidationRules.Presence(name: "", value: [1]) { _ in }
        XCTAssertTrue(validator.validate())
    }

    func testPresenceCollection_empty() {
        let validator = ValidationRules.Presence(name: "", value: [Int]()) { _ in }
        XCTAssertFalse(validator.validate())
    }

    func testPresenceCollection_nil() {
        let v: [Int]? = nil
        let validator = ValidationRules.Presence(name: "", value: v) { _ in }
        XCTAssertFalse(validator.validate())
    }

    func testPresenceString_notEmpty() {
        let validator = ValidationRules.Presence(name: "", value: "A") { _ in }
        XCTAssertTrue(validator.validate())
    }

    func testPresenceString_empty() {
        let validator = ValidationRules.Presence(name: "", value: "") { _ in }
        XCTAssertFalse(validator.validate())
    }

    func testPresenceString_nil() {
        let v: String? = nil
        let validator = ValidationRules.Presence(name: "", value: v) { _ in }
        XCTAssertFalse(validator.validate())
    }

    fileprivate static var presenceTests = [
        ("testPresence_notNil", testPresence_notNil),
        ("testPresene_nil", testPresene_nil),
        ("testPresenceCollection_notEmpty", testPresenceCollection_notEmpty),
        ("testPresenceCollection_empty", testPresenceCollection_empty),
        ("testPresenceCollection_nil", testPresenceCollection_nil),
        ("testPresenceString_notEmpty", testPresenceString_notEmpty),
        ("testPresenceString_empty", testPresenceString_empty),
        ("testPresenceString_nil", testPresenceString_nil),
    ]
}

// MARK: - Length

extension ValidationRuleTests {

    func testLength() {
        let v: String? = nil
        var validator = ValidationRules.Length(name: "", value: v, range: 2..<10) { _ in }
        XCTAssertFalse(validator.validate())

        validator.range = 0..<10
        XCTAssertTrue(validator.validate())
    }

    fileprivate static let lengthTests = [
        ("testLength", testLength),
    ]
}

// MARK: - Confirmation

extension ValidationRuleTests {

    func testConfirmation_same() {
        let validator = ValidationRules.Confirmation(name: "", confirmationName: "",
                                                     value: "FoO_BAr", confirmationValue: "FoO_BAr") { _ in }
        XCTAssertTrue(validator.validate())
    }

    func testConfirmation_different() {
        typealias Reason = ValidationRules.Confirmation<String, String, String, (String, String)>.FailureReason

        let validator = ValidationRules.Confirmation(
            name: "n1", confirmationName: "n2", value: "foo", confirmationValue: "bar"
        ) { (reason: Reason) in
            if case let .unmatched(names) = reason {
                return names
            }
            return ("", "")
        }
        XCTAssertEqual(validator.validateWithFailure()?.0, "n1")
        XCTAssertEqual(validator.validateWithFailure()?.1, "n2")
    }

    func testConfirmation_nil() {
        typealias Reason = ValidationRules.Confirmation<String, String, String, (String, String?)>.FailureReason

        let validator1 = ValidationRules.Confirmation(
            name: "n1", confirmationName: "n2", value: nil, confirmationValue: "bar"
        ) { (reason: Reason) in
            if case let .none(name) = reason {
                return (name, nil)
            }
            return ("", nil)
        }
        XCTAssertEqual(validator1.validateWithFailure()?.0, "n1")
        XCTAssertNil(validator1.validateWithFailure()!.1)

        let validator2 = ValidationRules.Confirmation(
            name: "n12", confirmationName: "n22", value: "foo", confirmationValue: nil
        ) { (reason: Reason) in
            if case let .unmatched(names) = reason {
                return names
            }
            return ("", nil)
        }
        XCTAssertEqual(validator2.validateWithFailure()?.0, "n12")
        XCTAssertEqual(validator2.validateWithFailure()?.1, "n22")
    }

    fileprivate static let confirmationTests = [
        ("testConfirmation_same", testConfirmation_same),
        ("testConfirmation_different", testConfirmation_different),
        ("testConfirmation_nil", testConfirmation_nil),
    ]
}
