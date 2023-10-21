//
//  ContentView.swift
//  SpeedRead
//
//  Created by Tavi Greenfield on 10/20/23.
//

import SwiftUI
import PDFKit
import PencilKit

@available(iOS 15.0, *)
struct ContentView: View {
    
    
    @State var page: Int
    @State var spacing: Float
    @State var fontSize: Float
    @State var margins: Float
    @State var pdfPages: [NSAttributedString]
    @State var drawingPages: [PKDrawing?]
    @State private var canvasView = PKCanvasView()
    
    
    init(page: Int, spacing: Float, fontSize: Float, margins: Float, pdfPages: [NSAttributedString]) {
        self.page = page
        self.spacing = spacing
        self.fontSize = fontSize
        self.margins = margins
        self.pdfPages = pdfPages
        self.drawingPages = [PKDrawing](repeating: PKDrawing(), count: pdfPages.count)
    }
    var body: some View {
            
            
            VStack {
                    HStack{
                        Button(action: {
                            if (page > 0){
                                drawingPages[page] = PKDrawing(strokes: canvasView.drawing.strokes)
                                //canvasView.drawing = PKDrawing()
                                page -= 1
                                
                                canvasView.drawing = drawingPages[page]!
                            }

                        }, label: {Image(systemName: "chevron.left")})
                        Spacer()
                        Text(String(page + 1) + " of " + String(pdfPages.count))
                        Spacer()
                        Button(action: {
                            if (page < pdfPages.count-1){
                                drawingPages[page] = PKDrawing(strokes: canvasView.drawing.strokes)
                                //canvasView.drawing = PKDrawing()
                                page += 1
                                canvasView.drawing = drawingPages[page]!
                            }

                        }, label: {Image(systemName: "chevron.right")})
                    }.padding(10)
                    
                    Divider()
                    // Using the PDFKitView and passing the previously created pdfURL
                
                ScrollView{
                    ZStack{
                        
                        Text(pdfPages[page].string).lineSpacing(CGFloat(spacing * 50)).font(Font.custom("Times New Roman", size: CGFloat(fontSize)*24)).padding(.horizontal,CGFloat(margins * 300))
                        
                        CanvasView(canvasView: $canvasView)
                        
                    }
                }
                
                    
            }.padding()
            
            
        
        
            
            
                
    }
        
}

struct CanvasView {
  @Binding var canvasView: PKCanvasView
    @State var toolPicker = PKToolPicker()
}

private extension CanvasView {
  func showToolPicker() {
    // 1
    toolPicker.setVisible(true, forFirstResponder: canvasView)
    // 2
    toolPicker.addObserver(canvasView)
    // 3
    canvasView.becomeFirstResponder()
  }
}


//struct PDFKitView: UIViewRepresentable {
//    let url: URL // new variable to get the URL of the document
//
//    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
//        // Creating a new PDFVIew and adding a document to it
//        let pdfView = PDFView()
//        pdfView.document = PDFDocument(url: self.url)
//        return pdfView
//    }
//
//    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
//        // we will leave this empty as we don't need to update the PDF
//    }
//}

extension CanvasView: UIViewRepresentable {
  func makeUIView(context: Context) -> PKCanvasView {
      showToolPicker()

      canvasView.drawingPolicy = .pencilOnly
    
      canvasView.isOpaque = false
    return canvasView
  }

  func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}


