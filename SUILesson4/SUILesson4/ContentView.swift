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
        static let doubleScaleEffectCoef: CGFloat = 2
        static let zeroValue = 0
        static let unoValue = 1
        static let tenValue = 10
        static let makeSoneButtonWidth: CGFloat = 250
        static let makeInfoAboutSongSpacerWidht: CGFloat = 33
        static let makeInfoAboutSongSectionWidht: CGFloat = 200
        static let makeSongDuratonSliderHeight: CGFloat = 50
        static let sixtyValue: CGFloat = 60
    }

    // MARK: - Public properties


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CGFloat(Constants.unoValue))
            VStack {
                HStack {
                    downLoadButtonView
                    makeSongPosterImageView
                    shareSongButtonView
                }
                HStack {
                    infoAboutSongSectionView
                }
                .frame(height: CGFloat(Constants.tenValue))
                .padding()

                songDuratonSliderView

                HStack {
                    playPreviusSongButtonView
                    playSongButtonView
                    pauseSongButtonView
                    makeStopSongButtonView
                    makePlayNextSongButtonView
                }
                makeVolumeSliderView
            }
            .background(Color.black)
        }
    }

    // MARK: Private properties

    @StateObject private var viewModel = PlayerViewModel()
    @State private var progress: Double = Double(Constants.zeroValue)
    @State private var volume: Float = Float(Constants.zeroValue)
    @State private var isDownloadActionSheertShown = false
    @State private var isEditing = false

    private var downLoadButtonView: some View {
        Button {
            self.isDownloadActionSheertShown = true
        } label: {
            Image(systemName: Constants.rowDownImageName)
                .scaleEffect(x: Constants.doubleScaleEffectCoef, y: Constants.doubleScaleEffectCoef)
                .foregroundColor(.green)
        }
        .confirmationDialog(Constants.trackDownloadedName, isPresented: $isDownloadActionSheertShown, titleVisibility: .visible) {}
    }

    private var makeSongPosterImageView: some View  {
        Image(getImage())
            .resizable()
            .scaledToFit()
            .padding()
            .frame(width: Constants.makeSoneButtonWidth)
    }

    private var shareSongButtonView: some View {
        Button {
            self.progress = CGFloat(Constants.tenValue)
        } label: {
            Image(systemName: Constants.rowUpImageName)
                .scaleEffect(x: Constants.doubleScaleEffectCoef, y: Constants.doubleScaleEffectCoef)
                .foregroundColor(.green)
        }
    }

    private var infoAboutSongSectionView: some View {
        Section {
            Text(Constants.trackDurationName).padding()
            Spacer().frame(width: Constants.makeInfoAboutSongSpacerWidht)
            Text(viewModel.musicAlbum[viewModel.currentSongIndex ?? Constants.zeroValue].name)
                .frame(width: Constants.makeInfoAboutSongSectionWidht)
                .foregroundColor(.green)
                .padding()
        }
        .frame(height: CGFloat(Constants.tenValue))
        .foregroundColor(.green)
    }

    private var songDuratonSliderView: some View {
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
        .frame(height: Constants.makeSongDuratonSliderHeight)
    }

    private var playPreviusSongButtonView: some View {
        Button(action: {
            self.viewModel.playPreviusSong()
        }, label: {
            Image(systemName: Constants.rowLeftImageName)
                .scaleEffect(x: Constants.doubleScaleEffectCoef, y: Constants.doubleScaleEffectCoef)
        })
        .padding()
        .frame(width: Constants.sixtyValue)
        .foregroundColor(.green)
    }

    private var playSongButtonView: some View {
        Button(action: {
            self.viewModel.play()
        }, label: {
            Image(systemName: Constants.playImageName)
                .scaleEffect(x: Constants.doubleScaleEffectCoef, y: Constants.doubleScaleEffectCoef)
        })
        .padding()
        .frame(width: Constants.sixtyValue)
        .foregroundColor(.green)
    }

    private var pauseSongButtonView: some View {
        Button(action: {
            self.viewModel.pause()
        }, label: {
            Image(systemName: Constants.pauseImageName)
                .scaleEffect(x: Constants.doubleScaleEffectCoef, y: Constants.doubleScaleEffectCoef)
        })
        .padding()
        .frame(width: Constants.sixtyValue)
        .foregroundColor(.green)
    }

    private var stopSongButtonView: some View {
        Button(action: {
            self.viewModel.stop()
        }, label: {
            Image(systemName: Constants.stopImageName)
                .scaleEffect(x: Constants.doubleScaleEffectCoef, y: Constants.doubleScaleEffectCoef)
        })
        .padding()
        .frame(width: Constants.sixtyValue)
        .foregroundColor(.green)
    }

    private var playNextSongButtonView: some View {
        Button(action: {
            self.viewModel.playNext()
        }, label: {
            Image(systemName: Constants.rowRightImageName)
                .scaleEffect(x: Constants.doubleScaleEffectCoef, y: Constants.doubleScaleEffectCoef)
        })
        .padding()
        .frame(width: Constants.sixtyValue)
        .foregroundColor(.green)
    }
    
    private var volumeSliderView: some View {
        Slider(value: Binding(get: {
            Float(self.volume)
        }, set: { newValue in
            self.volume = newValue
            self.viewModel.changeVolume(volume: newValue)
        })) {
        } minimumValueLabel: {
            Text(Constants.zeroName).foregroundColor(.green).padding()
        } maximumValueLabel: {
            Text(Constants.hundredName)
                .foregroundColor(.green)
                .padding()
        }
        .padding()
        .accentColor(Color.green)
        .frame(height: Constants.sixtyValue)
    }

    private func getImage() -> String {
        self.viewModel.musicAlbum[viewModel.currentSongIndex ?? Constants.zeroValue].imageName
    }

    private func getCurrentSongName() -> String {
        self.viewModel.musicAlbum[viewModel.currentSongIndex ?? Constants.zeroValue].name
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
