# ScannerOverlay

ScannerOverlay extends `AVCaptureVideoPreviewLayer` with an overlay. You can define a masked area and setup the corners. 

<table>
  <tbody>
    <thead>
      <tr>
        <th><img src="https://user-images.githubusercontent.com/15332731/84567872-f3bc2d80-ad7b-11ea-97d0-6f6684383345.png" width="300" /></th>
      </tr>
    </thead>
  </tbody>
</table>

## Installation

You can either install it via Swift Package Manager or copy the class from the Sources folder into your project.

## Usage

At first setup your `AVCaptureSession`, then initiate the ScannerOverlay with it, and after that add it as a sublayer to your view.

```swift
  let scannerOverlayPreviewLayer              = ScannerOverlayPreviewLayer(session: captureSession)
  scannerOverlayPreviewLayer.frame            = self.view.bounds
  scannerOverlayPreviewLayer.maskSize         = CGSize(width: 200, height: 200)
  scannerOverlayPreviewLayer.videoGravity     = .resizeAspectFill
  self.view.layer.addSublayer(scannerOverlayPreviewLayer)
```
If you want to limit the video capturing to the masked area you have to set the `rectOfInterest` of your `AVCaptureMetadataOutput`.

```swift
  metadataOutput.rectOfInterest = scannerOverlayPreviewLayer.rectOfInterest
```

> Keep in mind that the overlay won't show in the simulator - for testing run the code on your device.

For an example implementation refer to the demo project in the Sources folder.

## Settings

<table>
  <thead>
    <tr>
      <td><b>Parameter</b></td>
      <td><b>Description</b></td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>maskSize</td>
      <td>Specifies the size of the masked area</td>
    </tr>
    <tr>
      <td>cornerLength</td>
      <td>Specifies the length of the corners</td>
    </tr>
    <tr>
      <td>lineWidth</td>
      <td>Specifies the line width of the corners</td>
    </tr>
    <tr>
      <td>lineColor</td>
      <td>Specifies the line color of the corners</td>
    </tr>
    <tr>
      <td>lineCap</td>
      <td>Specifies the line cap of the corner endpoints </td>
    </tr>
    <tr>
      <td>backgroundColor</td>
      <td>Specifies the backgroundColor of the outer masked area</td>
    </tr>
    <tr>
      <td>cornerRadius</td>
      <td>Specifies the corner radius of the masked area</td>
    </tr>
  </tbody>
</table>

## License

ScannerOverlay is available under the MIT license. See the LICENSE file for more info.
