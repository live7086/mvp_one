//TreePoseGuideThree
bool TreePoseThreePass(Map<String, int> angles) {
  //min max 值還需要調整

// r_elbow angle
  const int rElbowPerfectMin = 80;
  const int rElbowGoodMin = rElbowPerfectMin - 20;
  const int rElbowPerfectMax = 90;
  const int rElbowGoodMax = rElbowPerfectMax + 20;

  // r_knee angle
  const int rKneePerfectMin = 80;
  const int rKneeGoodMin = rKneePerfectMin - 20;
  const int rKneePerfectMax = 90;
  const int rKneeGoodMax = rKneePerfectMax + 20;

  if (angles.containsKey('r_knee') && angles.containsKey('r_elbow')) {
    int rKnee = angles['r_knee']!;
    int rElbow = angles['r_elbow']!;
    // Angles In Perfect Level
    if (rKnee >= rKneePerfectMin &&
        rKnee <= rKneePerfectMax &&
        rElbow >= rElbowPerfectMin &&
        rElbow <= rElbowPerfectMax) {
      return true; // 符合 Tree Pose 的條件
    }
    // Angles In Good Level
    else if (rKnee >= rKneeGoodMin &&
        rKnee <= rKneeGoodMax &&
        rElbow >= rElbowGoodMin &&
        rElbow <= rElbowGoodMax) {
      return true;
    } else {
      return false; // 不符合條件
    }
  }
  return false; // 不符合條件
}
