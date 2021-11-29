//
//  TedTalksViewController.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 15/11/2021.
//

import UIKit

class TedTalksViewController: UIViewController {

	@IBOutlet weak var tedTalksTableView: UITableView!
	@IBOutlet weak var searchField: UITextField!
	@IBOutlet weak var errorLabel: UILabel!
	@IBOutlet weak var tedTalksActivityIndicator: UIActivityIndicatorView!

	lazy var presenter: TedTalksPresenterProtocol = TedTalksPresenter(view: self as TedTalksViewProtocol)

	override func viewDidLoad() {
		super.viewDidLoad()
		tedTalksActivityIndicator.startAnimating()
		tedTalksTableView.dataSource = self
		tedTalksTableView.delegate = self
	}
}

extension TedTalksViewController: UITextFieldDelegate {

	func textFieldDidChangeSelection(_ textField: UITextField) {
		if let searchDate = searchField.text {
			presenter.filterTedTalks(filterDate: searchDate)
			self.tedTalksTableView.reloadData()
		}
	}
}

extension TedTalksViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if !(presenter.getTedTalksFilteredCount() == 0) {
			return presenter.getTedTalksFilteredCount()
		}
		return presenter.getTedTalksCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let tedtalk = (presenter.getTedTalksFilteredCount() > 0) ? presenter.getFilteredTedTalks(for: indexPath.row) : presenter.getTedTalks(for: indexPath.row)
		let cell = tableView.dequeueReusableCell(withIdentifier: "tedTalkCell", for: indexPath)
		cell.textLabel?.text = "\(tedtalk.getYearPublished()) - \(tedtalk.name)"
		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegue(withIdentifier: "tedTalkSegue", sender: self)
	}
}

extension TedTalksViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.row <= presenter.getTedTalksCount() else {
			print("Out of range")
			return
		}
		performSegue(withIdentifier: "tedTalkSegue", sender: presenter.getTedTalks(for: indexPath.row))
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "tedTalkSegue" {
			if let destination = segue.destination as? TedTalkDetailViewController,
			let selectedTedTalk = sender as? TedTalk {
				destination.setTedTalk(selectedTedTalk)
			}
		}
	}
}

extension TedTalksViewController: TedTalksViewProtocol{

	func reloadData() {
		guard presenter.errors != nil else {
			tedTalksTableView.reloadData()
			tedTalksActivityIndicator.stopAnimating()
			return
		}
		switch presenter.errors {
		case .fileNotFound:
			self.errorLabel.text = "File not found"
		case .decodingProblem(let problem):
			self.errorLabel.text = "There was a problem decoding the data: \(problem)"
		default:
			self.errorLabel.text = "There was a problem"
		}
		self.errorLabel.isHidden = false
	}
}
