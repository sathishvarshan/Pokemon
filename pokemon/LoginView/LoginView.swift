//
//  LoginView.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertIsPresented: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var pushToHome: Bool = false
    @State private var pushToSignup: Bool = false
    @State private var showForgotPasswordSheet: Bool = false
    @Environment(\.modelContext) private var context
    @AppStorage("userlogin") private var isLoggedIn: Bool = false
    @AppStorage("useremail") private var userEmail: String = ""

    private let vm = ProfileVM.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ZStack(alignment: .bottom){
                    Rectangle()
                        .foregroundStyle(.blue)
                        .cornerRadius(20)
                        .frame(height: 130)
                        .frame(maxWidth: .infinity)
                    Text("Login")
                        .padding(.bottom, 20)
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                VStack {
                    CommonStack(text: $email, titleText: "Email", placeHolderText: "Please enter email")
                    VStack {
                        Text("Password")
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        SecureField("Enter your password", text: $password)
                            .font(.body)
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                    
                    Button {
                         self.checkLogin()
                        print("Login")
                    } label: {
                        Text("Login")
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
                    
                    Button("Forget Password") {
                        showForgotPasswordSheet = true
                    }
                }
                
                Spacer()
                
                Text("Don't have an account? Sign up here.")
                    .foregroundColor(.gray)
                
                Button("Signup") {
                    pushToSignup = true
                }
                .font(.headline)
                .frame(height: 20)
                .padding(.bottom, 50)
            }
            .ignoresSafeArea()
            .alert("Alert", isPresented: $alertIsPresented) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .navigationDestination(isPresented: $pushToHome) {
                HomeView()
            }
            .navigationDestination(isPresented: $pushToSignup) {
                SignupView()
                    .navigationBarBackButtonHidden()
            }
            .fullScreenCover(isPresented: $showForgotPasswordSheet) {
                ForgetPassword()
            }
        }
    }
}

#Preview {
    LoginView()
}

extension LoginView {
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func checkLogin() {
        if email.isEmpty {
            alertMessage = "Please enter email"
            alertIsPresented = true
            return
        }
        if password.isEmpty {
            alertMessage = "Please enter password"
            alertIsPresented = true
            return
        }
        if !isValidEmail(email: email) {
            alertMessage = "Please enter a valid email"
            alertIsPresented = true
            return
        }
        let user = vm.fetchUser(context: context).filter({ $0.email == email && $0.password == password })
        if user.isEmpty {
            alertMessage = "Invalid email or password"
            alertIsPresented = true
            return
        }
        userEmail = email
        isLoggedIn = true
        pushToHome = true
    }
}
