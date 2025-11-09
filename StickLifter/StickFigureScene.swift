import SceneKit
import UIKit

func StickFigureScene() -> SCNScene {
    let scene = SCNScene()
    scene.background.contents = UIColor.white

    // MARK: - Layout Constants
    let spacer: CGFloat = 0


    // MARK: - Head
    let head = BodyPart(
        name: "Head",
        radius: 0.5,
        height: 1.0,
        color: .white,
        axis: .transverse,
        showConnectionMarkers: true
    )

    // MARK: - NeckJoint
    let neckJoint = BodyPart(
        name: "NeckJoint",
        radius: 0.05,
        height: 0.1,
        color: .systemGreen,
        axis: .transverse,
        showConnectionMarkers: true
    )

    // MARK: - Neck
    let neck = BodyPart(
        name: "Neck",
        radius: 0.1,
        height: 0.4,
        color: .white,
        axis: .transverse,
        showConnectionMarkers: true
    )
    
    // MARK: - ShoulderJoint
//    let shoulderJoint = BodyPart(
//        name: "ShoulderJoint",
//        radius: 0.05,
//        height: 0.1,
//        color: .systemGreen,
//        axis: .transverse,
//        showConnectionMarkers: true
//    )

    // MARK: - Shoulders
//    let shoulders = BodyPart(
//        name: "Shoulders",
//        radius: 0.1,
//        height: 2.0,
//        color: .white,
//        axis: .sagittal,
//        showConnectionMarkers: true
//    )

    // MARK: - Connections
    head.connect(from: .left, to: neckJoint, at: .inferior, spacer: spacer)
    neckJoint.connect(from: .inferior, to: neck, at: .superior, spacer: spacer)
//    neck.connect(from: .inferior, to: shoulderJoint, at: .superior, spacer: spacer)
//    shoulderJoint.connect(from: .inferior, to: shoulders, at: .left, spacer: spacer)

    // MARK: - Scene Setup
    scene.rootNode.addChildNode(head)

    // MARK: - Camera
    let cameraNode = SceneFactory.orthoCam(scale: 4.0, zPosition: 8.0)
    
    scene.rootNode.addChildNode(cameraNode)

    return scene
}
