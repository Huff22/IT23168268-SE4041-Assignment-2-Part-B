//
//  LoopingVideoBackground.swift
//  StillSpace
//
import SwiftUI
import AVFoundation

struct LoopingVideoBackground: UIViewRepresentable {
    let videoName: String

    func makeUIView(context: Context) -> LoopingVideoUIView {
        return LoopingVideoUIView(frame: .zero)
    }

    func updateUIView(_ uiView: LoopingVideoUIView, context: Context) {
        uiView.updateVideo(name: videoName)
    }
}

class LoopingVideoUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        
        // Configure tvOS to play audio from the video
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    func updateVideo(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp4") else {
            print("Video not found: \(name).mp4")
            return
        }
        
        queuePlayer?.pause()
        queuePlayer?.removeAllItems()
        
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        
        queuePlayer = AVQueuePlayer(playerItem: item)
        queuePlayer?.isMuted = false // Unmuted so embedded video audio plays
        playerLayer.player = queuePlayer
        
        if let queuePlayer = queuePlayer {
            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
            queuePlayer.play()
        }
    }
}
