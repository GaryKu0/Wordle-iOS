//
//  ContentView.swift
//  wordle
//
//  Created by 郭粟閣 on 2024/3/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var texts: [[String]] = Array(repeating: Array(repeating: "", count: 5), count: 5)
    @FocusState private var focusedField: [Int]?
    let targetWord = "ADIEU"
    @State private var showingBingoAlert = false

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            Text("Wordle")
                .bold()
                .font(.largeTitle)
                .padding()
            Text("Guess the word")
                .font(.title)
                .bold()
                .padding()
            ForEach(0..<5, id: \.self) { i in
                HStack {
                    ForEach(0..<5, id: \.self) { j in
                        TextField("", text: Binding(
                            get: { self.texts[i][j] },
                            set: { newValue in
                                self.handleInput(newValue.uppercased(), atRow: i, column: j)
                            }
                        ))
                        .focused($focusedField, equals: [i, j])
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            if i == 0 && j == 0 {
                                self.focusedField = [0, 0]
                            }
                        }
                    }
                }
            }
            Button(action: {
                self.checkGuess()
            }) {
                Text("Check")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .alert(isPresented: $showingBingoAlert) {
            Alert(title: Text("Bingo!"), message: Text("You've guessed the word correctly."), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleInput(_ input: String, atRow row: Int, column: Int) {
        let newInput = input.prefix(1).uppercased() // Keep only the first character and make it uppercase
        texts[row][column] = newInput
        if input.count >= 1 && column < 4 {
            focusedField = [row, column + 1] // Move to the next field on the same row
        } else if input.count >= 1 && column == 4 && row < 4 {
            focusedField = [row + 1, 0] // Move to the first field of the next row
        }
    }
    
    private func checkGuess() {
        for row in texts {
            let guess = row.joined()
            if guess.count == 5 && guess == targetWord {
                showingBingoAlert = true // Show bingo alert
                break // Exit the loop as we found a correct guess
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





