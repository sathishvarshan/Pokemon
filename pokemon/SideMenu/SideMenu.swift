//
//  SideMenu.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import SwiftUI

struct SideMenu: View {

    @AppStorage("userlogin") private var isLoggedIn: Bool = false
    @AppStorage("useremail") private var userEmail: String?
    var widthFraction: CGFloat = 0.75
    var backgroundColor: Color = .blue.opacity(0.5)
    var name: String
    var email: String
    var phone: String
    @Binding var isPresented: Bool
    @State private var image: UIImage?
    @State private var source: ImageSource = .photoLibrary
    @State private var showPicker = false
    @State private var showOptions = false

    var body: some View {
            GeometryReader { geo in
                let menuWidth = max(0, min(1, widthFraction)) * geo.size.width
                
                ZStack(alignment: .leading) {
                    if isPresented {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    isPresented = false
                                }
                            }
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeInOut) {
                                    isPresented = false
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .foregroundStyle(.white)
                        }
                        .padding(.top, 80)
                        .padding(.horizontal)
                        .background(backgroundColor)
                        
                        HStack {
                            Button {
                                print("Image tapped")
                                showOptions = true
                            } label: {
                                if let img = image {
                                    let _ = ImageFileManager.shared.save(image: img, fileName: "\(phone).jpg")
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipShape(.circle)
                                        .foregroundStyle(.white)
                                        .padding()
                                }else{
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(.circle)
                                        .foregroundStyle(.white)
                                        .padding()
                                }
                            }
                            .cornerRadius(24)
                            .clipped()
                            .actionSheet(isPresented: $showOptions) {
                                ActionSheet(
                                    title: Text("Choose Source"),
                                    buttons: [
                                        .default(Text("Camera")) {
                                            ImageFileManager.shared.requestCameraPermission { granted in
                                                if granted {
                                                    source = .camera
                                                    showPicker = true
                                                } else {
                                                    print("Camera permission denied")
                                                }
                                            }
                                        },
                                        .default(Text("Photos")) {
                                            ImageFileManager.shared.requestPhotoPermission { granted in
                                                if granted {
                                                    source = .photoLibrary
                                                    showPicker = true
                                                } else {
                                                    print("Photo permission denied")
                                                }
                                            }
                                        },
                                        .cancel()
                                    ]
                                )
                            }
                            .sheet(isPresented: $showPicker) {
                                ImagePicker(image: $image, source: source)
                            }
                            .onAppear {
                                image = ImageFileManager.shared.load(fileName: "\(phone).jpg")
                            }
                            VStack(alignment: .leading) {
                                Text("Welcome")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            .padding(.leading,10)
                            Spacer()
                        }
                        .padding(.top,30)
                        .background(backgroundColor)
                        
                        Label(name, systemImage: "person.fill")
                            .font(.title2)
                            .padding()
                        
                        Label(email, systemImage: "envelope.fill")
                            .font(.title3)
                            .multilineTextAlignment(strategy: .layoutBased)
                            .padding()
                        
                        Label(phone, systemImage: "iphone.gen1")
                            .font(.title3)
                            .multilineTextAlignment(strategy: .layoutBased)
                            .padding()
                        
                        Spacer()
                        
                        Button {
                            print("Logout")
                            userEmail = ""
                            isLoggedIn = false
                        } label: {
                            Label("Logout", systemImage: "arrowshape.turn.up.left.fill")
                                .frame(height: 30)
                                .font(.title2)
                                .padding()
                                .padding(.bottom, 80)
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: menuWidth, maxHeight: .infinity, alignment: .topLeading)
                    .background(.gray)
                    .ignoresSafeArea()
                    .transition(.move(edge: .leading))
                    .offset(x: isPresented ? 0 : -menuWidth)
                    .animation(.easeInOut, value: isPresented)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .ignoresSafeArea()
            .background(.clear)
    }
}


//#Preview{
//    SideMenu(name: "", email: "", phone: "", isPresented: .constant(true))
//}
