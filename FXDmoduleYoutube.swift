//
//  FXDmoduleYoutube.swift
//
//
//  Created by petershine on 3/29/17.
//  Copyright © 2017 fXceed. All rights reserved.
//

import UIKit
import Foundation


let urlformatYoutubeSearch = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&key=%@"
let urlformatYoutubeShortLink = "youtu.be/%@"	//NOTE: No http:// for Twitter length

let objkeyVideoId = "videoId"
let objkeyVideoChannel = "channelTitle"
let objkeyVideoPublishedAt = "publishedAt"
let objkeyVideoThumbnail = "thumbnail"
let objkeyVideoTitle = "title"


class FXDmoduleYoutube: NSObject {

	var apikeyGoogleForiOSapp:String?
	var apikeyGoogleForBrowser:String?


	override init() {
		super.init()

		FXDLog_OVERRIDE()
	}


	func searchYouTubeUsing(artist:String, song:String, album:String, callback:@escaping finishedClosure) {	FXDLog_Func()

		let queryText_0 = "\(artist) \(song) \(album)"
		FXDLog(queryText_0)

		let percentEscaped = queryText_0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		let formattedString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(percentEscaped)&key=\(self.apikeyGoogleForBrowser!)"
		let request = URLRequest(url: URL(string: formattedString)!)
		FXDLog(request)

		let searchTask = URLSession.shared.dataTask(with: request) {
			(data:Data?, response:URLResponse?, error:Error?) in

			FXDLog(data)
			FXDLog(response)
			FXDLog(error)


			var items:Array<Any>?

			do {
				let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

				items = (jsonObject as! Dictionary<String, Any>)["items"] as! Array<Any>;
			}
			catch {
				//TODO
			}

			for item in items! {
				FXDLog(item)
			}

			callback(error == nil, items)
		}
	}
}
