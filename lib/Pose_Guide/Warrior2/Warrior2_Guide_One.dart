//Warrior2GuideOne
bool Warrior2OnePass(Map<String, int> angles) {
  //min max 值還需要調整
  // l_hip angle
  const int lHipPerfectMin = 145;
  const int lHipGoodMin = lHipPerfectMin - 10;
  const int lHipPerfectMax = 155;
  const int lHipGoodMax = lHipPerfectMax + 10;
  // r_knee angle
  const int rKneePerfectMin = 165;
  const int rKneeGoodMin = rKneePerfectMin - 5;
  const int rKneePerfectMax = 175;
  const int rKneeGoodMax = rKneePerfectMax + 5;

  if (angles.containsKey('r_knee') && angles.containsKey('l_hip')) {
    int rKnee = angles['r_knee']!;
    int lHip = angles['l_hip']!;
    // Angles In Perfect Level
    if (rKnee >= rKneePerfectMin &&
        rKnee <= rKneePerfectMax &&
        lHip >= lHipPerfectMin &&
        lHip <= lHipPerfectMax) {
      return true; // 符合條件
    } else if (rKnee >= rKneeGoodMin &&
        rKnee <= rKneeGoodMax &&
        lHip >= lHipGoodMin &&
        lHip <= lHipGoodMax) {
      // Angles In Good Level
      return true;
    } else {
      return false; // 不符合條件
    }
  }
  return false; // 不符合條件
}
