import UIKit
import ImagePicker
import Lightbox
import CocoaLumberjack
import CoreLocation
import AVFoundation



class ViewController: UIViewController, ImagePickerDelegate {

  lazy var button: UIButton = self.makeButton()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.white
    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false

    view.addConstraint(
      NSLayoutConstraint(item: button, attribute: .centerX,
                         relatedBy: .equal, toItem: view,
                         attribute: .centerX, multiplier: 1,
                         constant: 0))

    view.addConstraint(
      NSLayoutConstraint(item: button, attribute: .centerY,
                         relatedBy: .equal, toItem: view,
                         attribute: .centerY, multiplier: 1,
                         constant: 0))
  }

  func makeButton() -> UIButton {
    let button = UIButton()
    button.setTitle("Show ImagePicker", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.addTarget(self, action: #selector(showImagePickerButton(button:)), for: .touchUpInside)

    return button
  }

  @objc func showImagePickerButton(button: UIButton) {
    let config = Configuration()
//    config.savePhotosToCameraRoll = false

    let imagePicker = ImagePickerController(configuration: config)
    imagePicker.delegate = self
    ImagePickerController.photoQuality = AVCaptureSession.Preset.photo  // full resolution photo quality output

    present(imagePicker, animated: true, completion: nil)
  }



  // MARK: - ImagePickerDelegate(s)

  func imageStackDidPress(_ imagePicker: ImagePickerController, images: [(image: UIImage?, imageFileURL: URL?)]) {
    DDLogVerbose("")

    guard images.count > 0 else { return }
    DDLogInfo("images.count = \(images.count)")

    let lightboxImages = images.map {
      return LightboxImage(image: $0.image!)
    }

    let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
    imagePicker.present(lightbox, animated: true, completion: nil)
  }


  func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [(image: UIImage?, imageFileURL: URL?)]) {
    DDLogVerbose("")

    guard images.count > 0 else { return }
    for (index, imageData) in images.enumerated() {
      DDLogInfo("image[\(index)] path = \(String(describing: imageData.imageFileURL))")
    }


    imagePicker.dismiss(animated: true, completion: nil)
  }


  func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
    DDLogVerbose("")
    imagePicker.dismiss(animated: true, completion: nil)
  }


}
