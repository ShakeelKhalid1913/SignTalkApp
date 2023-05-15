import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:signtalk/src/constants/colors.dart';

class Character extends StatelessWidget {
  const Character({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ModelViewer(
        backgroundColor: AppColors.whiteColor,
        src: 'assets/character/character.glb', // a bundled asset file
        alt: "A 3D model",
        ar: true,
        arModes: const ['scene-viewer', 'webxr', 'quick-look'],
        autoRotate: false,
        cameraControls: true,
        disableZoom: true,
        
      ),
    );
  }
}
