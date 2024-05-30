// Warrior2_Correction_Two.dart

// 檢查戰士二式第二個動作是否需要修正
String checkWarrior2TwoNeedsCorrection(Map<String, int> angles) {
  String correctionTip = '';

  // 檢查右膝和左髖的角度是否在良好範圍內
  if (angles.containsKey('r_knee') && angles.containsKey('l_hip')) {
    int rKnee = angles['r_knee']!;
    int lHip = angles['l_hip']!;

    // 根據您的需求設定良好角度範圍
    const int rKneeGoodMin = 120;
    const int rKneeGoodMax = 145;
    const int lHipGoodMin = 120;
    const int lHipGoodMax = 150;

    if (rKnee < rKneeGoodMin || rKnee > rKneeGoodMax) {
      // 右膝角度超出良好範圍
      correctionTip = '請試著調整右腿位置,保持右膝彎曲約90度';
    }

    if (lHip < lHipGoodMin || lHip > lHipGoodMax) {
      // 左髖角度超出良好範圍
      correctionTip = '身體重心在往下壓，左腳再朝外展開一點';
    }
  }

  return correctionTip;
}
