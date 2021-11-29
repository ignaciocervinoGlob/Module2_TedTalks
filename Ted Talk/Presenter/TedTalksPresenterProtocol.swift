//
//  TedTalksPresenterProtocol.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 26/11/2021.
//

import Foundation

protocol TedTalksPresenterProtocol {
	var tedtalks: [TedTalk] {get set}
	var view: TedTalksViewProtocol? {get set}
	var tedtalksFiltered: [TedTalk] {get set}
	var errors: Errors? {get set}

	func getTedTalksCount() -> Int
	func getTedTalks(for tedtalk: Int) -> TedTalk
	func getTedTalksFilteredCount() -> Int
	func getFilteredTedTalks(for tedtalk: Int) -> TedTalk
	func filterTedTalks(filterDate: String)
}
