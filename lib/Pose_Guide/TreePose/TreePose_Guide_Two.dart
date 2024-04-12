//TreePoseGuideTwo
bool TreePoseTwoPass(Map<String, int> angles) {
  //min max 值還需要調整
  // r_hip angle
  const int rHipPerfectMin = 80;
  const int rHipGoodMin = rHipPerfectMin - 20;
  const int rHipPerfectMax = 100;
  const int rHipGoodMax = rHipPerfectMax + 20;
  // r_knee angle
  const int rKneePerfectMin = 20;
  const int rKneeGoodMin = rKneePerfectMin - 20;
  const int rKneePerfectMax = 40;
  const int rKneeGoodMax = rKneePerfectMax + 20;

  // 假設 "右膝" 是判斷 Tree Pose 的關鍵角度之一
  if (angles.containsKey('r_knee') && angles.containsKey('r_hip')) {
    int rKnee = angles['r_knee']!;
    int rHip = angles['r_hip']!;
    // Angles In Perfect Level
    if (rKnee >= rKneePerfectMin &&
        rKnee <= rKneePerfectMax &&
        rHip >= rHipPerfectMin &&
        rHip <= rHipPerfectMax) {
      return true; // 符合 Tree Pose 的條件
    } else if (rKnee >= rKneeGoodMin &&
        rKnee <= rKneeGoodMax &&
        rHip >= rHipGoodMin &&
        rHip <= rHipGoodMax) {
      // Angles In Good Level
      return true;
    } else {
      return false; // 不符合條件
    }
  }
  return false; // 不符合條件
}
