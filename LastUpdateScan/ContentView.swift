//
//  ContentView.swift
//  LastUpdateScan
//
//  Created by Zainab Alatwi  on 17/06/1446 AH.
//

//import SwiftUI
//import SwiftData
//import VisionKit
//
//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query(sort: \ScanEntity.date, order: .reverse) private var scans: [ScanEntity]
//    
//    @State private var showScannerSheet = true
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage? = nil
//    @State private var navigateToText = false
//    @State private var extractedText = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    Button(action: {
//                        self.showScannerSheet = true
//                    }, label: {
//                        Image(systemName: "doc.text.viewfinder")
//                            .font(.title)
//                    })
//                    .sheet(isPresented: $showScannerSheet, content: {
//                        self.makeScannerView()
//                    })
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        self.showImagePicker = true
//                    }, label: {
//                        Image(systemName: "photo.on.rectangle.angled")
//                            .font(.title)
//                    })
//                    .sheet(isPresented: $showImagePicker) {
//                        ImagePicker(selectedImage: $selectedImage) { image in
//                            if let image = image {
//                                processImage(image)
//                            }
//                        }
//                    }
//                }
//                .padding()
//                
//                if scans.isEmpty {
//                    Text("No scans yet")
//                        .font(.custom("Maqroo-Regular", size: 20))
//                        .fontWeight(.bold)
//                        .padding()
//                } else {
//                    List(scans) { scan in
//                        NavigationLink(destination: EditScanPage(scanEntity: scan)) {
//                            Text(scan.content)
//                                .lineLimit(1)
//                                .font(.custom("Maqroo-Regular", size: 16))
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Scan OCR")
//            .onAppear {
//                self.showScannerSheet = true
//            }
//        }
//    }
//    
//    private func makeScannerView() -> ScannerView {
//        ScannerView(scanButtonText: "", completion: { textPerPage in
//            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
//                addScan(content: outputText)
//                navigateToTextView(outputText)
//            }
//            self.showScannerSheet = false
//        })
//    }
//    
//    private func processImage(_ image: UIImage) {
//        let textRecognizer = TextRecognizer()
//        textRecognizer.recognizeText(from: image) { recognizedText in
//            DispatchQueue.main.async {
//                if let outputText = recognizedText {
//                    addScan(content: outputText)
//                    navigateToTextView(outputText)
//                }
//            }
//        }
//    }
//    
//    private func addScan(content: String) {
//        let newScan = ScanEntity(content: content)
//        modelContext.insert(newScan)
//        
//        // Save the context immediately to ensure the list updates
//        do {
//            try modelContext.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//        
//        // Remove the oldest scan if there are more than 10
//        if scans.count > 10 {
//            if let oldestScan = scans.last {
//                modelContext.delete(oldestScan)
//                // Save again to reflect the deletion
//                do {
//                    try modelContext.save()
//                } catch {
//                    print("Failed to save context after deletion: \(error)")
//                }
//            }
//        }
//    }
//    
//    private func navigateToTextView(_ text: String) {
//        extractedText = text
//        navigateToText = true
//    }
//}
//
//struct EditScanPage: View {
//    @Environment(\.modelContext) private var modelContext
//    var scanEntity: ScanEntity
//    
//    @State private var backgroundColor: Color = .white
//    @State private var fontSize: CGFloat = 18
//    @State private var fontColor: Color = .black
//    @State private var text: String
//    
//    init(scanEntity: ScanEntity) {
//        self.scanEntity = scanEntity
//        self._text = State(initialValue: scanEntity.content)
//    }
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                Text(text)
//                    .font(.custom("Maqroo-Regular", size: fontSize))
//                    .foregroundColor(fontColor)
//                    .padding()
//                    .background(backgroundColor)
//                    .multilineTextAlignment(.leading)
//            }
//            
//            Spacer()
//            
//            // إعدادات التحكم
//            VStack {
//                HStack {
//                    Text("Background Color:")
//                    ColorPicker("", selection: $backgroundColor)
//                        .labelsHidden()
//                }
//                .padding()
//                
//                HStack {
//                    Text("Font Size:")
//                    Slider(value: $fontSize, in: 12...30, step: 1)
//                        .frame(width: 200)
//                }
//                .padding()
//                
//                HStack {
//                    Text("Font Color:")
//                    ColorPicker("", selection: $fontColor)
//                        .labelsHidden()
//                }
//                .padding()
//            }
//            .background(Color(UIColor.secondarySystemBackground))
//            .cornerRadius(10)
//            .padding()
//            
//            
//        }
//        .navigationBarTitle("Edit Scan", displayMode: .inline)
//    }
//    
//    private func saveChanges() {
//        // تحديث النص في الكائن
//        scanEntity.content = text
//        // حفظ التغييرات
//        do {
//            try modelContext.save()
//        } catch {
//            print("Failed to save changes: \(error)")
//            
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}


