//
//  TedTalksManagerProtocol.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 26/11/2021.
//

import Foundation

protocol TedTalksManagerProtocol {
	func retrieve(onCompletion: @escaping (Result<[TedTalk], Errors>) -> Void)
}
