//
//  onbording.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 24/06/1446 AH.
//
import SwiftUI
import Foundation

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel() // ربط ViewModel
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false // استخدام AppStorage لتخزين الحالة
    
    var body: some View {
        VStack(spacing: 30) {
            // زر التخطي في أعلى اليسار
            HStack {
                Spacer()
                Button(action: {
                    hasSeenOnboarding = true // عند الضغط على "تخطي" نحدث حالة AppStorage
                }) {
                    Text("تخطي ")
                        .font(Font.custom("Maqroo-Regular", size: 22))
                        .foregroundColor(.dg)
                        .padding(.top, 40)
                        .padding(.trailing, 30)
                }
            }
            
            Spacer()
            
            // الجزء الرئيسي: الدائرة الثابتة والمحتوى المتغير
            ZStack {
                Circle()
                    .fill(Color.lb.opacity(0.9))
                    .frame(width: 180, height: 180)
                    .padding(.top, -130)
                
                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.slides.indices, id: \.self) { index in
                        VStack(spacing: 10) {
                            Image(systemName: viewModel.slides[index].image)
                                .font(.system(size: 60, weight: .regular))
                                .foregroundColor(Color.db)
                                .padding(.top, 50)
                            
                            Text(viewModel.slides[index].title)
                                .font(Font.custom("Maqroo-Regular", size: 33))
                                .foregroundColor(.dg)
                                .padding(.bottom, 5)
                                .padding(.top, 73)
                            
                            Text(viewModel.slides[index].description)
                                .font(Font.custom("Maqroo-Regular", size: 22))
                                .foregroundColor(.dg)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 60)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
            Spacer()
            
            // النقاط السفلية أو زر "ابدأ"
            VStack {
                if viewModel.currentPage == viewModel.slides.count - 1 {
                    Button(action: {
                        hasSeenOnboarding = true // تحديث الحالة عند الضغط على "ابدأ"
                    }) {
                        Text("أبدأ")
                            .font(Font.custom("Maqroo-Regular", size: 28))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.db)
                            .cornerRadius(35)
                    }
                    .padding(.horizontal, 100)
                } else {
                    HStack(spacing: 14) {
                        ForEach(viewModel.slides.indices, id: \.self) { index in
                            Circle()
                                .fill(viewModel.currentPage == index ? Color.blue : Color.blue.opacity(0.3))
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
            .frame(height: 50)
            .padding(.bottom, 120)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

// ViewModel لتخزين البيانات المتعلقة بالشرائح



#Preview {
    OnboardingView()
}
