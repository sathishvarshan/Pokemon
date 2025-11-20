//
//  ForgetPassword.swift
//  pokemon
//
//  Created by Sathish  on 20/11/25.
//

import SwiftUI

struct ForgetPassword: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var phone: String = ""
    @State var password: String = ""
    @State var cpassword: String = ""
    @State private var presentVerifySheet: Bool = false
    @State private var otpTF: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var phoneVerify: Bool = false
    @Environment(\.modelContext) private var context
    private var passupdate = false
    private let vm = ProfileVM()
    
    
    var body: some View {
        VStack {
            ZStack{
                VStack{
                    ZStack(alignment: .bottom){
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundStyle(.blue)
                            .frame(height: 130)
                        Text("Forget Password")
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
                    
                    VStack{
                        CommonStack(text: $phone, titleText: "Phone Number", placeHolderText: "Please Enter Your Phone Number")
                        if phoneVerify{
                            CommonStack(text: $otpTF, titleText: "OTP", placeHolderText: "Please Enter Your OTP")
                        }
                        Button {
                            checkuser()
                        } label: {
                            Text("Verify")
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
                        .alert("Alert", isPresented: $showAlert) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text(alertMessage)
                        }
                    }
                    Spacer()
                }
                
                if presentVerifySheet {
                    ForgetPopup(password: $password, Cpassword: $cpassword, phone: $phone)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onTapGesture {
                            presentVerifySheet = false
                        }
                }
            }
            
            
        }
        .animation(.bouncy(duration: 0.5), value: presentVerifySheet)
        .ignoresSafeArea()
    }
}

#Preview {
    ForgetPassword()
}


extension ForgetPassword{
    
    func checkuser() {

        guard !phone.isEmpty else {
            alertMessage = "Please Enter Phone number"
            showAlert = true
            return
        }

        let users = vm.fetchUser(context: context)
        let exists = users.contains { $0.phone == phone }
        guard exists else {
            alertMessage = "User Not Found"
            showAlert = true
            phoneVerify = false
            return
        }
        
        if !phoneVerify {
            phoneVerify = true
            return
        }
        
        guard !otpTF.isEmpty else {
            alertMessage = "Please Enter OTP"
            showAlert = true
            return
        }
        
        guard otpTF == "1234" else {
            alertMessage = "Incorrect OTP"
            showAlert = true
            return
        }
        
        presentVerifySheet = true
    }
    
}


struct ForgetPopup: View {
    
    @Binding var password: String
    @Binding var Cpassword: String
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Binding var phone: String
    private let vm = ProfileVM()
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .cornerRadius(50)
                    .foregroundStyle(.white)
                    .frame(height: 400)
                    .padding()
                VStack{
                    CommonStack(text: $password, titleText: "Password", placeHolderText: "Enter your password", fontStyle: .title2, height: 40.0, keyboardType: .phonePad)
                    CommonStack(text: $Cpassword, titleText: "Confirm Password", placeHolderText: "Enter confirm password", fontStyle: .title2, height: 40.0, keyboardType: .phonePad)
                    Button {
                        checkChangePassword()
                    } label: {
                        Text("Change Password")
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
                    .alert("Alert", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {
                                dismiss()
                        }
                    } message: {
                        Text(alertMessage)
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(.gray.opacity(0.5))
    }
}

extension ForgetPopup{
    func checkChangePassword(){
        if password.isEmpty{
            alertMessage = "Please Enter Password"
            showAlert = true
            return
        }
        
        if Cpassword.isEmpty{
            alertMessage = "Please Enter Confirm Password"
            showAlert = true
            return
        }
        
        if password != Cpassword{
            alertMessage = "Please Not Match"
            showAlert = true
            return
        }
        
        if vm.updatePassword(context: context, phone: phone, password: password){
            alertMessage = "Password updated Successfully"
            showAlert = true
            return
        }
        
    }
}
