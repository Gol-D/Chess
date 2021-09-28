//
//  ChessEngine.swift
//  Chess
//
//  Created by Daniel Golovin on 22.09.2021.
//

import Foundation


struct ChessEngine {
    var pieces: Set<ChessPiece> = Set<ChessPiece>()
    var whitesTurn: Bool = true
    
    mutating func movePiece(fromCol: Int, fromRow: Int, toCol:Int, toRow: Int) {
        if !canMovePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) {
            return
        }
        guard let candiddate = pieceAt(col: fromCol, row: fromRow) else {
            return
        }
        
     // удаление съеденых шахмат и невозможность поставить фигуру на фигуру
        if let target = pieceAt(col: toCol, row: toRow) {
            if target.isWhite == candiddate.isWhite {
            return
            }
            pieces.remove(target)
        }
        
        pieces.remove(candiddate)
        pieces.insert(ChessPiece(col: toCol, row: toRow, imageName: candiddate.imageName, isWhite: candiddate.isWhite))
        
        whitesTurn = !whitesTurn
    }
    
    func canMovePiece (fromCol: Int, fromRow: Int, toCol:Int, toRow: Int) -> Bool {
        if fromCol == toCol && fromRow == toRow {
            return false
        }
        guard let candiddate = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        
        if candiddate.isWhite != whitesTurn {
            return false
        }
        
        return true
    }
    
    func pieceAt(col: Int, row: Int) -> ChessPiece? {
        for piece in pieces {
            if col == piece.col && row == piece.row {
                return piece
            }
        }
        return nil
    }
    
    
    // фигуры на доске
    mutating func initializeGame(){
        whitesTurn = true
        
        pieces.removeAll()
        
        for i in 0..<2 {
            pieces.insert(ChessPiece(col: i * 7, row: 0, imageName: "Rook-black", isWhite: false))
            pieces.insert(ChessPiece(col: i * 7, row: 7, imageName: "Rook-white", isWhite: true))
            pieces.insert(ChessPiece(col:1 + i * 5, row: 0, imageName: "Knight-black", isWhite: false))
            pieces.insert(ChessPiece(col:1 + i * 5, row: 7, imageName: "Knight-white", isWhite: true))
            pieces.insert(ChessPiece(col:2 + i * 3, row: 0, imageName: "Bishop-black", isWhite: false))
            pieces.insert(ChessPiece(col:2 + i * 3, row: 7, imageName: "Bishop-white", isWhite: true))
        }
        
        pieces.insert(ChessPiece(col: 3, row: 0, imageName: "Queen-black", isWhite: false))
        pieces.insert(ChessPiece(col: 3, row: 7, imageName: "Queen-white", isWhite: true))
        pieces.insert(ChessPiece(col: 4, row: 0, imageName: "King-black", isWhite: false))
        pieces.insert(ChessPiece(col: 4, row: 7, imageName: "King-white", isWhite: true))
        
        for col in 0..<8 {
            pieces.insert(ChessPiece(col: col, row: 1, imageName: "Pawn-black", isWhite: false))
            pieces.insert(ChessPiece(col: col, row: 6, imageName: "Pawn-white", isWhite: true))
        }
        
    }
}
