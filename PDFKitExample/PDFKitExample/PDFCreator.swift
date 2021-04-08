//
//  PDFCreator.swift
//  PDFKitExample
//
//  Created by 송주 on 2021/04/07.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
    
    let title: String
    let body: String
    let image: UIImage
    let contactInfo: String
    
    init(title: String, body: String, image: UIImage, contact: String) {
        self.title = title
        self.body = body
        self.image = image
        self.contactInfo = contact
    }
    
    // pdf 를 만드는 함수
    func createFlyer() -> Data {
        // 문서 이름과 저자를 지정한 메타데이터를 만들고 포맷을 생성해 documentInfo에 할당
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "songjureu",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // 8.5 * 11 인치는 standard U.S. letter size임
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // 지정한 사이즈와 정보가 담긴 포맷으로 렌더러를 생성해줌
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        // pdf 로 만들 내용을 포함하는 블럭, 안에서 그리는 것들이 곧 pdf 내용이 됨
        let data = renderer.pdfData { context in
            // draw 하기 전에 무조건 호출해주어야함. 만약 여러 페이지의 pdf를 만들려면 더 호출해도 됨.
            context.beginPage()
            
            // string draw 하는 부분
            let titleBottom = addTitle(pageRect: pageRect)
            /*
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            let text = "하이 헬로우 안녕"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
             */
        }
        return data
    }
    
    func  addTitle(pageRect: CGRect) -> CGFloat {
        // 폰트 설정 지정 후 attribute에 추가
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: titleFont]
        // 타이틀에 설정을 추가한 후 NSAttributedString 타입 인스턴스로 생성
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        // page를 기준으로 중앙 정렬을 위한 좌표 설정
        let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0 , y: 36, width: titleStringSize.width, height: titleStringSize.height)
        
        attributedTitle.draw(in: titleStringRect)
        // 타이틀을 그린 후의 y좌표를 리턴
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
}
