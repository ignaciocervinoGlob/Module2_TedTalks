//
//  TedTalkDetailViewController.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 16/11/2021.
//

import UIKit

class TedTalkDetailViewController: UIViewController {

	@IBOutlet weak var tedTalkNameLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var eventLabel: UILabel!
	@IBOutlet weak var numSpeakerLabel: UILabel!
	@IBOutlet weak var mainSpeakerLabel: UILabel!
	@IBOutlet weak var speakerOccupationLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	@IBOutlet weak var filmDateLabel: UILabel!
	@IBOutlet weak var publishedDateLabel: UILabel!
	@IBOutlet weak var urlLabel: UILabel!
	@IBOutlet weak var languagesLabel: UILabel!
	@IBOutlet weak var viewsLabel: UILabel!
	@IBOutlet weak var commentsLabel: UILabel!
	@IBOutlet weak var tagsLabel: UILabel!

	var tedtalk: TedTalk?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}

	func setTedTalk(_ tedtalk: TedTalk) {
		self.tedtalk = tedtalk
	}

	private func setupView(){
		tedTalkNameLabel.text = tedtalk?.name
		titleLabel.text = "Title: \(tedtalk?.title ?? "")"
		eventLabel.text = "Event: \(tedtalk?.event ?? "")"
		numSpeakerLabel.text = "Number of speakers: \(tedtalk?.numSpeaker ?? 0)"
		mainSpeakerLabel.text = "Main speaker: \(tedtalk?.mainSpeaker ?? "")"
		speakerOccupationLabel.text = "Speaker occupation: \(tedtalk?.speakerOccupation ?? "")"
		descriptionLabel.text = "Description: \(tedtalk?.description ?? "")"
		durationLabel.text = "Duration: \((tedtalk?.duration ?? 0)/60) minutes"
		filmDateLabel.text = "Film date: \(timestampToString(date: tedtalk?.filmDate))"
		publishedDateLabel.text = "Film date: \(timestampToString(date: tedtalk?.publishedDate))"
		urlLabel.text = "URL: \(tedtalk?.url ?? "")"
		languagesLabel.text = "Number of languages available: \(tedtalk?.languages ?? 0)"
		viewsLabel.text = "Number of views: \(tedtalk?.views ?? 0)"
		commentsLabel.text = "Number of comments: \(tedtalk?.comments ?? 0)"
		tagsLabel.text = "Tags: \(tedtalk?.tags.joined(separator: ", ") ?? "")"
	}

	private func timestampToString(date: Double?) -> String {
		let teddate = NSDate(timeIntervalSince1970: date ?? 0)
		let calendar = Calendar.current
		let year = calendar.component(.year, from: teddate as Date)
		let month = calendar.component(.month, from: teddate as Date)
		let day = calendar.component(.day, from: teddate as Date)
		return "\(month)/\(day)/\(year)"
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	 // Get the new view controller using segue.destination.
	 // Pass the selected object to the new view controller.
	 }
	 */

}
