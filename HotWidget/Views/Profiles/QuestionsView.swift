//
//  QuestionsView.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/31.
//

import SwiftUI

struct QuestionsView: View {
    private let questions: [(quesion:String, anwser:String)] = [("问题1问题1问题1","回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答"),
                                                        ("问题2问题2问题2问题2问题2问题2问题2问题2问题2问题2问题2问题2问题2问题2问题2","回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答"),
                                                        ("问题3问题3问题3问题3问题3问题3问题3问题3问题3问题3问题3问题3问题3","回答回答回答回答回答回答回答回答回答回答回答回答回答回答"),
                                                        ("问题4问题4问题4问题4问题4问题4问题4","回答回答回答回答回答回答回答"),
                                                        ("问题5问题4问题4问题4问题4问题4问题4问题4问题4问题5问题4问题4问题4问题4问题4问题4问题4问题4问题5问题4问题4问题4问题4问题4问题4问题4问题4问题5问题4问题4问题4问题4问题4问题4问题4问题4问题5问题4问题4问题4问题4问题4问题4问题4问题4问题5问题4问题4问题4问题4问题4问题4问题4问题4问题5问题4问题4问题4问题4问题4问题4问题4问题4问题5问题4问题4问题4问题4问题4问题4问题4问题4","回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答"),
                                                        ("问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6问题6","回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答回答")]
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(questions, id: \.quesion) { question in
                            QuestionItem(quetion: question.quesion, anwser: question.anwser)
                                .padding(15)
                        }
                    }
                }
                
                Color(hex: "#303234FF")
                    .frame(height: geo.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            }
        }
        .background(Color(hex: "#303234FF"))
        .navigationTitle("常见问题")
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct QuestionItem: View {
    var quetion: String
    var anwser: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                IndexIcon()
                Text(quetion)
                    .lineLimit(1)
                
                Spacer()
            }
            Text(anwser)
                .lineLimit(3)
                .padding([.leading], 10)
                .padding(.top, 2)
                .padding(.trailing, 10)
        }
        .padding([.top, .bottom], 15.0)
        .background(Color(hex: "#111419FF"))
        .cornerRadius(10)
    }
}

struct IndexIcon: View {
    var body: some View {
        Text("01")
            .padding(.leading, 10.0)
            .frame(width: 37, height: 22)
            .font(.subheadline)
//            .bold()
            .background(LinearGradient(colors: [Color(red: 22/255.0, green: 191/255.0, blue: 235/255.0),
                                                Color(red: 0, green: 231/255.0, blue: 147/255.0)],
                                       startPoint: .leading, endPoint: .trailing))
            .cornerRadius(11, corners: [.bottomRight, .topRight])
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
}
