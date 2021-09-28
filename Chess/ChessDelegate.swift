//
//  ChessDelegate.swift
//  Chess
//
//  Created by Daniel Golovin on 22.09.2021.
//

import Foundation


protocol ChessDelegate {
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int)
    func pieceAt(col: Int, row: Int) -> ChessPiece?
}
