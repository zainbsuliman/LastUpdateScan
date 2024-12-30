//
//  LastUpdateScanApp.swift
//  LastUpdateScan
//
//  Created by Zainab Alatwi  on 17/06/1446 AH.
//

//import SwiftUI
//
//@main
//struct LastUpdateScanApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .modelContainer(for: [ScanEntity.self])
//
//        }
//    }
//}


import SwiftUI
import UIKit
@main
struct LastUpdateScanApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var isActive = false // لحالة SplashScreen

    
    init() {
        let appear = UINavigationBarAppearance()
        
        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Maqroo-Regular", size: 35)!
        ]
        
        appear.largeTitleTextAttributes = atters
        appear.titleTextAttributes = atters
        
        // تعيين الخلفية إلى شفافة
        appear.backgroundColor = .white
        appear.shadowColor = .clear
        appear.shadowImage = UIImage()
        
        
        
        // تعيين المظاهر لظهور الشريط بشكل صحيح
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                if hasSeenOnboarding {
                    ContentView() // الشاشة الرئيسية
                        .modelContainer(for: [ScanEntity.self]) // ربط البيانات
                } else {
                    OnboardingView() // شاشة المقدمة
                }
            } else {
                SplashScreen(isActive: $isActive) // شاشة البداية
            }
        }
    }
}

