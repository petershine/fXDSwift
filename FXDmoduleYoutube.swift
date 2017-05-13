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

	var apikeyGoogleForBrowser: String?


	func searchYouTubeUsing(artist: String?, song: String?, album: String?, callback:@escaping FXDcallback) {	FXDLog_Func()

		debugPrint(artist as Any)
		debugPrint(song as Any)
		debugPrint(album as Any)

		let query: String = "\(artist ?? "") \(song ?? "") \(album ?? "")"
		debugPrint(query)

		guard  query.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 else {
			callback(false, NSNull())
			return
		}


		guard self.apikeyGoogleForBrowser != nil else {
			callback(false, NSNull())
			return
		}


		let percentEscaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		debugPrint(percentEscaped)

		let formattedString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(percentEscaped))&key=\(self.apikeyGoogleForBrowser!)"
		debugPrint(formattedString)

		let request = URLRequest(url: URL(string: formattedString)!)
		debugPrint(request)

		let searchTask = URLSession.shared.dataTask(with: request) {
			[weak self] (data:Data?, response:URLResponse?, error:Error?) in

			debugPrint(data as Any)
			debugPrint(response as Any)
			debugPrint(error as Any)


			var results:Array<Any>?

			do {
				let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

				results = (jsonObject as! Dictionary<String, Any>)["items"] as? Array<Any>;
			}
			catch {
				//MARK://TODO
			}

			callback(error == nil, results as Any)
		}

		searchTask.resume()
	}
}
