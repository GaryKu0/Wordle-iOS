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
    
    var body: some View {
        VStack {
            Image("logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                        HStack {
                            Text("Wordle")
                                .bold()
                                .font(.largeTitle)
                        }
                        .padding()
                        HStack {
                            Text("Guess the word")
                                .font(.title)
                                .bold()
                        }
                        .padding()
                ForEach(0..<5, id: \.self) { i in
                HStack {
                    ForEach(0..<5, id: \.self) { j in
                        TextField("", text: Binding(
                            get: { self.texts[i][j] },
                            set: { newValue in
                                self.handleInput(newValue, atRow: i, column: j)
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
    }
    
    private func handleInput(_ input: String, atRow row: Int, column: Int) {
        var newInput = input.uppercased()
        if newInput.count > 1 {
            // Extract the last character if the user is trying to enter more than one character.
            newInput = String(newInput.last!)
        }
        
        // Place the character in the current field.
        texts[row][column] = String(newInput)
        
        // Determine the next field to focus.
        var nextRow = row
        var nextColumn = column + 1
        if nextColumn > 4 {
            nextColumn = 0
            nextRow += 1
        }
        
        if nextRow < 5 {
            // Automatically move focus to the next field.
            focusedField = [nextRow, nextColumn]
            
            // If the next field is already filled, recursively call this method to handle it.
            if !texts[nextRow][nextColumn].isEmpty {
                handleInput("", atRow: nextRow, column: nextColumn)
            }
        }
    }
    
    private func checkGuess() {
        for row in texts {
            let guess = row.joined()
            if guess.count == 5 {
                if guess == targetWord {
                    print("Bingo!")
                } else {
                    print("Wrong, you typed: \(guess)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





