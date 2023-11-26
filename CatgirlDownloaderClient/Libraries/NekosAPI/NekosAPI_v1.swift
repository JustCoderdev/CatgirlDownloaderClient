//
//  NekosAPI.swift
//  CatgirlDownloaderClient
//
//  Created by Teo Perini on 26/11/23.
//

import UIKit

class NekosAPI_v1 {
	private static let BASE_URL = "https://nekos.moe/api/v1"


	private static func printResponseError(_ raw_response: (Data, URLResponse)) {
		let raw_data = raw_response.0
		let response = raw_response.1 as! HTTPURLResponse

		debugPrint("Response Error \(response.statusCode)")
		let body = try? JSONDecoder().decode(NKResponseError.self, from: raw_data)
		debugPrint("Message: \(body?.message ?? "nil")")
	}


	private func getRequest(path: String, method: HTTPMethod,
							withBody body: Data? = nil, withAuth token: String? = nil) -> URLRequest {

		let url = URL(string: path)!
		var request: URLRequest = URLRequest(url: url)

		request.httpMethod = method.rawValue
		request.httpBody = body

		request.setValue("CatgirlDownloaderClient", forHTTPHeaderField: "User-Agent")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue(token, forHTTPHeaderField: "Authorization")

		debugPrint("Creating request... \(method) \(path) \(token ?? "no token") - \n \(String(data: body ?? "no body".data(using: .utf8)!, encoding: .utf8)!)")

		return request
	}
	private func getRequest(at endpoint: String, method: HTTPMethod,
							withBody body: Data? = nil, withAuth token: String? = nil) -> URLRequest {

		getRequest(path: "\(Self.BASE_URL)\(endpoint)", method: method,
				   withBody: body, withAuth: token)
	}
	private func getResponse(from request: URLRequest) async -> (Data, URLResponse)? {
		do {
			let raw_response = try await URLSession.shared.data(for: request)

			let response = raw_response.1 as! HTTPURLResponse
			debugPrint("Getting response... \(response.statusCode) \(response.url?.absoluteString ?? "???")")

			return raw_response

		} catch let error {
			debugPrint("Network Error \(request.url!)")
			debugPrint(error)
			return nil
		}
	}


	// MARK: - Auth
	/** Get token
	 * Allows you to get an account's token from their username and password. */
	public func getToken(_ username: String, _ password: String) async -> String? {
		let request_body = """
		{								\
		 "username": "\(username)",		\
		 "password": "\(password)"		\
		}
		""".data(using: .utf8)

		let request = getRequest(at: "/auth", method: .POST, withBody: request_body)
		guard let raw_response = await getResponse(from: request) else { return nil }

		let raw_data = raw_response.0
		let response = raw_response.1 as! HTTPURLResponse

		guard response.statusCode == 200 else {
			Self.printResponseError(raw_response)
			return nil
		}


		let response_body = try? JSONDecoder().decode(NKResponseToken.self, from: raw_data)
		return response_body?.token
	}

	/** Regenerate token
	 * Will generate a new token for the authorized account. The new token will not be returned, so your application must auth again.
	 * @result return true if it successfully regenerated token */
	public func regenerateToken(token: String) async -> Bool {
		let request = getRequest(at: "/auth/regen", method: .POST, withAuth: token)
		guard let raw_response = await getResponse(from: request) else { return false }

		let response = raw_response.1 as! HTTPURLResponse
		return response.statusCode != 204
	}


	// MARK: - Images
	/** Get image
	 * Returns an Image matching the given ID.
	 */
	public func getImageData(ofId id: String) async -> NKImageData? {
		let request = getRequest(at: "/images/\(id)", method: .GET)
		guard let raw_response = await getResponse(from: request) else { return nil }

		let raw_data = raw_response.0
		let response = raw_response.1 as! HTTPURLResponse

		guard response.statusCode == 200 else { return nil }
		let response_body = try? JSONDecoder().decode(NKResponseImage.self, from: raw_data)

		return response_body?.image
	}


	public func getImage(ofId id: String) async -> UIImage? {
		let request = getRequest(path: "https://nekos.moe/image/\(id)", method: .GET)
		guard let raw_response = await getResponse(from: request) else { return nil }

		let raw_data = raw_response.0
		let response = raw_response.1 as! HTTPURLResponse

		guard response.statusCode == 200 else { return nil }
		return UIImage(data: raw_data)
	}


	/** Get random images
	 * Returns the requested number of random Images.
	 */
	public func getRandomImages(count: Int = 1, nsfw: Bool = false) async -> [NKImageData]? {
		let clamped_count = count > 100 ? 100 : (count < 0 ? 0 : count)

		let request = getRequest(at: "/random/image?count=\(clamped_count)&nsfw=\(nsfw)", method: .GET)
		guard let raw_response = await getResponse(from: request) else { return nil }

		let raw_data = raw_response.0
		let response = raw_response.1 as! HTTPURLResponse
		print(response.statusCode)
		guard response.statusCode == 200 else { return nil }

		let response_body = try? JSONDecoder().decode(NKResponseImages.self, from: raw_data)
		return response_body?.images
	}
}

