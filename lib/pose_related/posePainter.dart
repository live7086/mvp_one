import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final bool isFrontCamera;

  PosePainter(this.poses, this.isFrontCamera);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    for (var pose in poses) {
      final landmarks = pose.landmarks.values.toList();

      // 定義身體部位之間的連接關係
      final connections = [
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow],
        [PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
        [PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
        [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
        [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
        [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
        [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
        [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
      ];

      for (final connection in connections) {
        final startLandmark = landmarks[connection[0].index];
        final endLandmark = landmarks[connection[1].index];
        //調整完位置，符合角度。
        double startX = startLandmark.x - 150;
        double startY = startLandmark.y - 150;
        double endX = endLandmark.x - 150;
        double endY = endLandmark.y - 150;

        // 如果是前置鏡頭,进行垂直翻转
        if (isFrontCamera) {
          // double startX = startLandmark.x - 150;
          // double endX = endLandmark.x - 150;

          double startY = startLandmark.y;
          double endY = endLandmark.y;

          startX = size.width - startX + 250;
          endX = size.width - endX + 250;
        }

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
