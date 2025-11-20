//
//  SignupView.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var cpassword: String = ""
    @State private var alertMessage = ""
    @State private var alertMessagePresent: Bool = false
    
    @Environment(\.modelContext) private var context
    
    private let vm = ProfileVM.shared
    
    var body: some View {
        VStack{
            ZStack(alignment: .bottom){
                Rectangle()
                    .cornerRadius(20)
                    .foregroundStyle(.blue)
                    .frame(height: 130)
                Text("Signup")
                    .bold(true)
                    .foregroundStyle(.white)
                    .font(.title)
                    .padding(.bottom, 20)

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 15, height: 25)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.bottom, 22)
            }
            CommonStack(text: $name, titleText: "Name", placeHolderText: "Enter your name", fontStyle: .title2, height: 40.0)
            CommonStack(text: $email, titleText: "Email", placeHolderText: "Enter your email", fontStyle: .title2, height: 40.0, keyboardType: .emailAddress)
            CommonStack(text: $phone, titleText: "Phone Number", placeHolderText: "Enter your phone number", fontStyle: .title2, height: 40.0, keyboardType: .numberPad)
            PasswordStack(password: $password, titleText: "Password", placeHolderText: "Enter password",fontStyle: .title2, height: 40.0)
            PasswordStack(password: $cpassword, titleText: "Confirm Password", placeHolderText: "Enter Confirm password",fontStyle: .title2, height: 40.0)
            

            Button {
                checkSignup()
            } label: {
                Text("Signup")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                    )
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
            
            Spacer()
        }
        .ignoresSafeArea()
        .alert("Alert", isPresented: $alertMessagePresent) {
            Button("Okay", role: .cancel) {
                
            }
        } message: {
            Text(alertMessage)
        }

    }
}

#Preview {
    SignupView()
}


extension SignupView{
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func checkSignup(){
        
        if name.isEmpty{
            alertMessage = "Please enter name"
            alertMessagePresent = true
            return
        }
        
        if email.isEmpty{
            alertMessage = "Please enter email"
            alertMessagePresent = true
            return
        }
        
        if !isValidEmail(email: email){
            alertMessage = "Please enter valid email"
            alertMessagePresent = true
            return
        }
        
        if phone.isEmpty{
            alertMessage = "Please enter phone number"
            alertMessagePresent = true
            return
        }
        
        if password.isEmpty{
            alertMessage = "Please enter password"
            alertMessagePresent = true
            return
        }
        
        if cpassword.isEmpty{
            alertMessage = "Please enter confirm password"
            alertMessagePresent = true
            return
        }
        
        if password != cpassword{
            alertMessage = "Password does not match"
            alertMessagePresent = true
            return
        }
        
        print("Do Signup")
        
        let users = vm.fetchUser(context: context)
        if !users.isEmpty{
            let userAvailable = users.filter({ $0.email == email })
            if !userAvailable.isEmpty{
                alertMessage = "Email already exists"
                alertMessagePresent = true
                return
            }
        }
        
        saveUser()
        
    }
    
    func saveUser(){
        let user = User(name: name, email: email, phone: phone, password: password)
        vm.addUser(context: context, user: user)
        print("New user is added")
        dismiss()
    }
    
    
}
