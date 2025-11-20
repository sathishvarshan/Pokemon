//
//  PasswordStack.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//
import SwiftUI

struct PasswordStack: View {
    
    @Binding var password: String
    var titleText: String
    var placeHolderText: String
    var fontStyle: Font.TextStyle = .title
    var height: CGFloat = 50.0
    
    var body: some View {
        VStack {
            Text(titleText)
                .font(.system(fontStyle))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            SecureField(placeHolderText, text: $password)
                .textContentType(.none)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .textContentType(.none)
                .keyboardType(.asciiCapable)
                .font(.body)
                .padding(.horizontal)
                .frame(height: height)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }
}

#Preview {
    PasswordStack(password: .constant(""), titleText: "Password", placeHolderText: "Please enter password", fontStyle: .title, height: 50.0)
}

