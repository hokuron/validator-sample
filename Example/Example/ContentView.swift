//
//  ContentView.swift
//  Example
//
//  Created by hokuron on 2020/01/12.
//  Copyright © 2020 hokuron. All rights reserved.
//

import SwiftUI

private struct ErrorText: View {
    @Binding var content: String?

    var body: some View {
        if let content = content {
            return AnyView(
                Text(content)
                    .font(.caption)
                    .foregroundColor(.red)
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    init(_ content: Binding<String?>) {
        self._content = content
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: self.viewModel.usernameError.isEmpty ? nil : Text(self.viewModel.usernameError)) {
                    TextField("SIGNUP_USERNAME", text: self.$viewModel.username)
                }

                Section(header: self.viewModel.passwordError.isEmpty ? nil : Text(self.viewModel.passwordError),
                        footer: Text("SIGNUP_PASSWORD_FOOTER")) {
                    SecureField("SIGNUP_PASSWORD", text: self.$viewModel.password)
                    SecureField("SIGNUP_PASSWORD_CONFIRMATION", text: self.$viewModel.passwordConfirmation)
                }

                Section {
                    Button("SIGNUP_SIGN_UP_BUTTON") {
                        self.viewModel.validateForModal()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle("SIGNUP_TITLE", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
