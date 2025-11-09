import SceneKit
import UIKit

func StickFigureScene() -> SCNScene {
    let scene = SCNScene()
    
    scene.background.contents = UIColor.white

    // MARK: - Layout constants
    let spacer: CGFloat = 0.0
    let rot90 = SCNVector3(0, 0, CGFloat.pi / 2)

    // MARK: - Parts
    let head = BodyPart(
        name: "Head",
        radius: 0.5,
        height: 1.0,
        color: .white,
        showMarkers: true
    )

    let neck = BodyPart(
        name: "Neck",
        radius: 0.1,
        height: 0.4,
        color: .white,
        showMarkers: true
    )

    let shoulders = BodyPart(
        name: "Shoulders",
        radius: 0.1,
        height: 2.0,
        color: .white,
        showMarkers: true
    )

    let torso = BodyPart(
        name: "Torso",
        radius: 0.4,
        height: 3.0,
        color: .white,
        showMarkers: true
    )

    let leftArm = BodyPart(
        name: "LeftArm",
        radius: 0.1,
        height: 2.0,
        color: .white,
        showMarkers: true
    )

    // Optional reference arrow (shows “forward” Z+)
    let forwardArrow = Arrow(length: 1.0)

    forwardArrow.position = SCNVector3(0, 1.5, 1.0)

    scene.rootNode.addChildNode(forwardArrow)

    // MARK: - Connections
    // Head sits atop the neck
    head.connect(from: .Y2, to: neck, at: .Y1)

    // Neck connects downward to shoulders (rotated horizontally)
//    neck.connect(from: .Y2, to: shoulders, at: .X1, rotation: rot90, spacer: spacer)

    // Shoulders connect downward to torso
//    shoulders.connect(from: .X2, to: torso, at: .Y1, rotation: rot90, spacer: spacer)

    // Left arm connects to the left side of shoulders, hanging vertically
//    shoulders.connect(from: .Z2, to: leftArm, at: .Y1, rotation: rot90, spacer: spacer)

    // MARK: - Scene hierarchy root
    let figureRoot = SCNNode()

    scene.rootNode.addChildNode(figureRoot)
    figureRoot.addChildNode(head)

    // MARK: - Camera
    let cameraNode = SceneFactory.orthoCam(scale: 4.0, zPosition: 8.0)

    scene.rootNode.addChildNode(cameraNode)

    return scene
}
