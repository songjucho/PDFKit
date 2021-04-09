import UIKit

class FlyerBuilderViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var flyerTextEntry: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var contactTextView: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add subtle outline around text views
        bodyTextView.layer.borderColor = UIColor.gray.cgColor
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.cornerRadius = 4.0
        contactTextView.layer.borderColor = UIColor.gray.cgColor
        contactTextView.layer.borderWidth = 1.0
        contactTextView.layer.cornerRadius = 4.0
        
        // Add the share icon and action
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        self.toolbarItems?.append(shareButton)
        
        // Add responder for keyboards to dismiss when tap or drag outside of text fields
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: scrollView, action: #selector(UIView.endEditing(_:))))
        scrollView.keyboardDismissMode = .onDrag
    }
    
    @objc func shareAction() {
        guard let title = flyerTextEntry.text,
              let body = bodyTextView.text,
              let image = imagePreview.image else {
            let alert = UIAlertController(title: "빈칸을 채워주십쇼", message: "아직 덜 쓰셨어요 승생님", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let pdfCreator = PDFCreator(title: title, body: body, image: image, contact: "")
        let pdfData = pdfCreator.createFlyer()
        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectImageTouched(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Photo", message: "Where do you want to select a photo?", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                photoPicker.allowsEditing = false
                
                self.present(photoPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.sourceType = .camera
                
                self.present(cameraPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // preview 버튼 누르면 일어나는 일
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewSegue" {
            guard let vc = segue.destination as? PDFPreviewViewController,
                  let title = flyerTextEntry.text,
                  let body = bodyTextView.text,
                  let image = imagePreview.image else { return }
            let pdfCreator = PDFCreator(title: title, body: body, image: image, contact: "")
            // 데이터 주입 - 캡슐화 안해도 되나?
            vc.documentData = pdfCreator.createFlyer()
        }
    }
}

extension FlyerBuilderViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imagePreview.image = selectedImage
        imagePreview.isHidden = false
        
        dismiss(animated: true, completion: nil)
    }
}

extension FlyerBuilderViewController: UINavigationControllerDelegate {
    // Not used, but necessary for compilation
}
