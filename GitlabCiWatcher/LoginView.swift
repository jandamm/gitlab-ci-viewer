//
//  LoginView.swift
//  GitlabCiWatcher
//
//  Created by Jan Dammshäuser on 03.12.19.
//  Copyright © 2019 Jan Dammshäuser. All rights reserved.
//

import SwiftUI

struct LoginView: View {
	@State var url: String = ""
	@State var username: String = ""
	@State var password: String = ""
    var body: some View {

				VStack {
					RelativeImage(image: #imageLiteral(resourceName: "gitlab"))
					Text("Please Enter your Login Data:")
						.padding(.bottom)
					TextField("Gitlab URL", text: self.$url)
						.padding(.top)
					TextField("Username", text: self.$username)
					SecureField("Password", text: self.$password)
						.padding(.bottom)
					Button(action: { print("tapped" as Any) }) {
						Text("Enter")
					}
					.padding(.top)
				}
				.padding(.horizontal)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
			LoginView()
    }
}
