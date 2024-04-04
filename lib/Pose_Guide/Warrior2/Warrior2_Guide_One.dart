//Warrior2GuideOne
bool Warrior2OnePass(Map<String, int> angles) {
  //min max 值還需要調整
  // l_hip angle
  const int l_hip_perfect_min = 145;
  const int l_hip_good_min = l_hip_perfect_min - 10;
  const int l_hip_perfect_max = 155;
  const int l_hip_good_max = l_hip_perfect_max + 10;
  // r_knee angle
  const int r_knee_perfect_min = 165;
  const int r_knee_good_min = r_knee_perfect_min - 5;
  const int r_knee_perfect_max = 175;
  const int r_knee_good_max = r_knee_perfect_max + 5;

  if (angles.containsKey('r_knee') && angles.containsKey('l_hip')) {
    int r_knee = angles['r_knee']!;
    int l_hip = angles['l_hip']!;
    // Angles In Perfect Level
    if (r_knee >= r_knee_perfect_min &&
        r_knee <= r_knee_perfect_max &&
        l_hip >= l_hip_perfect_min &&
        l_hip <= l_hip_perfect_max) {
      return true; // 符合條件
    } else if (r_knee >= r_knee_good_min &&
        r_knee <= r_knee_good_max &&
        l_hip >= l_hip_good_min &&
        l_hip <= l_hip_good_max) {
      // Angles In Good Level
      return true;
    } else {
      return false; // 不符合條件
    }
  }
  return false; // 不符合條件
}
