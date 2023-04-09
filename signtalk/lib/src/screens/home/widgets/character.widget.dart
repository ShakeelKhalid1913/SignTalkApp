import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Character extends StatelessWidget {
  const Character({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      child: ModelViewer(
        backgroundColor: Color(0xFFFFFFFF),
        src: 'assets/character/character.glb', // a bundled asset file
        alt: "A 3D model",
        ar: true,
        arModes: ['scene-viewer', 'webxr', 'quick-look'],
        autoRotate: false,
        cameraControls: true,
        disableZoom: false,
      ),
    );
  }
}
