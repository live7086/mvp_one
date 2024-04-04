// Warrior2_Correction_Three.dart

// 檢查戰士二式第三個動作是否需要修正
String checkWarrior2ThreeNeedsCorrection(Map<String, int> angles) {
  String correctionTip = '';

  // 檢查右膝和右肩的角度是否在良好範圍內
  if (angles.containsKey('r_knee') && angles.containsKey('r_shoulder')) {
    int rKnee = angles['r_knee']!;
    int rShoulder = angles['r_shoulder']!;

    // 根據您的需求設定良好角度範圍
    const int rKneeGoodMin = 120;
    const int rKneeGoodMax = 145;
    const int rShoulderGoodMin = 80;
    const int rShoulderGoodMax = 110;

    if (rKnee < rKneeGoodMin || rKnee > rKneeGoodMax) {
      // 右膝角度超出良好範圍
      correctionTip = '請試著調整右腿位置,保持右膝彎曲約90度';
    }

    if (rShoulder < rShoulderGoodMin || rShoulder > rShoulderGoodMax) {
      // 右肩角度超出良好範圍
      correctionTip = '保持雙臂與地面平行';
    }
  }

  return correctionTip;
}
