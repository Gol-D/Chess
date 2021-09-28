//
//  ChessPiece.swift
//  Chess
//
//  Created by Daniel Golovin on 22.09.2021.
//

import Foundation

struct ChessPiece: Hashable {
    let col: Int
    let row: Int
    let imageName: String
    let isWhite: Bool // true: white, false: black
}
