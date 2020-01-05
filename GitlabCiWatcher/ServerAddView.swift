//
//  ServerAddView.swift
//  GitlabCiWatcher
//
//  Created by Jan Dammshäuser on 03.12.19.
//  Copyright © 2019 Jan Dammshäuser. All rights reserved.
//

import SwiftUI

struct ServerAddView: View {
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

	@ObservedObject var model: ModelProvider

	@State private var server: Partial<Server> = .init()

	var body: some View {
		VStack {
			RelativeImage(image: #imageLiteral(resourceName: "gitlab"))
			Text("Please Enter your Login Data:")
				.padding(.bottom)
			TextField("Server Name", text: self.$server.name)
				.padding(.top)
			TextField("Gitlab URL", text: self.$server.rawUrl)
				.padding(.bottom)
			TextField("Username", text: self.$server.username)
			SecureField("Access Token", text: self.$server.accessToken)
				.padding(.bottom)
			Button(action: { self.addNewServer() }) {
				Text("Add Server")
			}
				.padding(.top)
		}
			.padding(.horizontal)
	}

	private func addNewServer() {
		switch server.validated() {
		case let .valid(server):
			model.addServer(server)

			presentationMode.wrappedValue.dismiss()

		case let .invalid(failures):
			for failure in failures {
				switch failure {
				case \Server.url:
					print("Wrong URL")
				case \Server.username:
					print("Wrong Username")
				case \Server.name:
					print("Wrong Name")
				case \Server.accessToken:
					print("Wrong access Token")
				default:
					fatalError()
				}
			}
		}
	}
}

struct RelativeImage: View {
	@State var image: UIImage
	var body: some View {
		GeometryReader { geometry in
			Image(uiImage: self.image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding()
				.frame(width: geometry.size.width / 2)
		}
	}
}

struct ServerAddView_Previews: PreviewProvider {
	static var previews: some View {
		Current = .mock
		return ServerAddView(model: ModelProvider())
	}
}
