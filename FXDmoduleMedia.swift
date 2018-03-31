

import UIKit
import Foundation

import MediaPlayer

import ReactiveSwift
import Result


class FXDmoduleMedia: NSObject {

    let (nowplayingSignal, nowplayingObserver) = Signal<MPMediaItem?, NoError>.pipe()

    lazy var musicPlayer: MPMusicPlayerController? = {
        return MPMusicPlayerController.systemMusicPlayer
    }()

    var lastMediaItem: MPMediaItem?


    deinit {    FXDLog_Func()
        musicPlayer?.endGeneratingPlaybackNotifications()
        MPMediaLibrary.default().endGeneratingLibraryChangeNotifications()
    }


    func startObservingMediaNotifications() {    FXDLog_Func()
		//MARK: The app's Info.plist must contain an NSAppleMusicUsageDescription key with a string value explaining to the user how the app uses this data.

        NotificationCenter.default.addObserver(self,
                         selector: #selector(self.observedMPMusicPlayerControllerPlaybackStateDidChange(_:)),
                         name: .MPMusicPlayerControllerPlaybackStateDidChange,
                         object:self.musicPlayer)

        NotificationCenter.default.addObserver(self,
                         selector: #selector(self.observedMPMusicPlayerControllerNowPlayingItemDidChange(_:)),
                         name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                         object:self.musicPlayer)

        NotificationCenter.default.addObserver(self,
                         selector: #selector(self.observedMPMediaLibraryDidChange(_:)),
                         name: .MPMediaLibraryDidChange,
                         object:MPMediaLibrary.default())


        if self.musicPlayer != nil {
            self.musicPlayer!.beginGeneratingPlaybackNotifications()
        }

        MPMediaLibrary.default().beginGeneratingLibraryChangeNotifications()
    }
}

extension FXDmoduleMedia {

	@objc func observedMPMusicPlayerControllerPlaybackStateDidChange(_ notification: Notification) {
		FXDLog(self.musicPlayer?.playbackState.rawValue as Any)
	}

	@objc func observedMPMusicPlayerControllerNowPlayingItemDidChange(_ notification: Notification) {
		FXDLog(self.musicPlayer?.nowPlayingItem?.title as Any)
		FXDLog(self.lastMediaItem?.title as Any)

		//MARK: It's responsibility of the developer to control repeated item
		self.nowplayingObserver.send(value: self.musicPlayer?.nowPlayingItem)
	}

	@objc func observedMPMediaLibraryDidChange(_ notification: Notification) {
		FXDLog(MPMediaLibrary.default().lastModifiedDate)
	}
}

