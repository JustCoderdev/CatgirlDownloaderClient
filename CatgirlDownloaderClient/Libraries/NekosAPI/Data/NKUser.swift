//
//  NKUser.swift
//  CatgirlDownloaderClient
//
//  Created by Teo Perini on 26/11/23.
//

import Foundation

struct NKUser : Decodable {
	let id: String				// "id": "BkCBy21se",
	let username: String		// "username": "brussell
}

struct NKUserData : Decodable {
	let createdAt: Date 		// "createdAt": "2017-03-10T04:44:53.870Z",

	let id: String 				// "id": "BkCBy21se",
	let username: String		// "username": "brussell",

	let verified: Bool?			// "verified": true,
	let email: String			// "email": "..."

	let roles: [String] 		// "roles": ["admin"],
	let savedTags: [String]?	// "savedTags": ["paw pose", "pout", ...],


	let uploads: Int			// "uploads": 599,

	let favorites: [String]?	// "favorites": ["S16W9DayG",  "BJrqoC9jM", ...],
	let favoritesReceived: Int	// "favoritesReceived": 322,

	let likes: [String]?		// "likes": ["S1zzesoPz", "ryKe58owM", ...],
	let likesReceived: Int		// "likesReceived": 1258,
}
