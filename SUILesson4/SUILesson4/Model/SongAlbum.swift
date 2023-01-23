//
//  SongAlbum.swift
//  SUILesson4
//
//  Created by Григоренко Александр Игоревич on 19.01.2023.
//

import Foundation

/// Альбом с композициями.
struct SongAlbum {

    // MARK: - private constants

    private enum Constants {
        static let gopStopName = "gopStop"
        static let myBitsUpName = "myBitsUp"
        static let naZareName = "naZare"
        static let slepakovName = "slepakov"
        static let jumpFromRockName = "jumpFromRock"
    }


    /// Массив с композициями.
    let songs = [Song(name: Constants.gopStopName, imageName: Constants.gopStopName),
                 Song(name: Constants.myBitsUpName, imageName: Constants.myBitsUpName),
                 Song(name: Constants.naZareName, imageName: Constants.naZareName),
                 Song(name: Constants.slepakovName, imageName: Constants.slepakovName),
                 Song(name: Constants.jumpFromRockName, imageName: Constants.jumpFromRockName)]
}
