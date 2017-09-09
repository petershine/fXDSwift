

import UIKit
import Foundation


let urlformatYoutubeSearch = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&key=%@"
let urlformatYoutubeShortLink = "youtu.be/%@"	//MARK: No http:// for Twitter length

let objkeyVideoId = "videoId"
let objkeyVideoChannel = "channelTitle"
let objkeyVideoPublishedAt = "publishedAt"
let objkeyVideoThumbnail = "thumbnail"
let objkeyVideoTitle = "title"


class FXDmoduleYoutube {

	var apikeyGoogleForBrowser: String?


	func searchYouTubeUsing(artist: String?, song: String?, album: String?, callback:@escaping FXDcallback) {	FXDLog_Func()

		FXDLog(artist as Any)
		FXDLog(song as Any)
		FXDLog(album as Any)

		let query: String = "\(artist ?? "") \(song ?? "") \(album ?? "")"
		FXDLog(query)

		guard  query.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
			callback(false, NSNull())
			return
		}


		guard self.apikeyGoogleForBrowser != nil else {
			callback(false, NSNull())
			return
		}


		let percentEscaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		FXDLog(percentEscaped)

		let formattedString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(percentEscaped))&key=\(self.apikeyGoogleForBrowser!)"
		FXDLog(formattedString)

		let request = URLRequest(url: URL(string: formattedString)!)
		FXDLog(request)

		let searchTask = URLSession.shared.dataTask(with: request) {
			(data:Data?, response:URLResponse?, error:Error?) in

			FXDLog(data as Any)
			FXDLog(response as Any)
			FXDLog(error as Any)


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
