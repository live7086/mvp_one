// Warrior2_Correction_One.dart

// 檢查戰士二式姿勢是否需要修正
String checkWarrior2OneNeedsCorrection(Map<String, int> angles) {
  String correctionTip = '';

  // 檢查右膝和左髖的角度是否在良好範圍內
  if (angles.containsKey('r_knee') && angles.containsKey('l_hip')) {
    int rKnee = angles['r_knee']!;
    int lHip = angles['l_hip']!;

    // 根據您的需求設定良好角度範圍
    const int rKneeGoodMin = 160;
    const int rKneeGoodMax = 180;
    const int lHipGoodMin = 135;
    const int lHipGoodMax = 165;

    if (rKnee < rKneeGoodMin || rKnee > rKneeGoodMax) {
      // 右膝角度超出良好範圍
      correctionTip = '請保持雙腳朝兩側展開，右腳尖朝向右邊';
    }

    if (lHip < lHipGoodMin || lHip > lHipGoodMax) {
      // 左髖角度超出良好範圍
      correctionTip = '請保持雙腳朝兩側展開，右腳尖朝向右邊';
    }
  }

  return correctionTip;
}
