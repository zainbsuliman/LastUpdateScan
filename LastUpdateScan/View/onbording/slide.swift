//
//  slide.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 24/06/1446 AH.
//

// تعريف هيكل Slide
import SwiftUI

struct Slide {
    let image: String
    let title: String
    let description: String
}

// ViewModel لتخزين البيانات المتعلقة بالشرائح
class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    
    let slides = [
        Slide(image: "document.viewfinder", title: "مسح النصوص بسهولة", description: "استخدم الكاميرا لمسح النصوص."),
        Slide(image: "paintpalette", title: "تخصيص ألوان الخلفية", description: "قم بتغيير ألوان الخلفية بسهولة باستخدام لوحة ألوان وتدرجات مناسبة."),
        Slide(image: "speaker.wave.1", title: "القراءة الصوتية", description: "حول النصوص إلى صوت واضح ومريح.")
    ]
}


//
//let slides = [
//    Slide(image: "document.viewfinder", title: "Scan Texts Easily", description: "Use the camera to scan texts."),
//    Slide(image: "paintpalette", title: "Customize Texts", description: "Change the text colors to improve readability."),
//    Slide(image: "speaker.wave.1", title: "Text-to-Speech", description: "Convert texts into clear and comfortable speech.")
//]
//}
