//
//  ContentView.swift
//  SUILesson4
//
//  Created by Григоренко Александр Игоревич on 18.01.2023.
//

import SwiftUI
import AVFoundation

/// Контент представления с плеером
struct ContentView: View {

    // MARK: Private constants

    private enum Constants {
        static let rowDownImageName = "arrow.down.circle"
        static let trackDownloadedName = "Запись успешно загружена"
        static let rowUpImageName = "arrow.up.forward.app"
        static let trackDurationName = "03:58"
        static let trackStartTimeName = "0:00"
        static let rowLeftImageName = "arrow.left.to.line"
        static let playImageName = "play.fill"
        static let pauseImageName = "pause.fill"
        static let stopImageName = "stop.fill"
        static let rowRightImageName = "arrow.right.to.line"
        static let zeroName = "0"
        static let hundredName = "100"
    }

    // MARK: - public properties

    @ObservedObject var viewModel = PlayerViewModel()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1)
            VStack {
                HStack {
                    makeDownLoadButton
                    makeSongPosterImage
                    makeShareSongButton
                }
                HStack {
                    makeInfoAboutSongSection
                }
                .frame(height: 10)
                .padding()

                makeSongDuratonSlider

                HStack {
                    makePlayPreviusSongButton
                    makePlaySongButton
                    makePauseSongButton
                    makeStopSongButton
                    makePlayNextSongButton
                }
                makeVolumeSlider
            }.background(Color.black)
        }
    }

    // MARK: Private properties

    @State private var progress: Double = 0
    @State private var volume: Float = 0
    @State private var isDownloadActionSheertShown = false
    @State private var isEditing = false

    private var makeDownLoadButton: some View {
        Button {
            self.isDownloadActionSheertShown = true
        } label: {
            Image(systemName: Constants.rowDownImageName)
                .scaleEffect(x: 2, y: 2)
                .foregroundColor(.green)
        }.confirmationDialog(Constants.trackDownloadedName, isPresented: $isDownloadActionSheertShown, titleVisibility: .visible) {}
    }

    var makeSongPosterImage: some View  {
        Image(self.viewModel.musicAlbum[viewModel.currentSongIndex ?? 0].imageName)
            .resizable()
            .scaledToFit()
            .padding()
            .frame(width: 250)
    }

    private var makeShareSongButton: some View {
        Button {
            self.progress = 10
        } label: {
            Image(systemName: Constants.rowUpImageName)
                .scaleEffect(x: 2, y: 2)
                .foregroundColor(.green)
        }
    }

    private var makeInfoAboutSongSection: some View {
        Section {
            Text(Constants.trackDurationName).padding()
            Spacer().frame(width: 33)
            Text(viewModel.musicAlbum[viewModel.currentSongIndex ?? 0].name)
                .frame(width: 200)
                .foregroundColor(.green)
                .padding()
        }
        .frame(height: 10)
        .foregroundColor(.green)
    }

    private var makeSongDuratonSlider: some View {
        Slider(value: Binding(get: {
            self.viewModel.currentDuratiuon
        }, set: { newValue in
            self.progress = newValue
            self.viewModel.setTime(value: Float(newValue))
            self.viewModel.currentDuratiuon = newValue
        }), in: 0...100) {
        } minimumValueLabel: {
            Text(Constants.trackStartTimeName)
                .foregroundColor(.green)
                .padding()
        } maximumValueLabel: {
            Text(Constants.trackDurationName)
                .foregroundColor(.green)
                .padding()
        }
        .padding()
        .accentColor(Color.green)
        .frame(height: 50)
    }

    private var makePlayPreviusSongButton: some View {
        Button(action: {
            self.viewModel.playPreviusSong()
        }, label: {
            Image(systemName: Constants.rowLeftImageName)
                .scaleEffect(x: 2, y: 2)
        })
        .padding()
        .frame(width: 60)
        .foregroundColor(.green)
    }

    private var makePlaySongButton: some View {
        Button(action: {
            self.viewModel.play()
        }, label: {
            Image(systemName: Constants.playImageName)
                .scaleEffect(x: 2, y: 2)
        })
        .padding()
        .frame(width: 60)
        .foregroundColor(.green)
    }

    private var makePauseSongButton: some View {
        Button(action: {
            self.viewModel.pause()
        }, label: {
            Image(systemName: Constants.pauseImageName).scaleEffect(x: 2, y: 2)
        })
        .padding()
        .frame(width: 60)
        .foregroundColor(.green)
    }

    private var makeStopSongButton: some View {
        Button(action: {
            self.viewModel.stop()
        }, label: {
            Image(systemName: Constants.stopImageName).scaleEffect(x: 2, y: 2)
        })
        .padding()
        .frame(width: 60)
        .foregroundColor(.green)
    }

    private var makePlayNextSongButton: some View {
        Button(action: {
            self.viewModel.playNext()
        }, label: {
            Image(systemName: Constants.rowRightImageName).scaleEffect(x: 2, y: 2)
        })
        .padding()
        .frame(width: 60)
        .foregroundColor(.green)
    }
    
    private var makeVolumeSlider: some View {
        Slider(value: Binding(get: {
            Float(self.volume)
        }, set: { newValue in
            self.volume = newValue
            self.viewModel.changeVolume(volume: newValue)
        })) {
        } minimumValueLabel: {
            Text(Constants.zeroName).foregroundColor(.green).padding()
        } maximumValueLabel: {
            Text(Constants.hundredName).foregroundColor(.green).padding()
        }
        .padding()
        .accentColor(Color.green)
        .frame(height: 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
