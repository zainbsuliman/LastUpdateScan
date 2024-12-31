

import SwiftUI
import SwiftData
import VisionKit
import AVFoundation
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanEntity.date, order: .reverse) private var scans: [ScanEntity]
    
    @State private var showScannerSheet = false // جعل الكاميرا غير ظاهرة عند البدء
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToText = false
    @State private var extractedText = ""
    @State private var isReturningToScanList = false // متغير يتحكم في العودة إلى السجل
    
    let speechSynthesizer = AVSpeechSynthesizer() // تعريف AVSpeechSynthesizer
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Button(action: {
                        self.showScannerSheet = true // عرض الكاميرا
                        self.isReturningToScanList = false // التأكد من أننا لا نعود للسجل
                    }, label: {
                        VStack {
                            
                            
                            Image(systemName: "doc.text.viewfinder")
                                .font(.title)
                                .foregroundColor(.db)
                            Text(" مسح ضوئي")
                                .font(Font.custom("Maqroo-Regular", size: 17))
                                .bold()

                                .padding()
                                .foregroundColor(.dg)

                        }
                    })
                    .sheet(isPresented: $showScannerSheet, content: {
                        self.makeScannerView()
                    })
                        
                    
                    Spacer()
                    
                    Button(action: {
                        self.showImagePicker = true
                    }, label: {
                        VStack {
                        
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title)
                                .foregroundColor(.db)
                            Text("رفع صورة")
                                .font(Font.custom("Maqroo-Regular", size: 17))
                                .bold()
                                .padding()
                                .foregroundColor(.dg)

                            
                        }
                    })
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage) { image in
                            if let image = image {
                                processImage(image)
                            }
                        }
                    }
                    
                }.padding(50)
                    .padding(.top, -10)
                
                if scans.isEmpty {
                    Text("لايوجد مسح ضوئي حتى الان ")
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
            .navigationTitle("الصفحة الرئيسية")
            
            .onAppear {
                // لا تفتح الكاميرا إذا كان المستخدم قد عاد إلى السجل
                if !isReturningToScanList {
                    self.showScannerSheet = false // لا تفتح الكاميرا بشكل تلقائي
                }
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
            self.isReturningToScanList = true // تم العودة إلى السجل بعد المسح
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
        // speakText(text) // قراءة النص
    }
    
}
#Preview {
    ContentView()
}

