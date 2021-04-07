//
//  ViewController.swift
//  PDFKitExample
//
//  Created by 송주 on 2021/04/07.
//

import UIKit

class ViewController: UIViewController {
    
    public var documentData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
    }


}

