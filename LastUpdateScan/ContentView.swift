//
//  ContentView.swift
//  LastUpdateScan
//
//  Created by Zainab Alatwi  on 17/06/1446 AH.
//

import SwiftUI
import SwiftData
import VisionKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanEntity.date, order: .reverse) private var scans: [ScanEntity]
    
    @State private var showScannerSheet = true
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToText = false
    @State private var extractedText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.showScannerSheet = true
                    }, label: {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.title)
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
            .navigationTitle("Scan OCR")
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
    }
}

struct EditScanPage: View {
    @Environment(\.modelContext) private var modelContext
    var scanEntity: ScanEntity
    
    @State private var backgroundColor: Color = .white
    @State private var fontSize: CGFloat = 18
    @State private var fontColor: Color = .black
    @State private var text: String
    
    init(scanEntity: ScanEntity) {
        self.scanEntity = scanEntity
        self._text = State(initialValue: scanEntity.content)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text(text)
                    .font(.custom("Maqroo-Regular", size: fontSize))
                    .foregroundColor(fontColor)
                    .padding()
                    .background(backgroundColor)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // إعدادات التحكم
            VStack {
                HStack {
                    Text("Background Color:")
                    ColorPicker("", selection: $backgroundColor)
                        .labelsHidden()
                }
                .padding()
                
                HStack {
                    Text("Font Size:")
                    Slider(value: $fontSize, in: 12...30, step: 1)
                        .frame(width: 200)
                }
                .padding()
                
                HStack {
                    Text("Font Color:")
                    ColorPicker("", selection: $fontColor)
                        .labelsHidden()
                }
                .padding()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding()
            
            
        }
        .navigationBarTitle("Edit Scan", displayMode: .inline)
    }
    
    private func saveChanges() {
        // تحديث النص في الكائن
        scanEntity.content = text
        // حفظ التغييرات
        do {
            try modelContext.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
