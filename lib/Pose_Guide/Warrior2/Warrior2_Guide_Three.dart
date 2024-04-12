//Warrior2GuideOne
bool Warrior2ThreePass(Map<String, int> angles) {
  //min max 值還需要調整
  // r_shoulder angle
  const int r_shoulder_perfect_min = 90;
  const int r_shoulder_good_min = r_shoulder_perfect_min - 10;
  const int r_shoulder_perfect_max = 100;
  const int r_shoulder_good_max = r_shoulder_perfect_max + 10;
  // r_knee angle
  const int r_knee_perfect_min = 125;
  const int r_knee_good_min = r_knee_perfect_min - 5;
  const int r_knee_perfect_max = 140;
  const int r_knee_good_max = r_knee_perfect_max + 5;

  if (angles.containsKey('r_knee') && angles.containsKey('r_shoulder')) {
    int r_knee = angles['r_knee']!;
    int r_shoulder = angles['r_shoulder']!;
    // Angles In Perfect Level
    if (r_knee >= r_knee_perfect_min &&
        r_knee <= r_knee_perfect_max &&
        r_shoulder >= r_shoulder_perfect_min &&
        r_shoulder <= r_shoulder_perfect_max) {
      return true; // 符合條件
    } else if (r_knee >= r_knee_good_min &&
        r_knee <= r_knee_good_max &&
        r_shoulder >= r_shoulder_good_min &&
        r_shoulder <= r_shoulder_good_max) {
      // Angles In Good Level
      return true;
    } else {
      return false; // 不符合條件
    }
  }
  return false; // 不符合條件
}
