//
//  ContentView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 9/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Pot: 0")
                .padding()
            VStack(alignment: .leading) {
                Text("Info: \(gameViewModel.gameInfo)")
                    .padding()
                
                List(gameViewModel.players) {
                    player in PlayerRow(player: player)
                }

            }
            
            HStack {
                Button(action: gameViewModel.startRound) {
                    Text("Start Round")
                    
                }
                Spacer()
                Button(action: gameViewModel.updateRoles) {
                    Text("Shift Dealer")
                }
            }
            .padding()
            .navigationTitle("Poker Tracker V2")
        }
    }
}

class GameViewModel: ObservableObject {
    @Published var gameInfo = "waiting to start..."
    @Published var whoIsDealer = 0
    /* This should be changed eventually
     so that the list of players is updatable
     from a setting screen -- for now the number
     of players is constant*/
    var players: [Player]
    
    init() {
        self.players = [
            Player(name: "Alice", money: 100),
            Player(name: "Bobby", money: 100),
            Player(name: "Chuck", money: 100),
            Player(name: "David", money: 100),
            Player(name: "Eddie", money: 100),
            Player(name: "Freddy", money: 100),
        ]
    }
    
    func applyRoles() {
        for (index, _) in players.enumerated() {
            /* Applies roles based on how many seats away from the
             dealer a player is located */
            switch (index - whoIsDealer) {
            case (0): players[index].role = PlayerRoles.dealer
            case (1): players[index].role = PlayerRoles.smallblind
            case (2): players[index].role = PlayerRoles.bigblind
            default: players[index].role = PlayerRoles.none
            }
        }
        
        /* Special Cases where the roles wrap around to beginning */
        if (whoIsDealer == (players.count - 1)) {
            players[0].role = PlayerRoles.smallblind
            players[1].role = PlayerRoles.bigblind
        }
        else if (whoIsDealer == (players.count - 2)) {
            players[0].role = PlayerRoles.bigblind
        }
    }
    
    func startRound() {
        gameInfo = "Round has started!"
        applyRoles()
    }
    
    func updateRoles() {
        whoIsDealer = (whoIsDealer+1 > players.count-1) ? 0 : (whoIsDealer+1)
        applyRoles()
    }
}

struct Player: Identifiable {
    let id = UUID()
    let name: String
    
    var money: Int
    var spentThisRound: Int =  0
    var role: PlayerRoles = PlayerRoles.none
}

enum PlayerRoles {
    case dealer, smallblind, bigblind, none
}

struct PlayerRow: View {
    var player: Player
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(player.name)
                Text("\(player.role)")
                    .foregroundStyle(player.role == PlayerRoles.dealer ? .red : .gray)
                
            }
            
            HStack {
                Spacer()
                Text("^ \(player.spentThisRound) ^")
                   
            }
            
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
