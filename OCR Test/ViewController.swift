//
//  ViewController.swift
//  OCR Test
//
//  Created by 창민 on 2020/09/03.
//  Copyright © 2020 창민. All rights reserved.
//

import UIKit
import VisionKit
import Vision

class ViewController: UIViewController {

    private var scanButton = ScanButton(frame: .zero)
    private var scanImageView = ScanImageView(frame: .zero)
    private var ocrTextView = OcrTextView(frame: .zero, textContainer:  nil)
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
        configureOCR()
    }

    private func configure() {
        view.addSubview(scanImageView)
        view.addSubview(ocrTextView)
        view.addSubview(scanButton)
        
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            scanButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            ocrTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            ocrTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            ocrTextView.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -padding),
            ocrTextView.heightAnchor.constraint(equalToConstant: 200),
            
            scanImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            scanImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanImageView.bottomAnchor.constraint(equalTo: ocrTextView.topAnchor, constant: -padding)
        
        ])
        scanButton.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)
    }
    
    // 이미지에서 텍스트를 분석, 추출 기능하는 메소드
    private func configureOCR() {
        
        
        ocrRequest = VNRecognizeTextRequest {(request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
            
            var ocrText = ""
            
            // observations는 인식 된 텍스트가 무엇인지에 대한 일련의 후보로 구성
            // 첫번째 후보를 선택하고 텍스트 문자열에 추가
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else {
                    return
                }
                ocrText += topCandidate.string + "\n"
            }
            
            DispatchQueue.main.async {
                self.ocrTextView.text = ocrText
                self.scanButton.isEnabled = true
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "ko-KR"]
        ocrRequest.usesLanguageCorrection = true
    }

    @objc private func scanDocument(){
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    private func processImage(_ image: UIImage){
        guard let cgImage = image.cgImage else {
            return
        }
        
        ocrTextView.text = ""
        scanButton.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do{
            try requestHandler.perform([self.ocrRequest])
        } catch{
            print(error)
        }
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate{
    
    // 하나 이상의 페이지를 스캔해 저장할 때 호출
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan){
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        scanImageView.image = scan.imageOfPage(at: 0)
        
        processImage(scan.imageOfPage(at: 0))
        
        controller.dismiss(animated: true)
    }
    
    // 스캔할 때 에러가 발생하면 호출 - 여기서 오류 관리해야 함
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }
    
    // VNDocumentCameraViewController 에서 Cancel 버튼이 눌리면 호출
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}

