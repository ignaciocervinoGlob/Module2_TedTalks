//
//  TedTalksManager.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 16/11/2021.
//

import Foundation

enum Errors: Error {
	case fileNotFound
	case invalidData
	case decodingProblem(String)
}

protocol TedTalksManagerProtocol {
	func retrieve(onCompletion: @escaping (Result<[TedTalk], Errors>) -> Void)
}

class TedTalksManager: TedTalksManagerProtocol {
	func retrieve(onCompletion: @escaping (Result<[TedTalk], Errors>) -> Void) {

		DispatchQueue.global(qos: .background).async {
			let url = Bundle.main.url(forResource: "tedTalks", withExtension: "json")
			guard let myUrl = url else {
				onCompletion(.failure(.fileNotFound))
				return
			}
			guard let myData = try? Data(contentsOf: myUrl) else {
				onCompletion(.failure(.invalidData))
				return
			}
			do {
				let tedtalks = try JSONDecoder().decode([TedTalk].self, from: myData)
				onCompletion(.success(tedtalks))
			} catch DecodingError.dataCorrupted(_) {
				onCompletion(.failure(.decodingProblem("Data corrupted")))
			} catch DecodingError.keyNotFound(let codingKey, _) {
				onCompletion(.failure(.decodingProblem(codingKey.stringValue)))
			} catch let error {
				onCompletion(.failure(.decodingProblem(error.localizedDescription)))
			}
		}
	}
}
