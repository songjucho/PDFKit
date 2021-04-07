//
//  PDFCreator.swift
//  PDFKitExample
//
//  Created by 송주 on 2021/04/07.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
    func createFlyer() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "songjureu"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { context in
            context.beginPage()
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            let text = "하이 헬로우 안녕"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }
        return data
    }
    
}