//import SwiftUI
//import SwiftData
//import VisionKit
//import AVFoundation
//
//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query(sort: \ScanEntity.date, order: .reverse) private var scans: [ScanEntity]
//    
//    @State private var showScannerSheet = true
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage? = nil
//    @State private var navigateToText = false
//    @State private var extractedText = ""
//    
//    let speechSynthesizer = AVSpeechSynthesizer() // تعريف AVSpeechSynthesizer
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    Button(action: {
//                        self.showScannerSheet = true
//                    }, label: {
//                        Image(systemName: "doc.text.viewfinder")
//                            .font(.title)
//                    })
//                    .sheet(isPresented: $showScannerSheet, content: {
//                        self.makeScannerView()
//                    })
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        self.showImagePicker = true
//                    }, label: {
//                        Image(systemName: "photo.on.rectangle.angled")
//                            .font(.title)
//                    })
//                    .sheet(isPresented: $showImagePicker) {
//                        ImagePicker(selectedImage: $selectedImage) { image in
//                            if let image = image {
//                                processImage(image)
//                            }
//                        }
//                    }
//                }
//                .padding()
//                
//                if scans.isEmpty {
//                    Text("No scans yet")
//                        .font(.custom("Maqroo-Regular", size: 20))
//                        .fontWeight(.bold)
//                        .padding()
//                } else {
//                    List(scans) { scan in
//                        NavigationLink(destination: EditScanPage(scanEntity: scan)) {
//                            Text(scan.content)
//                                .lineLimit(1)
//                                .font(.custom("Maqroo-Regular", size: 16))
//                        }
//                    }
//                }
//            }
//            .navigationTitle("إمسح  هنا !" )
//            .font(.custom("Maqroo-Regular", size: 20))
//            .onAppear {
//                self.showScannerSheet = true
//            }
//        }
//    }
//    
//    private func makeScannerView() -> ScannerView {
//        ScannerView(scanButtonText: "", completion: { textPerPage in
//            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
//                addScan(content: outputText)
//                navigateToTextView(outputText)
//            }
//            self.showScannerSheet = false
//        })
//    }
//    
//    private func processImage(_ image: UIImage) {
//        let textRecognizer = TextRecognizer()
//        textRecognizer.recognizeText(from: image) { recognizedText in
//            DispatchQueue.main.async {
//                if let outputText = recognizedText {
//                    addScan(content: outputText)
//                    navigateToTextView(outputText)
//                }
//            }
//        }
//    }
//    
//    private func addScan(content: String) {
//        let newScan = ScanEntity(content: content)
//        modelContext.insert(newScan)
//        
//        // Save the context immediately to ensure the list updates
//        do {
//            try modelContext.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//        
//        // Remove the oldest scan if there are more than 10
//        if scans.count > 10 {
//            if let oldestScan = scans.last {
//                modelContext.delete(oldestScan)
//                // Save again to reflect the deletion
//                do {
//                    try modelContext.save()
//                } catch {
//                    print("Failed to save context after deletion: \(error)")
//                }
//            }
//        }
//    }
//    
//    private func navigateToTextView(_ text: String) {
//        extractedText = text
//        navigateToText = true
//        speakText(text) // قراءة النص
//    }
//    
//    private func speakText(_ text: String) {
//        let speechUtterance = AVSpeechUtterance(string: text)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ar-SA") // تعيين اللغة العربية
//        speechSynthesizer.speak(speechUtterance) // تحويل النص إلى كلام
//    }
//}
//
//struct EditScanPage: View {
//    @Environment(\.modelContext) private var modelContext
//    var scanEntity: ScanEntity
//    
//    @State private var backgroundColor: Color = .white
//    @State private var fontSize: CGFloat = 18
//    @State private var fontColor: Color = .black
//    @State private var text: String
//    
//    @State private var showColorPicker = true
//    @State private var isSpeaking = false // حالة لتتبع ما إذا كان الصوت يعمل
//    
//    let speechSynthesizer = AVSpeechSynthesizer() // تعريف AVSpeechSynthesizer
//    
//    init(scanEntity: ScanEntity) {
//        self.scanEntity = scanEntity
//        self._text = State(initialValue: scanEntity.content)
//    }
//    
//    var body: some View {
//        
//        VStack {
//            
//            
//            Button(action: {
//                toggleSpeech() // تبديل حالة الصوت
//            }) {
//                HStack {
//                    Spacer()
//                    Image(systemName: isSpeaking ? "speaker.slash.fill" : "speaker.wave.3.fill") // تغيير الأيقونة حسب حالة الصوت
//                    //Text(isSpeaking ? "إيقاف الصوت" : "تشغيل الصوت")
//                        //.font(.custom("Maqroo-Regular", size: fontSize))
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(25)
//                .foregroundColor(.blue)
//            }
//        
//                ScrollView {
//                    Text(text)
//                        .font(.custom("Maqroo-Regular", size: fontSize))
//                        .foregroundColor(fontColor)
//                        .padding()
//                        .background(backgroundColor)
//                        .multilineTextAlignment(.leading)
//                    
//                    
//            }
//            
//            Spacer()
//            
//            VStack {
//                
//                if showColorPicker {
//                    HStack {
//                        Image(systemName: "paintpalette")
//                            .foregroundColor(Color.blue)
//                    
////                       Text("لون الخلفية :")
//                            .font(.custom("Maqroo-Regular", size: fontSize))
//                        ColorPicker("", selection: $backgroundColor)
//                            .labelsHidden()
//                    }
//                    
//
//                    HStack {
//                        Image(systemName: "textformat.size.smaller")
//                            .foregroundColor(Color.blue)
//
//                        //Image(systemName: "character")
//                     
//                            .font(.custom("Maqroo-Regular", size: fontSize))
//                        Slider(value: $fontSize, in: 12...30, step: 1)
//                            .frame(width: 200)
//                        Image(systemName: "character")
//                            .foregroundColor(Color.blue)
//
//                    }
//                    
//                }
//                
//                Button(action: {
//                    withAnimation {
//                        showColorPicker.toggle()
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: showColorPicker ? "arrow.down" : "arrow.up")
//                    }
//                }
//                .padding()
//                
//            
//            }
//            .background(Color(UIColor.secondarySystemBackground))
//            .cornerRadius(25)
//            .padding()
//        }
//        .navigationBarTitle("", displayMode: .inline)
//    }
//    
//    private func saveChanges() {
//        // Update text in the entity
//        scanEntity.content = text
//        // Save changes
//        do {
//            try modelContext.save()
//        } catch {
//            print("Failed to save changes: \(error)")
//        }
//    }
//    
//    private func toggleSpeech() {
//        if isSpeaking {
//            speechSynthesizer.stopSpeaking(at: .immediate) // إيقاف الصوت
//        } else {
//            speakText(text) // قراءة النص إذا لم يكن الصوت قيد التشغيل
//        }
//        isSpeaking.toggle() // تبديل حالة الصوت
//    }
//    
//    private func speakText(_ text: String) {
//        let speechUtterance = AVSpeechUtterance(string: text)
//        
//        // اختيار الصوت العربي السعودي لزيادة الوضوح
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
//        
//        // تقليل سرعة الكلام إلى قيمة بطيئة ولكن واضحة
//        speechUtterance.rate = 0.45 // سرعة الكلام 0.25 لجعل الصوت أبطأ وأكثر وضوحًا
//        
//        // ضبط النغمة إلى قيمة أعلى لزيادة وضوح الصوت
//        speechUtterance.pitchMultiplier = 1.2 // نغمة الصوت أعلى لضمان وضوح أكبر
//        
//        speechSynthesizer.speak(speechUtterance)
//    }
//
//
//}
//
//#Preview {
//    ContentView()
//}
import SwiftUI
import SwiftData
import VisionKit
import AVFoundation

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanEntity.date, order: .reverse) private var scans: [ScanEntity]
    
    @State private var showScannerSheet = true
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToText = false
    @State private var extractedText = ""
    
    let speechSynthesizer = AVSpeechSynthesizer() // تعريف AVSpeechSynthesizer
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.showScannerSheet = true
                    }, label: {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.title)
                            .foregroundColor(.db)
                    })
                    .sheet(isPresented: $showScannerSheet, content: {
                        self.makeScannerView()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.showImagePicker = true
                    }, label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title)
                            .foregroundColor(.db)

                    })
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage) { image in
                            if let image = image {
                                processImage(image)
                            }
                        }
                    }
                }
                .padding()
                
                if scans.isEmpty {
                    Text("No scans yet")
                   // Color.dg
                        .font(.custom("Maqroo-Regular", size: 20))
                        .fontWeight(.bold)
                  
                        .padding()
                } else {
                    List(scans) { scan in
                        NavigationLink(destination: EditScanPage(scanEntity: scan)) {
                            Text(scan.content)
                                .lineLimit(1)
                                .font(.custom("Maqroo-Regular", size: 16))
                        }
                    }
                }
            }
            .navigationTitle("Scan Here !" )
            .font(.custom("Maqroo-Regular", size: 20))
            .onAppear {
                self.showScannerSheet = true
            }
        }
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(scanButtonText: "", completion: { textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                addScan(content: outputText)
                navigateToTextView(outputText)
            }
            self.showScannerSheet = false
        })
    }
    
    private func processImage(_ image: UIImage) {
        let textRecognizer = TextRecognizer()
        textRecognizer.recognizeText(from: image) { recognizedText in
            DispatchQueue.main.async {
                if let outputText = recognizedText {
                    addScan(content: outputText)
                    navigateToTextView(outputText)
                }
            }
        }
    }
    
    private func addScan(content: String) {
        let newScan = ScanEntity(content: content)
        modelContext.insert(newScan)
        
        // Save the context immediately to ensure the list updates
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        
        // Remove the oldest scan if there are more than 10
        if scans.count > 10 {
            if let oldestScan = scans.last {
                modelContext.delete(oldestScan)
                // Save again to reflect the deletion
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save context after deletion: \(error)")
                }
            }
        }
    }
    
    private func navigateToTextView(_ text: String) {
        extractedText = text
        navigateToText = true
      //  speakText(text) // قراءة النص
    }
    
    private func speakText(_ text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ar-SA") // تعيين اللغة العربية
        speechSynthesizer.speak(speechUtterance) // تحويل النص إلى كلام
    }
}

