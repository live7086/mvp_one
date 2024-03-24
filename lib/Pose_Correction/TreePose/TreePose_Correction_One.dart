// pose_correction.dart

// 檢查樹式姿勢是否需要修正
String checkTreePoseOneNeedsCorrection(Map<String, int> angles) {
  String correctionTip = '';

  // 檢查右膝和右髖的角度是否在良好範圍內
  if (angles.containsKey('r_knee') && angles.containsKey('r_hip')) {
    int rKnee = angles['r_knee']!;
    int rHip = angles['r_hip']!;

    // 根據您的需求設定良好角度範圍
    const int rKneeGoodMin = 150;
    const int rKneeGoodMax = 180;
    const int rHipGoodMin = 165;
    const int rHipGoodMax = 195;

    if (rKnee < rKneeGoodMin || rKnee > rKneeGoodMax) {
      // 右膝角度超出良好範圍
      correctionTip = '嘗試調整右腿位置,找到最舒適的姿勢}';
    }

    if (rHip < rHipGoodMin || rHip > rHipGoodMax) {
      // 右髖角度超出良好範圍
      correctionTip = '請調整右邊髖部,保持身體中立';
    }
  }

  return correctionTip;
}
