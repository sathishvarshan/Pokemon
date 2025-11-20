//
//  PickerStruct.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation
import SwiftUI
import PhotosUI

enum ImageSource {
    case camera
    case photoLibrary
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let source: ImageSource

    func makeUIViewController(context: Context) -> UIViewController {
        switch source {
        case .camera:
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.delegate = context.coordinator
            return camera

        case .photoLibrary:
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

}

class Coordinator: NSObject,PHPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let parent: ImagePicker
    init(_ parent: ImagePicker) { self.parent = parent }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { image, _ in
            DispatchQueue.main.async {
                self.parent.image = image as? UIImage
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        parent.image = info[.originalImage] as? UIImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

struct ImageFileManager {
    static let shared = ImageFileManager()

    private init() {}

    private var directory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func save(image: UIImage, fileName: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }

        let url = directory.appendingPathComponent(fileName)

        do {
            try data.write(to: url)
            return url
        } catch {
            print("❌ Failed to save image:", error)
            return nil
        }
    }

    func load(fileName: String) -> UIImage? {
        let url = directory.appendingPathComponent(fileName)

        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }

        return image
    }

    func delete(fileName: String) {
        let url = directory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
    }
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }

        default:
            completion(false)
        }
    }

    func requestPhotoPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized || status == .limited)
            }
        }
    }
    
}
