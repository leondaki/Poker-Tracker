//
//  ContentView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 9/1/24.
//

import SwiftUI

struct ContentView: View {
    let players = [
        Player(name: "Alice", money: 100),
        Player(name: "Bob", money: 100),
        Player(name: "Charles", money: 100),
        Player(name: "Dave", money: 100)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Pot: $100")
                List(players) {
                    player in PlayerRow(player: player)
                }
            }
            .navigationTitle("Poker Tracker")
        }
    }
}

struct Player: Identifiable {
    let id = UUID()
    let name: String
    let money: Int
    
    let spentThisRound: Int =  0
}

struct PlayerRow: View {
    var player: Player
    
    var body: some View {
        HStack {
            HStack {
                Text(player.name)
                Spacer()
            }
  
            Text("^ \(player.spentThisRound) ^")
            
            HStack {
                Spacer()
                Text("$\(player.money)")
            }
        }
    }
}

#Preview {
    ContentView()
}
