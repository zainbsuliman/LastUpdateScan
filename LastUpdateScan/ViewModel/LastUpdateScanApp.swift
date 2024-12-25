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
@main
struct LastUpdateScanApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var isActive = false // لحالة SplashScreen
    
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

