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


	func searchYouTubeUsing(artist:String?, song:String?, album:String?, callback:@escaping finishedClosure) {	FXDLog_Func()

		let query = "\(artist!) \(song!) \(album!)"
		FXDLog(query)

		let percentEscaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		FXDLog(percentEscaped)

		let formattedString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(percentEscaped))&key=\(self.apikeyGoogleForBrowser!)"
		FXDLog(formattedString)

		let request = URLRequest(url: URL(string: formattedString)!)
		FXDLog(request)

		let searchTask = URLSession.shared.dataTask(with: request) {
			(data:Data?, response:URLResponse?, error:Error?) in

			FXDLog(data)
			FXDLog(response)
			FXDLog(error)


			var results:Array<Any>?

			do {
				let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

				results = (jsonObject as! Dictionary<String, Any>)["items"] as? Array<Any>;
			}
			catch {
				//TODO
			}

			callback(error == nil, results as Any)
		}

		searchTask.resume()
	}
}