//
//  ViewController.swift
//  Chess
//
//  Created by Daniel Golovin on 22.09.2021.
//

import UIKit
import AVFoundation
import MultipeerConnectivity

class ViewController: UIViewController {
    
    var chessEngine: ChessEngine = ChessEngine()

    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var audioPlayer:AVAudioPlayer!
    
    var peerID: MCPeerID!
    var session: MCSession!
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        let url = Bundle.main.url(forResource: "ChessClick", withExtension: "wav")!
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        
        boardView.chessDelegate = self
     
        chessEngine.initializeGame()
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()
    }
    
    @IBAction func advertise(_ sender: Any) {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "gt-chess")
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceAdvertiser.startAdvertisingPeer()
        
        boardView.blackAtTop = false
        boardView.setNeedsDisplay()
    }
    //multiplayer
    @IBAction func join(_ sender: Any) {
        let browser = MCBrowserViewController(serviceType: "gt-chess", session: session)
        browser.delegate = self
        present(browser, animated: true)
    }
    
    @IBAction func reset(_ sender: Any) {
        chessEngine.initializeGame()
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        infoLabel.text = "White"
    }
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
}

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connected: \(peerID.displayName)")
        case .notConnected:
            print("Not connected: \(peerID.displayName)")
        @unknown default:
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("received data: \(data)")
        if let move = String(data: data, encoding: .utf8) {
            let moveArr = move.components(separatedBy: ":")
            if let fromCol: Int = Int(moveArr[0]), let fromRow = Int(moveArr[1]), let toCol = Int(moveArr[2]), let toRow = Int(moveArr[3]) {
                DispatchQueue.main.async {
                    self.updateMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}

extension ViewController: ChessDelegate {
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
       updateMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        
        let move: String = "\(fromCol):\(fromRow):\(toCol):\(toRow)"
        if let data = move.data(using: .utf8) {
           try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    func updateMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int)  {
    chessEngine.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        
        audioPlayer.play()
        
        if chessEngine.whitesTurn {
            infoLabel.text = "White"
        } else {
            infoLabel.text = "Black"
        }
    }
    
    func pieceAt(col: Int, row: Int) -> ChessPiece? {
        return chessEngine.pieceAt(col: col, row: row)
    
    }
}
