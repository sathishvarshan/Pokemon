//
//  Shimmer.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation
import SwiftUI


struct ShimmerView: View {
    @State private var isAnimating = false

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 80, height: 80)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .gray.opacity(0.3),
                        .gray.opacity(0.1),
                        .gray.opacity(0.3)
                    ]),
                    startPoint: isAnimating ? .leading : .trailing,
                    endPoint: isAnimating ? .trailing : .leading
                )
                .mask(Rectangle().frame(width: 80, height: 80))
            )
            .onAppear {
                withAnimation(.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                    isAnimating.toggle()
                }
            }
            .cornerRadius(12)
    }
}
