

import UIKit
import Foundation

import MediaPlayer


class FXDmoduleMedia: NSObject {

	lazy var musicPlayer: MPMusicPlayerController = {
		return MPMusicPlayerController.systemMusicPlayer()
	}()


	deinit {	SWIFTLog_Func()
		self.musicPlayer.endGeneratingPlaybackNotifications()
		MPMediaLibrary.default().endGeneratingLibraryChangeNotifications()
	}


	func startObservingMediaNotifications() {	SWIFTLog_Func()
		//MARK: Can't use mediaModule for simulator
		print("TARGET_OS_SIMULATOR: \(TARGET_OS_SIMULATOR)")
		if TARGET_OS_SIMULATOR != 0 {
			return
		}


		NotificationCenter.default
			.addObserver(self,
			             selector: #selector(observedMPMusicPlayerControllerPlaybackStateDidChange(_:)),
			             name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
			             object:self.musicPlayer)

		NotificationCenter.default
			.addObserver(self,
			             selector: #selector(observedMPMusicPlayerControllerNowPlayingItemDidChange(_:)),
			             name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
			             object:self.musicPlayer)

		self.musicPlayer.beginGeneratingPlaybackNotifications()


		NotificationCenter.default
			.addObserver(self,
			             selector: #selector(observedMPMediaLibraryDidChange(_:)),
			             name: NSNotification.Name.MPMediaLibraryDidChange,
			             object:MPMediaLibrary.default())

		MPMediaLibrary.default().beginGeneratingLibraryChangeNotifications()
	}

	func observedMPMusicPlayerControllerPlaybackStateDidChange(_ notification: Notification) {
		SWIFTLog(self.musicPlayer.playbackState.rawValue)
	}

	func observedMPMusicPlayerControllerNowPlayingItemDidChange(_ notification: Notification) {
		SWIFTLog(self.musicPlayer.nowPlayingItem?.title)
	}

	func observedMPMediaLibraryDidChange(_ notification: Notification) {
		SWIFTLog(MPMediaLibrary.default().lastModifiedDate)
	}
}
