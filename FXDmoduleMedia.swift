

import UIKit
import Foundation

import MediaPlayer


class FXDmoduleMedia: NSObject {

	lazy var musicPlayer: MPMusicPlayerController = {
		return MPMusicPlayerController.systemMusicPlayer()
	}()


	deinit {	FXDLog_Func()
		self.musicPlayer.endGeneratingPlaybackNotifications()
		MPMediaLibrary.defaultMediaLibrary().endGeneratingLibraryChangeNotifications()
	}


	func startObservingMediaNotifications() {	FXDLog_Func()

		NSNotificationCenter.defaultCenter()
			.addObserver(self,
			             selector: #selector(observedMPMusicPlayerControllerPlaybackStateDidChange(_:)),
			             name: MPMusicPlayerControllerPlaybackStateDidChangeNotification,
			             object:self.musicPlayer)

		NSNotificationCenter.defaultCenter()
			.addObserver(self,
			             selector: #selector(observedMPMusicPlayerControllerNowPlayingItemDidChange(_:)),
			             name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
			             object:self.musicPlayer)

		self.musicPlayer.beginGeneratingPlaybackNotifications()


		NSNotificationCenter.defaultCenter()
			.addObserver(self,
			             selector: #selector(observedMPMediaLibraryDidChange(_:)),
			             name: MPMediaLibraryDidChangeNotification,
			             object:MPMediaLibrary.defaultMediaLibrary())

		MPMediaLibrary.defaultMediaLibrary().beginGeneratingLibraryChangeNotifications()
	}

	func observedMPMusicPlayerControllerPlaybackStateDidChange(notification: NSNotification) {
		FXDLog(self.musicPlayer.playbackState.rawValue)
	}

	func observedMPMusicPlayerControllerNowPlayingItemDidChange(notification: NSNotification) {
		FXDLog(self.musicPlayer.nowPlayingItem?.title)
	}

	func observedMPMediaLibraryDidChange(notification: NSNotification) {
		FXDLog(MPMediaLibrary.defaultMediaLibrary().lastModifiedDate)
	}
}