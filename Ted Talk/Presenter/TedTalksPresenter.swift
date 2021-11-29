//
//  TedTalksPresenter.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 26/11/2021.
//

import Foundation

class TedTalksPresenter: TedTalksPresenterProtocol {

	var view: TedTalksViewProtocol?
	var tedtalks: [TedTalk] = [] {
		didSet {
			view?.reloadData()
		}
	}
	var tedtalksFiltered: [TedTalk] = [] 
	var errors: Errors? = nil

	init(view: TedTalksViewProtocol) {
		self.view = view
		TedTalksManager().retrieve { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let tedtalks):
					self.tedtalks = tedtalks
				case .failure(let error):
					switch error {
					case .fileNotFound:
						self.errors = error
					case .decodingProblem:
						self.errors = error
					case .invalidData:
						self.errors = error
					}
					self.tedtalks = []
				}
			}
		}
	}

	func getTedTalksCount() -> Int {
		return self.tedtalks.count
	}

	func getTedTalks(for tedtalk: Int) -> TedTalk {
		return self.tedtalks[tedtalk]
	}

	func getTedTalksFilteredCount() -> Int {
		return self.tedtalksFiltered.count
	}

	func getFilteredTedTalks(for tedtalk: Int) -> TedTalk {
		return self.tedtalksFiltered[tedtalk]
	}


	func filterTedTalks(filterDate: String) {
		self.tedtalksFiltered = []
		self.tedtalks.forEach({ (tedtalk) in
			if tedtalk.getYearPublished() == Int(filterDate) {
				self.tedtalksFiltered.append(tedtalk)
			}
		})
	}

}
