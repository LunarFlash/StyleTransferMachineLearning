//
//  ViewController.swift
//  Style Transfer Starter
//
//  Created by Sai Kambampati on 7/7/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imageView.layer.masksToBounds = true
    }

    @IBAction func chooseImage(_ sender: Any) {
        // Choose Image Here
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func transformImage(_ sender: Any) {
        let model = StarryStyle()
        let styleArray = try? MLMultiArray(shape: [1] as [NSNumber], dataType: .double)
        styleArray?[0] = 1.0
        if let image = pixelBuffer(from: imageView.image!) {
            do {
                let predictionOutput = try model.prediction(image: image, index: styleArray!)

                let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                let tempContext = CIContext(options: nil)
                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
                imageView.image = UIImage(cgImage: tempImage!)
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // The info dictionary may contain multiple representations of the image. You want to use the original.
            guard let selectedImage = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            imageView.image = selectedImage
            dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        // 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 256, height: 256), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // 2
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 256, 256, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }

        // 3
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        // 4
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 256, height: 256, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        // 5
        context?.translateBy(x: 0, y: 256)
        context?.scaleBy(x: 1.0, y: -1.0)

        // 6
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}
