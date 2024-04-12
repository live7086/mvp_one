//Warrior2GuideOne
bool Warrior2ThreePass(Map<String, int> angles) {
  //min max 值還需要調整
  // r_shoulder angle
  const int rShoulderPerfectMin = 90;
  const int rShoulderGoodMin = rShoulderPerfectMin - 10;
  const int rShoulderPerfectMax = 100;
  const int rShoulderGoodMax = rShoulderPerfectMax + 10;
  // r_knee angle
  const int rKneePerfectMin = 125;
  const int rKneeGoodMin = rKneePerfectMin - 5;
  const int rKneePerfectMax = 140;
  const int rKneeGoodMax = rKneePerfectMax + 5;

  if (angles.containsKey('r_knee') && angles.containsKey('r_shoulder')) {
    int rKnee = angles['r_knee']!;
    int rShoulder = angles['r_shoulder']!;
    // Angles In Perfect Level
    if (rKnee >= rKneePerfectMin &&
        rKnee <= rKneePerfectMax &&
        rShoulder >= rShoulderPerfectMin &&
        rShoulder <= rShoulderPerfectMax) {
      return true; // 符合條件
    } else if (rKnee >= rKneeGoodMin &&
        rKnee <= rKneeGoodMax &&
        rShoulder >= rShoulderGoodMin &&
        rShoulder <= rShoulderGoodMax) {
      // Angles In Good Level
      return true;
    } else {
      return false; // 不符合條件
    }
  }
  return false; // 不符合條件
}
