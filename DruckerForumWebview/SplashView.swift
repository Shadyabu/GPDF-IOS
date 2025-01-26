//
//  SplashView.swift
//  DruckerForumWebview
//
//  Created by Shady Abushady on 26.01.25.
//  Copyright © 2025 imc. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            if self.isActive {
                MainView()
            } else {
                Rectangle()
                    .background(Color.black)
                Image("GPDF SplashScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
