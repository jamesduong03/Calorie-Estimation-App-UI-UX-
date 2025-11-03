import AVFoundation
import SwiftUI

final class CameraViewModel: NSObject, ObservableObject {
    @Published var capturedImage: Image?
    let session = AVCaptureSession()
    private var output = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var cameraPosition: AVCaptureDevice.Position = .back

    func configure() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        // Clear existing inputs
        for input in session.inputs {
            session.removeInput(input)
        }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("Camera input not available.")
            return
        }

        session.addInput(input)

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    func switchCamera() {
        cameraPosition = (cameraPosition == .back) ? .front : .back
        configure()
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let uiImage = UIImage(data: data) else { return }
        DispatchQueue.main.async {
            self.capturedImage = Image(uiImage: uiImage)
        }
    }
}
