//
//  HomeView.swift
//  Authentication
//
//  Created by Mark on 1/30/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var user: User
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("Welcome \nto the home Screen !")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                }
                Button(action: {
                    self.user.signOut()
                }) {
                    Text("Sign Out")
                        .fontWeight(.semibold)
                        .padding(.all, 5)
                    
                    
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(Color.red)
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(User())
    }
}
