//
//  CarouselView.swift
//  Caraousel
//
//  Created by Tipu on 17/03/24.
//

import SwiftUI

struct CarouselView: View {
    @State private var activeIndex = 1
    
    var body: some View {
        let items = [
            CarouselItemModel(id: 0, name: "1. description.", image: Image("slider_image_1")),
            CarouselItemModel(id: 1, name: "2. description.", image: Image("slider_image_2")),
            CarouselItemModel(id: 2, name: "3. description.", image: Image("slider_image_3")),
            CarouselItemModel(id: 3, name: "4. description", image: Image("slider_image_4"))
        ]
        
        return GeometryReader { geometry in
            let cardWidth = geometry.size.width * 0.5
            let cardHeight = geometry.size.height * 0.9 // Adjust height proportionally
            let spacing: CGFloat = 16
            let totalSpacing = spacing * CGFloat(items.count - 1)
            let totalWidth = cardWidth * CGFloat(items.count) + totalSpacing
            let offsetX = (geometry.size.width - cardWidth) / 2 - CGFloat(activeIndex) * (cardWidth + spacing)
            
            HStack(spacing: spacing) {
                ForEach(items.indices, id: \.self) { index in
                    VStack {
                        items[index].image
                            .resizable()
                            .scaledToFill()
                            .frame(width: cardWidth, height: cardHeight)
                            .clipped()
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                    .scaleEffect(index == activeIndex ? 1.0 : 0.9)
                    .animation(.spring(), value: activeIndex)
                    .onTapGesture {
                        withAnimation {
                            activeIndex = index
                        }
                    }
                }
            }
            .frame(width: totalWidth, alignment: .leading)
            .offset(x: offsetX)
            .animation(.spring(), value: activeIndex)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -50, activeIndex < items.count - 1 {
                            activeIndex += 1
                        }
                        if value.translation.width > 50, activeIndex > 0 {
                            activeIndex -= 1
                        }
                    }
            )
            
        }
        .frame(height: UIScreen.main.bounds.height * 0.4) // Set height proportionally to screen height
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
