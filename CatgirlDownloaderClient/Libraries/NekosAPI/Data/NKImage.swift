//
//  NKImage.swift
//  CatgirlDownloaderClient
//
//  Created by Teo Perini on 26/11/23.
//

import Foundation

struct NKImageData : Decodable {
	let id: String				// "id": "ry7gPEpg7",
	let artist: String			// "artist": "karasusou nano",

	let nsfw: Bool				// "nsfw": false,
	let tags: [String]			// "tags": [":d", "..."],

	let pending: Bool?

	let likes: Int?				// "likes": 1,
	let favorites: Int?			// "favorites": 0,

	let uploader: NKUser?
	let approver: NKUser?

	let comments: [String]? 	// "comments": [],
	let createdAt: String			// "createdAt": "2018-06-12T12:04:58.998Z"
}
