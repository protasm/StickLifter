//
//  SceneFactory.swift
//  StickLifter
//
//  Created by Jonathan Stroble on 11/9/25.
//


import SceneKit
import UIKit

class SceneFactory {

    // MARK: - Checkerboard Material
    static func checkerboardMat(squareSize: Int = 16, imageSize: Int = 64) -> SCNMaterial {
        let size = CGSize(width: imageSize, height: imageSize)

        UIGraphicsBeginImageContextWithOptions(size, true, 0)

        let ctx = UIGraphicsGetCurrentContext()!

        UIColor.white.setFill()
        ctx.fill(CGRect(origin: .zero, size: size))
        UIColor.black.setFill()

        for y in stride(from: 0, to: imageSize, by: squareSize) {
            for x in stride(from: 0, to: imageSize, by: squareSize) {
                if ((x / squareSize) + (y / squareSize)) % 2 == 0 {
                    ctx.fill(CGRect(x: x, y: y, width: squareSize, height: squareSize))
                }
            }
        }

        let img = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        let mat = SCNMaterial()

        mat.diffuse.contents = img
        mat.locksAmbientWithDiffuse = true

        return mat
    }


    // MARK: - Orthographic Camera
    static func orthoCam(scale: Double = 4.0, zPosition: Float = 8.0) -> SCNNode {
        let cameraNode = SCNNode()
        let camera = SCNCamera()

        camera.usesOrthographicProjection = true
        camera.orthographicScale = scale
        camera.zNear = 0.1
        camera.zFar = 100
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, zPosition)

        return cameraNode
    }
}
