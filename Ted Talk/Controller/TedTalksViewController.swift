//
//  TedTalksViewController.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 15/11/2021.
//

import UIKit

class TedTalksViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var tedTalksTableView: UITableView!
	@IBOutlet weak var searchField: UITextField!
	@IBOutlet weak var errorLabel: UILabel!
	@IBOutlet weak var tedTalksActivityIndicator: UIActivityIndicatorView!

	var tedtalks: [TedTalk]? = [] {
		didSet {
			self.tedTalksTableView.reloadData()
		}
	}

	var tedtalksFiltered: [TedTalk]? = []

	override func viewDidLoad() {
		super.viewDidLoad()
		tedTalksActivityIndicator.startAnimating()
		TedTalksManager().retrieve { [weak self] result in
			DispatchQueue.main.async {
				self?.tedTalksActivityIndicator.stopAnimating()
				switch result {
				case .success(let tedtalks):
					self?.tedtalks = tedtalks
					self?.errorLabel.isHidden = true
				case .failure(let error):
					switch error {
					case .fileNotFound:
						self?.errorLabel.text = "File not found"
					case .decodingProblem(let problem):
						self?.errorLabel.text = "There was a problem decoding the data: \(problem)"
					default:
						self?.errorLabel.text = "There was a problem"
					}
					self?.errorLabel.isHidden = false
					self?.tedtalks = []
				}
			}
		}

		tedTalksTableView.dataSource = self
		tedTalksTableView.delegate = self
		searchField.delegate = self
	}
}

extension TedTalksViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if !(tedtalksFiltered?.isEmpty ?? true) {
			return tedtalksFiltered?.count ?? 0
		}
		return !(searchField.text?.isEmpty ?? true) ? 0 : tedtalks?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tedTalkCell", for: indexPath)
		if !(tedtalksFiltered?.isEmpty ?? true) {
			cell.textLabel?.text = "\(getYearPublished(dateTimestamp: tedtalksFiltered?[indexPath.row].publishedDate ?? 0)) - \(tedtalksFiltered![indexPath.row].name)"
		} else {
			cell.textLabel?.text = "\(getYearPublished(dateTimestamp: tedtalks?[indexPath.row].publishedDate ?? 0)) - \(tedtalks![indexPath.row].name)"
		}
		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegue(withIdentifier: "tedTalkSegue", sender: self)
	}

	private func getYearPublished(dateTimestamp: Double) -> Int {
		let teddate = NSDate(timeIntervalSince1970: dateTimestamp)
		return Calendar.current.component(.year, from: teddate as Date)
	}
}

extension TedTalksViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "tedTalkSegue", sender: self)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "tedTalkSegue" {
			if let destination = segue.destination as? TedTalkDetailViewController {
				destination.tedtalk = tedtalks?[(tedTalksTableView.indexPathForSelectedRow?.row)!]
			}
		}
	}
}

extension TedTalksViewController {

	func textFieldDidChangeSelection(_ textField: UITextField) {
		if let searchText = searchField.text {
			filterData(searchText)
		}
	}

	func filterData(_ query: String?) {
		guard let query = query else {
			return
		}
		tedtalksFiltered?.removeAll()
		tedtalks?.forEach({ tedtalk in
			if getYearPublished(dateTimestamp: tedtalk.publishedDate) == Int(query) {
				tedtalksFiltered?.append(tedtalk)
			}
		})
		self.tedTalksTableView.reloadData()
	}
}
