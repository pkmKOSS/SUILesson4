//
//  ModelView.swift
//  SUILesson4
//
//  Created by Григоренко Александр Игоревич on 22.01.2023.
//

import Foundation
import AVFoundation

/// Модель проигрывателя.
final class PlayerViewModel: ObservableObject {

    // MARK: - private Constants

    private enum Constants {
        static let trackFormat = "mp3"
    }

    // MARK: - public properties

    @Published var player: AVAudioPlayer?
    @Published var currentSongIndex: Int?
    @Published var musicAlbum = SongAlbum().songs
    @Published var currentDuratiuon: Double = 0
    @Published var maxDuration = 0.0
    @Published var volume = 0.0

    // MARK: - private properties

    private var timer: Timer?

    // MARK: - public methods

    func play() {
        guard
            let songIndex = currentSongIndex
        else {
            playSong(name: musicAlbum.first?.name ?? "")
            player?.play()
            currentSongIndex = 0
            return }

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

        let nextIndex = index + 1

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

        let previusIndex = index - 1

        guard previusIndex != 0 else { return }

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

    // MARK: - private methods

    private func playSong(name: String) {
        guard let audioPath = Bundle.main.path(forResource: name, ofType: Constants.trackFormat) else { return }

        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            player?.volume = 1
            startTimer()
            maxDuration = player?.duration ?? 0.0
        } catch {
            print(error.localizedDescription)
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [ weak self ] _ in
            guard
                let self = self,
                let player = self.player
            else { return }
            self.currentDuratiuon = player.currentTime
            print("\(self.currentDuratiuon)")
        })
    }
}
