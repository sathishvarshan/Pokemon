//
//  Common.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import SwiftUI

struct CommonStack: View {
    
    @Binding var text: String
    var titleText: String
    var placeHolderText: String
    var fontStyle: Font.TextStyle = .title
    var height: CGFloat = 50.0
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack {
            Text(titleText)
                .font(.system(fontStyle))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            TextField(placeHolderText, text: $text)
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
                .autocorrectionDisabled(true)
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
    CommonStack(text: .constant(""), titleText: "Email", placeHolderText: "Please enter email", fontStyle: .title, height: 50.0, keyboardType: .default)
}