struct EditScanPage: View {
    @Environment(\.modelContext) private var modelContext
    var scanEntity: ScanEntity
    
    @State private var backgroundColor: Color = .white
    @State private var fontSize: CGFloat = 18
    @State private var fontColor: Color = .black
    @State private var text: String
    
    @State private var showColorPicker = true
    @State private var isSpeaking = false // حالة لتتبع ما إذا كان الصوت يعمل
    
    let speechSynthesizer = AVSpeechSynthesizer() // تعريف AVSpeechSynthesizer
    
    init(scanEntity: ScanEntity) {
        self.scanEntity = scanEntity
        self._text = State(initialValue: scanEntity.content)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                toggleSpeech() // تبديل حالة الصوت
            }) {
                HStack {
                    Spacer()
                    Image(systemName: isSpeaking ? "speaker.slash.fill" : "speaker.wave.3.fill") // تغيير الأيقونة حسب حالة الصوت
                }
                .padding()
                //.background(Color.)
                .cornerRadius(25)
                .foregroundColor(.db)
            }
            
            ScrollView {
                Text(text)
                    .font(.custom("Maqroo-Regular", size: fontSize))
                    .foregroundColor(fontColor)
                    .padding()
                    .background(backgroundColor)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            VStack(spacing:15) {
                if showColorPicker {
                    HStack {
                        
                        ColorPicker("", selection: $backgroundColor)
                            .labelsHidden()
                        
                        HStack(spacing: 10) {
                            ForEach([Color.red.opacity(0.2), Color.blue.opacity(0.2), Color.green.opacity(0.2), Color.yellow.opacity(0.2)], id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        backgroundColor = color
                                    }
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "textformat.size.smaller")
                            .foregroundColor(Color.db)
                        
                        Slider(value: $fontSize, in: 12...30, step: 1)
                            .frame(width: 200)
                            .foregroundColor(Color.db)
                        
                        Image(systemName: "character")
                            .foregroundColor(Color.db)
                    }
                }
                
                
                Button(action: {
                    withAnimation {
                        showColorPicker.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: showColorPicker ? "arrow.down" : "arrow.up")
                    }
                }
               
            }
            .padding(30)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(25)
            
//            .padding(30)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    private func saveChanges() {
        // Update text in the entity
        scanEntity.content = text
        // Save changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
    
    private func toggleSpeech() {
        if isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate) // إيقاف الصوت
        } else {
            speakText(text) // قراءة النص إذا لم يكن الصوت قيد التشغيل
        }
        isSpeaking.toggle() // تبديل حالة الصوت
    }
    
    private func speakText(_ text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        
        // اختيار الصوت العربي السعودي لزيادة الوضوح
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
        
        // تقليل سرعة الكلام إلى قيمة بطيئة ولكن واضحة
        speechUtterance.rate = 0.45 // سرعة الكلام 0.25 لجعل الصوت أبطأ وأكثر وضوحًا
        
        // ضبط النغمة إلى قيمة أعلى لزيادة وضوح الصوت
        speechUtterance.pitchMultiplier = 1.2 // نغمة الصوت أعلى لضمان وضوح أكبر
        
        speechSynthesizer.speak(speechUtterance)
    }
}

#Preview {
    ContentView()
}
