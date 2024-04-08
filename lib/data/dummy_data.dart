import 'package:flutter/material.dart';

import 'package:mvp_one/models/category.dart';
import 'package:mvp_one/models/meal.dart';

// Constants in Dart should be written in lowerCamelcase.
const availableCategories = [
  Category(
    id: 'c1',
    title: '增強平衡和穩定性',
    color: Colors.purple,
  ),
  Category(
    id: 'c2',
    title: '加強核心力量和靈活度',
    color: Colors.red,
  ),
  Category(
    id: 'c3',
    title: '強化腿部力量和耐力',
    color: Colors.orange,
  ),
  Category(
    id: 'c4',
    title: '全部動作',
    color: Color.fromARGB(255, 26, 218, 8),
  ),
];

const dummyMeals = [
  Meal(
    id: 'm1',
    categories: ['c2', 'c4'],
    title: 'BOAT POSE (船式)',
    affordability: Affordability.affordable,
    complexity: Complexity.simple,
    imageUrl: 'https://i.imgur.com/QObVvEu.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 20,
    ingredients: [
      '坐在墊上,雙腿伸直,上身後仰,手掌放在大腿後側,胸部打開。',
      '吸氣時,雙腿向上提,腳尖勾起,形成V字形。',
    ],
    steps: [
      '坐直,雙腿伸直',
      '手掌放在大腿後側,上身略向後仰',
      '吸氣,將雙腿提離地面,保持腿部伸直,腳尖勾起',
      '保持呼吸,維持20-30秒',
    ],
    isGlutenFree: false, //腿部
    isLactoseFree: true, //平衡
    isVegetarian: true, //核心
    isVegan: false, //四肢
  ),
  Meal(
    id: 'm2',
    categories: ['c2', 'c4'],
    title: 'COW POSE(牛式)',
    affordability: Affordability.affordable,
    complexity: Complexity.simple,
    imageUrl: 'https://i.imgur.com/cAY337U.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 10,
    ingredients: [
      '跪在墊上,手掌和膝蓋與肩同寬。',
      '吸氣時,腹部下沉,胸部向上提,頭向上看。',
    ],
    steps: ['跪在墊上,手掌和膝蓋與肩同寬', '吸氣,腹部下沉,胸部向上提,頭向上看', '保持呼吸,維持5-10秒'],
    isGlutenFree: false, //腿部
    isLactoseFree: false, //平衡
    isVegetarian: true, //核心
    isVegan: true, //四肢
  ),
  Meal(
    id: 'm3',
    categories: ['c3', 'c4'],
    title: 'Crescent Lunge(新月弓箭步)',
    affordability: Affordability.pricey,
    complexity: Complexity.simple,
    imageUrl: 'https://i.imgur.com/rbySss7.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 45,
    ingredients: [
      '左腳在前,右腳在後,左膝彎曲呈90度,右腿伸直。',
      '雙手舉高過頭,掌心相對。',
    ],
    steps: [
      '左腳向前一大步,右腳在後',
      '彎曲左膝,保持左膝不超過腳尖',
      '右腿伸直,腳跟提起',
      '雙手舉高過頭,掌心相對',
      '保持呼吸,維持20-30秒,然後換邊'
    ],
    isGlutenFree: true, //腿部
    isLactoseFree: true, //平衡
    isVegetarian: false, //核心
    isVegan: false, //四
  ),
  Meal(
    id: 'm4',
    categories: ['c2', 'c4'],
    title: 'Downward Dog(下犬式)',
    affordability: Affordability.luxurious,
    complexity: Complexity.challenging,
    imageUrl: 'https://i.imgur.com/YlUIHMi.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 60,
    ingredients: [
      '雙手與肩同寬,與地面呈90度。',
      '雙腳與髖同寬,腳跟盡量與地面接觸。',
      '頭部放鬆,眼睛看向腳尖。',
    ],
    steps: [
      '跪在墊上,雙手與肩同寬',
      '吸氣,將髖部向上提,膝蓋離地,腳跟盡量與地面接觸',
      '保持手臂和背部伸直,頭部放鬆',
      '維持5-10個呼吸',
    ],
    isGlutenFree: true, //腿部
    isLactoseFree: false, //平衡
    isVegetarian: false, //核心
    isVegan: false, //四
  ),
  Meal(
    id: 'm5',
    categories: ['c2', 'c4'],
    title: 'Single Leg Downward Facing Dog(單腳下犬式)',
    affordability: Affordability.luxurious,
    complexity: Complexity.simple,
    imageUrl: 'https://i.imgur.com/hMA9LNV.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 15,
    ingredients: [
      '從下犬式開始,將右腳提離地面,伸直右腿,腳尖向上。',
      '保持左腿伸直,左腳跟與地面接觸。',
    ],
    steps: [
      '從下犬式開始',
      '吸氣,將右腳提離地面,伸直右腿,腳尖向上',
      '保持左腿伸直,左腳跟盡量與地面接觸',
      '維持3-5個呼吸,然後換邊',
    ],
    isGlutenFree: true, //腿部
    isLactoseFree: false, //平衡
    isVegetarian: true, //核心
    isVegan: true, //四
  ),
  Meal(
    id: 'm6',
    categories: ['c1', 'c4'],
    title: 'TREE POSE(樹式)',
    affordability: Affordability.affordable,
    complexity: Complexity.hard,
    imageUrl: 'https://i.imgur.com/MwdS0ll.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 240,
    ingredients: [
      '站立,將右腳放在左大腿內側(避免放在膝蓋上)。',
      '雙手合十於胸前或舉高過頭。眼睛注視前方一點。',
    ],
    steps: [
      '站直,雙腳併攏',
      '將右腳放在左大腿內側,腳掌貼著大腿',
      '雙手合十於胸前',
      '眼睛注視前方一點,保持呼吸',
      '維持20-30秒,然後換邊',
    ],
    isGlutenFree: true, //腿部
    isLactoseFree: true, //平衡
    isVegetarian: false, //核心
    isVegan: true, //四
  ),
  Meal(
    id: 'm7',
    categories: ['c2', 'c4'],
    title: 'Upward Facing Dog Pose(上犬式) ',
    affordability: Affordability.affordable,
    complexity: Complexity.simple,
    imageUrl: 'https://i.imgur.com/gP9lF0v.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 20,
    ingredients: [
      '俯臥,雙手放在胸側。',
      '吸氣時,將上身向上提,伸直手臂,僅有手掌和腳尖觸地。',
      '頭向上看,胸部打開。',
    ],
    steps: [
      '俯臥,雙手放在胸側',
      '吸氣,將上身向上提,伸直手臂',
      '僅有手掌和腳尖觸地,腿部離地',
      '頭向上看,胸部打開',
      '保持呼吸,維持15-20秒',
    ],
    isGlutenFree: false, //腿部
    isLactoseFree: false, //平衡
    isVegetarian: true, //核心
    isVegan: true, //四肢
  ),
  Meal(
    id: 'm8',
    categories: ['c3', 'c4'],
    title: 'Warrior I(戰士一式)',
    affordability: Affordability.pricey,
    complexity: Complexity.challenging,
    imageUrl: 'https://i.imgur.com/s3hKZ0h.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 35,
    ingredients: [
      '左腳在前,右腳在後,左膝彎曲呈90度,右腿伸直。',
      '上身正面向前,雙手舉高過頭,掌心相對。',
    ],
    steps: [
      '左腳向前一大步,右腳在後',
      '左腳為正面,右腳約45度角',
      '彎曲左膝,保持左膝不超過腳尖',
      '右腿伸直,腳跟著地',
      '上身正面向前,雙手舉高過頭,掌心相對',
      '保持呼吸,維持20-30秒,然後換邊'
    ],
    isGlutenFree: true, //腿部
    isLactoseFree: true, //平衡
    isVegetarian: false, //核心
    isVegan: false, //四肢
  ),
  Meal(
    id: 'm9',
    categories: ['c3', 'c4'],
    title: 'Warrior II(戰士二式)',
    affordability: Affordability.affordable,
    complexity: Complexity.hard,
    imageUrl: 'https://i.imgur.com/ZHniU18.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 45,
    ingredients: [
      '右腳在前,左腳在後,右膝彎曲呈90度,左腿伸直。',
      '上身側面向前,雙手平舉與地面平行,目視右手指尖。',
    ],
    steps: [
      '右腳向右一大步,右腳約120度角',
      '彎曲右膝,保持右膝不超過腳尖',
      '左腿伸直,腳跟著地',
      '上身側面向前,雙手平舉與地面平行',
      '目視右手指尖,保持呼吸',
      '維持20-30秒,然後換邊',
    ],
    isGlutenFree: true, //腿部
    isLactoseFree: true, //平衡
    isVegetarian: false, //核心
    isVegan: false, //四//四肢
  ),
  Meal(
    id: 'm10',
    categories: ['c1', 'c4'],
    title: 'Warrior III(戰士三式)',
    affordability: Affordability.luxurious,
    complexity: Complexity.simple,
    imageUrl: 'https://i.imgur.com/s72FHow.png',
    videoUrl:
        'https://www.youtube.com/watch?v=Fr5kiIygm0c&pp=ygUIVHJlZVBvc2U%3D', // 新增videoUrl

    duration: 30,
    ingredients: [
      '單腳站立,另一腳向後伸直與地面平行。',
      '上身向前平行於地面,雙手向前伸直或置於身體兩側。',
    ],
    steps: [
      '單腳站立,另一腳向後抬起',
      '上身向前,與另一腿平行於地面',
      '雙手向前伸直或置於身體兩側',
      '眼睛注視前方一點,保持呼吸',
      '維持20-30秒,然後換邊',
    ],
    isGlutenFree: true, //腿部
    isLactoseFree: true, //平衡
    isVegetarian: false, //核心
    isVegan: false, //四肢
  ),
];
