//
//  ModelView.swift
//  SUILesson4
//
//  Created by Григоренко Александр Игоревич on 22.01.2023.
//

import Foundation
import AVFoundation

/// mp3 плеер.
final class PlayerViewModel: ObservableObject {

    // MARK: - Private Constants

    private enum Constants {
        static let trackFormat = "mp3"
        static let emptyString = ""
        static let zeroValue = 0
        static let floatZeroValue: CGFloat = 0.0
        static let unoValue = 1
    }

    // MARK: - Public properties

    @Published var currentSongIndex: Int?
    @Published var musicAlbum = SongAlbum().songs
    @Published var currentDuratiuon = Double(Constants.zeroValue)

    // MARK: - Public methods

    func play() {
        guard
            let songIndex = currentSongIndex
        else {
            playSong(name: musicAlbum.first?.name ?? Constants.emptyString)
            player?.play()
            currentSongIndex = Constants.zeroValue
            return
        }

        playSong(name: musicAlbum[songIndex].name)
        player?.play()
    }

    func stop() {
        player?.stop()
        currentSongIndex = nil
    }

    func playNext() {
        guard
            let index = currentSongIndex
        else { return }

        let nextIndex = index + Constants.unoValue

        guard nextIndex != musicAlbum.count else { return }

        currentSongIndex = nextIndex

        player?.stop()
        playSong(name: musicAlbum[nextIndex].name)
        player?.play()
    }

    func playPreviusSong() {
        guard
            let index = currentSongIndex
        else { return }

        let previusIndex = index - Constants.unoValue

        guard previusIndex != Constants.zeroValue else { return }

        currentSongIndex = previusIndex

        player?.stop()
        playSong(name: musicAlbum[previusIndex].name)
        player?.play()
    }

    func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value) else { return }
        player?.currentTime = time
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func changeVolume(volume: Float) {
        player?.volume = volume
    }

    // MARK: - Private properties

    @Published private var player: AVAudioPlayer?
    @Published private var maxDuration = Constants.floatZeroValue
    @Published private var volume = Constants.floatZeroValue

    private var timer: Timer?

    // MARK: - Private methods

    private func playSong(name: String) {
        guard let audioPath = Bundle.main.path(forResource: name, ofType: Constants.trackFormat) else { return }

        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            player?.volume = Float(Constants.unoValue)
            startTimer()
            maxDuration = player?.duration ?? Constants.floatZeroValue
        } catch {
            print(error.localizedDescription)
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(Constants.unoValue), repeats: true, block: { [ weak self ] _ in
            guard
                let self = self,
                let player = self.player
            else { return }
            self.currentDuratiuon = player.currentTime
            print("\(self.currentDuratiuon)")
        })
    }
}
