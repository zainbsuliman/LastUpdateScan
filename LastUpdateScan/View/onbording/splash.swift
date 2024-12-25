//
//  splash.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 24/06/1446 AH.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var isActive: Bool // ارتباط بحالة العرض
    
    var body: some View {
        VStack {
            Image("logo3") // استبدل "YourLogo" باسم صورة الشعار
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 160) // حجم الشعار
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lg.edgesIgnoringSafeArea(.all)) // الخلفية بيضاء
        .onAppear {
            // تأخير الانتقال من SplashScreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isActive = true
            }
        }
    }
}
