//
//  HomeView.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.modelContext) private var context
    @AppStorage("useremail") private var useremail: String?
    @State private var showMenu: Bool = false
    @State var loguser: User?
    private let vm = ProfileVM.shared
    @StateObject private var pokevm = PokemonViewModel()
    @Namespace var namespace
    @State private var selectedPokemon: SelectedPokemon?

    var body: some View {
        NavigationStack{
            ZStack(alignment: .topLeading) {
                VStack {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .foregroundStyle(.blue)
                            .frame(height: 130)
                            .cornerRadius(30)
                        HStack{
                            Button {
                                withAnimation(.easeInOut) {
                                    showMenu.toggle()
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundStyle(.white)
                                    .imageScale(.large)
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 30)
                            Spacer()
                        }
                        Text("Home")
                            .bold(true)
                            .foregroundStyle(.white)
                            .font(.title)
                            .padding(.bottom,30)

                    }
                
                    List {
                        ForEach(pokevm.pokemons.enumerated(), id: \.offset) { idx, item in
                            Button {
                                selectedPokemon = SelectedPokemon(
                                    name: item.name,
                                    image: item.image,
                                    url: item.url
                                )
                            } label: {
                                PokeView(name: item.name, image: item.image, isLoading: item.isLoading)
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                if idx == pokevm.pokemons.count - 1 {
                                    pokevm.load(offset: idx + 50 + 1)
                                }
                            }
                            .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                    .listRowSeparator(.hidden)
                    
                    Spacer()
                }
                .ignoresSafeArea()
                .navigationDestination(item: $selectedPokemon) { sel in
                    PokeDetailView(
                        name: sel.name,
                        image: sel.image,
                        url: sel.url
                    )
                    .navigationBarBackButtonHidden(true)
                }
                
                if showMenu {
                    SideMenu(name: loguser?.name ?? "", email: loguser?.email ?? "", phone: loguser?.phone ?? "", isPresented: $showMenu)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
            }
            .onAppear {
                let user = vm.fetchUser(context: context).filter({ $0.email == useremail})
                if !user.isEmpty{
                    loguser = user.first
                }
            }
            .task {
                if pokevm.pokemons.isEmpty {
                    pokevm.load()
                }
            }
        }
    }
}

private struct SelectedPokemon: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let image: UIImage?
    let url: String
}

#Preview {
    HomeView()
}

struct PokeView: View {
    var name: String?
    var image: UIImage?
    var isLoading: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 120)
                .foregroundStyle(.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            HStack {
                if isLoading {
                    ShimmerView()
                        .frame(width: 80, height: 80)
                        .padding()
                } else if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .padding()
                }
                VStack {
                    Text(name ?? "Pokemon")
                        .font(.largeTitle)
                }
                Spacer()
            }
            .padding()
        }
    }
}
