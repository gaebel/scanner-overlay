//
//  ViewController.swift
//  ScannerOverlayDemo
//
//  Created by Jan Gaebel on 26.06.20.
//  Copyright © 2020 Jan Gaebel. All rights reserved.
//

import AVFoundation
import UIKit
import ScannerOverlay

class ViewController: UIViewController {

    // MARK: - ViewController
    
    var headerView = UIView()
    var scannerView = UIView()

    var captureSession: AVCaptureSession!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Demo"
        setupViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func setupScanner() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }

        let scannerOverlayPreviewLayer = ScannerOverlayPreviewLayer(session: captureSession)
        scannerOverlayPreviewLayer.frame = scannerView.bounds
        scannerOverlayPreviewLayer.maskSize = CGSize(width: 200, height: 200)
        scannerOverlayPreviewLayer.videoGravity = .resizeAspectFill
        scannerView.layer.addSublayer(scannerOverlayPreviewLayer)
        metadataOutput.rectOfInterest = scannerOverlayPreviewLayer.rectOfInterest

        captureSession.startRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Setup scanner when all views are layed out correctly according to AutoLayout constraints
        // Important for the scanner overlay, so that it gets the correct frame
        setupScanner()
    }

    func setupViewConstraints() {
        view.addSubview(headerView)
        view.addSubview(scannerView)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        scannerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: scannerView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            scannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - AVCaptureMetadataOutputObjectsDelegate

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print(stringValue)
        }
    }
}

