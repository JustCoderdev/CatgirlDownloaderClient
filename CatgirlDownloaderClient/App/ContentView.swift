//
//  ContentView.swift
//  CatgirlDownloaderClient
//
//  Created by Teo Perini on 26/11/23.
//

import SwiftUI

struct ContentView: View {
	@State var currentImage: UIImage?
	@State var currentImageData: NKImageData?

	@State var allowNSFW: Bool = false


	private func loadNewImage() {
		Task {
			self.currentImageData = await NEKO_API.getRandomImages(nsfw: allowNSFW)?.first

			if(currentImageData != nil) {
				self.currentImage = await NEKO_API.getImage(ofId: currentImageData!.id)
			}
		}
	}


    var body: some View {
		NavigationStack {
			VStack {
				if currentImage != nil {
					Image(uiImage: currentImage!)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.padding()

				} else {
					ZStack {
						Rectangle()
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.foregroundColor(.secondary)
							.padding()

						ProgressView()
							.progressViewStyle(.circular)
					} //: ZStack
				}

				Spacer()

				HStack {
					Button {
						guard let currentImage else { return }
						UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil)
					} label: {
						Text("Save")
							.padding(.vertical, 8)
							.frame(maxWidth: .infinity)
					} //: Button
					.buttonStyle(.borderedProminent)
					.tint(.secondary)

					Button {
						loadNewImage()
					} label: {
						Text("Next")
							.padding(.vertical, 8)
							.frame(maxWidth: .infinity)
					} //: Button
					.buttonStyle(.borderedProminent)

				} //: HStack
				.padding()

			} //: VStack

			.onAppear {
				loadNewImage()
			} // .onAppear

			.navigationTitle("Random Catgirls!")

			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Menu {
						Toggle("Allow NSFW", isOn: $allowNSFW)

					} label: {
						Label("More", systemImage: "ellipsis.circle")
					} //: Menu

				} //: ToolbarItem

			} // .toolbar
		} //: NavigationStack

    } //: View

} //: ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
