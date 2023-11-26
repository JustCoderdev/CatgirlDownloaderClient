//
//  NKResponses.swift
//  CatgirlDownloaderClient
//
//  Created by Teo Perini on 26/11/23.
//

import Foundation

struct NKResponseError : Decodable {
	let message: String
}


struct NKResponseToken : Decodable {
	let token: String
}

struct NKResponseImage : Decodable {
	let image: NKImageData
}

struct NKResponseImages : Decodable {
	let images: [NKImageData]
}
