// TreePose_Correction_Three.dart

// 檢查第三個樹式姿勢是否需要修正
String checkTreePoseThreeNeedsCorrection(Map<String, int> angles) {
  String correctionTip = '';

  // 檢查右膝和右肘的角度是否在良好範圍內
  if (angles.containsKey('r_knee') && angles.containsKey('r_elbow')) {
    int rKnee = angles['r_knee']!;
    int rElbow = angles['r_elbow']!;

    // 根據您的需求設定良好角度範圍
    const int rKneeGoodMin = 60;
    const int rKneeGoodMax = 110;
    const int rElbowGoodMin = 60;
    const int rElbowGoodMax = 110;

    if (rKnee < rKneeGoodMin || rKnee > rKneeGoodMax) {
      // 右膝角度超出良好範圍
      correctionTip = '請調整右邊膝蓋,將大腿輕輕抬起,感受穩定和平衡';
    }

    if (rElbow < rElbowGoodMin || rElbow > rElbowGoodMax) {
      // 右肘角度超出良好範圍
      correctionTip = '請雙手合十找到最自然舒展的位置,';
    }
  }

  return correctionTip;
}
