//
//  ImportView.swift
//  SpeedRead
//
//  Created by Tavi Greenfield on 10/20/23.
//

import SwiftUI
import PDFKit

struct ImportView: View {
    
    @State var spacing = 0.5
    @State var fontSize = 0.5
    @State var margins = 0.0
    @State var imported = false
    @State private var importing = false
    @State var pdf: PDFDocument = PDFDocument()
    @State var pdfPages: [NSAttributedString] = []
    
    var body: some View {
        NavigationView{
            VStack{
                Button(action: {importing = true}, label: {
                    if (imported){
                        Text(pdf.documentURL!.absoluteURL.lastPathComponent)
                    }else{
                        Text("Select File")
                    }
                }).fileImporter(
                    isPresented: $importing,
                    allowedContentTypes: [.pdf]
                ) { result in
                    switch result {
                    case .success(let file):
                        pdf = PDFDocument(url: Bundle.main.url(forResource: "Rini 2017 Fake News and Partisan Epistemology", withExtension: "pdf")!)!
                        pdfPages = getPDFPages(pdf: pdf)
                        imported = true
                    case .failure(let error):
                        print(error.localizedDescription)
                    }}.padding(20)
                
                
                Text("Spacing")
                
                
                HStack{
                    Slider(value: $spacing)
                    Text(String((spacing * 5.0).rounded()))
                }
                
                
                Text("margins")
                
                
                HStack{
                    Slider(value: $margins).padding(.horizontal,margins * 300)
                    
                }
                
                
                Text("Font Size")
                
                
                HStack{
                    Slider(value: $fontSize)
                    Text(String((fontSize * 24).rounded()))
                }
                
                if imported{
                    NavigationLink("Import", destination: ContentView(page: 0, spacing: Float(spacing), fontSize: Float(fontSize), margins: Float(margins), pdfPages: pdfPages))

                }
            }.padding(20)
            
            
        }.navigationViewStyle(StackNavigationViewStyle())
            
    }
}

func getPDFPages(pdf: PDFDocument) -> [NSAttributedString] {
        let pageCount = pdf.pageCount
        
        var pages: [NSAttributedString] = []

        for i in 0 ..< pageCount {
            guard let page = pdf.page(at: i) else { continue }
            guard let pageContent = page.attributedString else { continue }
            pages.append(pageContent)
        }
        
        return pages
    
}


struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}
