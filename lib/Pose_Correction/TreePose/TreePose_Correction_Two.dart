// TreePose_Correction_Two.dart

// 檢查第二個樹式姿勢是否需要修正
String checkTreePoseTwoNeedsCorrection(Map<String, int> angles) {
  String correctionTip = '';

  // 檢查右膝和右髖的角度是否在良好範圍內
  if (angles.containsKey('r_knee') && angles.containsKey('r_hip')) {
    int rKnee = angles['r_knee']!;
    int rHip = angles['r_hip']!;

    // 根據您的需求設定良好角度範圍
    const int rKneeGoodMin = 20;
    const int rKneeGoodMax = 60;
    const int rHipGoodMin = 60;
    const int rHipGoodMax = 120;

    if (rKnee < rKneeGoodMin || rKnee > rKneeGoodMax) {
      // 右膝角度超出良好範圍
      correctionTip = '微調右腿位置,將大腿輕輕抬起,感受穩定和平衡';
    }

    if (rHip < rHipGoodMin || rHip > rHipGoodMax) {
      // 右髖角度超出良好範圍
      correctionTip = '保持上身挺拔,調整右髖角度';
    }
  }

  return correctionTip;
}
