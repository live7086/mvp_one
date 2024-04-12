//TreePoseGuideOne
bool TreePoseOnePass(Map<String, int> angles) {
  //min max 值還需要調整
  // r_hip angle
  const int r_hip_perfect_min = 150;
  const int r_hip_good_min = r_hip_perfect_min - 20;
  const int r_hip_perfect_max = 160;
  const int r_hip_good_max = r_hip_perfect_max + 20;
  // r_knee angle
  const int r_knee_perfect_min = 150;
  const int r_knee_good_min = r_knee_perfect_min - 20;
  const int r_knee_perfect_max = 160;
  const int r_knee_good_max = r_knee_perfect_max + 20;

  // 假設 "右膝" 是判斷 Tree Pose 的關鍵角度之一
  if (angles.containsKey('r_knee') && angles.containsKey('r_hip')) {
    int r_knee = angles['r_knee']!;
    int r_hip = angles['r_hip']!;
    // Angles In Perfect Level
    if (r_knee >= r_knee_perfect_min &&
        r_knee <= r_knee_perfect_max &&
        r_hip >= r_hip_perfect_min &&
        r_hip <= r_hip_perfect_max) {
      return true; // 符合 Tree Pose 的條件
    } else if (r_knee >= r_knee_good_min &&
        r_knee <= r_knee_good_max &&
        r_hip >= r_hip_good_min &&
        r_hip <= r_hip_good_max) {
      // Angles In Good Level
      return true;
    } else {
      return false; // 不符合條件
    }
  }
  return false; // 不符合條件
}
