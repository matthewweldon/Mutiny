//
//  Toast.swift
//  Mutiny
//
//  Created by Matthew Weldon on 2021-07-19.
//

import SwiftUI

struct Toast: View {
    var muted:Bool
    var imageString:String {return muted ? "toast-mute" : "toast-mic"}
    var message:String {return muted ? "Mic Muted".localized : "Mic Unmuted".localized}

    init(muted:Bool) {
        self.muted = muted
        
    }
    
    var body: some View{
        VStack(){
            Image(imageString)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)

            Text(message).font(.system(size: 20, weight: .light, design: .default))
        }.padding()
    }
    
}

