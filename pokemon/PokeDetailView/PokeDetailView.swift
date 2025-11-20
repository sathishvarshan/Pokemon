//
//  PokeDetailView.swift
//  pokemon
//
//  Created by Sathish  on 20/11/25.
//

import SwiftUI

struct PokeDetailView: View {
    let name: String
    let image: UIImage?
    let url: String

    @StateObject private var vm = PokemonViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ZStack(alignment: .bottom){
                Rectangle()
                    .cornerRadius(20)
                    .foregroundStyle(.blue)
                    .frame(height: 130)
                Text(name)
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
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                ProgressView()
            }

            if let d = vm.pokemon {
                ScrollView{
                    VStack(spacing: 10){
                        CommonDeck(fontWeight: .semibold, name: "ID: ")
                        CommonDeck(fontWeight: .semibold,  fontStyle: .subheadline, name: "\(d.id)")
                            .padding(.leading, 30)
                        CommonDeck(fontWeight: .semibold, name: "Base Experience: ")
                        CommonDeck(fontWeight: .semibold,  fontStyle: .subheadline, name: "\(d.base_experience)")
                            .padding(.leading, 30)
                        CommonDeck(fontWeight: .semibold, name: "Height: ")
                        CommonDeck(fontWeight: .semibold,  fontStyle: .subheadline, name: "\(d.height)")
                            .padding(.leading, 30)
                        CommonDeck(fontWeight: .semibold, name: "Weight: ")
                        CommonDeck(fontWeight: .semibold,  fontStyle: .subheadline, name: "\(d.weight)")
                            .padding(.leading, 30)
                        CommonDeck(fontWeight: .semibold, name: "Type: ")
                        ForEach(d.types.enumerated(), id: \.offset){ idx, t in
                            CommonDeck(fontWeight: .regular, fontStyle: .title3, name: "\(idx + 1). \(t.type.name)")
                                .padding(.leading, 30)
                        }
                        CommonDeck(fontWeight: .semibold, name: "Ability: ")
                        ForEach(d.abilities.enumerated(), id: \.offset){ idx, t in
                            CommonDeck(fontWeight: .regular, fontStyle: .title3, name: "\(idx + 1). \(t.ability.name)")
                                .padding(.leading, 30)
                        }
                    }
                }
            } else {
                ProgressView()
            }

            Spacer()
        }
        .task {
            let urlArray = url.components(separatedBy: "/")
            let id = urlArray[urlArray.count - 2]
            print("Url : \(urlArray) & id: ",id)
            vm.fetchPokemonDetail(id: id)
        }
        .ignoresSafeArea()
    }

}


struct CommonDeck: View {
    
    var fontWeight: Font.Weight = .regular
    var fontStyle: Font.TextStyle = .title3
    var name: String = "Type: "
    
    var body: some View {
        HStack{
            Text(name)
                .fontWeight(fontWeight)
                .font(.system(fontStyle))
                .frame(alignment: .leading)
                .padding()
            Spacer()
        }
        .frame(height: 15)
    }
}
