//
//  EditScan.swift
//  LastUpdateScan
//
//  Created by Zainab Alatwi  on 24/06/1446 AH.
//

import SwiftUI
import SwiftData
import VisionKit
import AVFoundation

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
        ZStack {
            // تعيين الخلفية التي تغطي كامل الشاشة
            backgroundColor
                .edgesIgnoringSafeArea(.all) // تغطي الشاشة بالكامل
            
            VStack {
                Button(action: {
                    toggleSpeech() // تبديل حالة الصوت
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: isSpeaking ? "pause.circle" : "play.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.db) // تغيير الأيقونة حسب حالة الصوت
                    }
                    .padding()
                    .cornerRadius(25)
                    .foregroundColor(.db)
                }
                
                ScrollView {
                    Text(text)
                        .font(.custom("Maqroo-Regular", size: fontSize))
                        .foregroundColor(fontColor)
                        .padding()
                        .background(Color.clear) // إزالة أي خلفية إضافية للنص
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(spacing: 15) {
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
            }
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
            speakText(text: text) // قراءة النص إذا لم يكن الصوت قيد التشغيل
        }
        isSpeaking.toggle() // تبديل حالة الصوت
    }
    
    func speakText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        
        // محاولة تعيين الصوت السعودي إذا كان متاحًا
        if let voice = AVSpeechSynthesisVoice(language: "ar-SA") {
            speechUtterance.voice = voice
        } else {
            // إذا لم يكن الصوت السعودي متاحًا، النظام سيختار الصوت الافتراضي
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "ar") // اختيار العربية العامة
        }
        
        // تخصيص سرعة الكلام ونغمة الصوت
        speechUtterance.rate = 0.30 // بطيء وواضح
        speechUtterance.pitchMultiplier = 1.1 // نغمة أعلى لزيادة وضوح الصوت
        
        // تشغيل الصوت باستخدام الكائن الأساسي
        speechSynthesizer.speak(speechUtterance)
    }
}
