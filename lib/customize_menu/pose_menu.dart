import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/customize_menu/menu_move_result.dart';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mvp_one/customize_menu/menu_resume.dart';
import 'package:mvp_one/pose_related/posePainter.dart';

// TreePose imports
import '../Pose_Guide/TreePose/TreePose_Guide_One.dart';
import '../Pose_Guide/TreePose/TreePose_Guide_Two.dart';
import '../Pose_Guide/TreePose/TreePose_Guide_Three.dart';
import '../Pose_Correction/TreePose/TreePose_Correction_One.dart';
import '../Pose_Correction/TreePose/TreePose_Correction_Two.dart';
import '../Pose_Correction/TreePose/TreePose_Correction_Three.dart';
// Warrior2 imports
import '../Pose_Guide/Warrior2/Warrior2_Guide_One.dart';
import '../Pose_Guide/Warrior2/Warrior2_Guide_Two.dart';
import '../Pose_Guide/Warrior2/Warrior2_Guide_Three.dart';
import '../Pose_Correction/Warrior2/Warrior2_Correction_One.dart';
import '../Pose_Correction/Warrior2/Warrior2_Correction_Two.dart';
import '../Pose_Correction/Warrior2/Warrior2_Correction_Three.dart';

class GuideWindow extends StatefulWidget {
  final String guideImagePath;

  GuideWindow({required this.guideImagePath});

  @override
  _GuideWindowState createState() => _GuideWindowState();
}

class _GuideWindowState extends State<GuideWindow> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      top: 50,
      child: Container(
        width: 120,
        height: 210,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            widget.guideImagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class MenuCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final List<Meal> selectedMeals;
  final List<int> mealCounts;

  const MenuCameraScreen({
    Key? key,
    required this.cameras,
    required this.selectedMeals,
    required this.mealCounts,
  }) : super(key: key);

  @override
  MenuCameraScreenState createState() => MenuCameraScreenState();
}

class CustomMenuItem {
  final String name;
  final String description;
  final String iconPath;
  final String mealId;

  CustomMenuItem({
    required this.name,
    required this.description,
    required this.iconPath,
    required this.mealId,
  });
}

List<CustomMenuItem> getCustomMenuItems() {
  List<CustomMenuItem> customMenuItems = [];

  for (var meal in dummyMeals) {
    customMenuItems.add(
      CustomMenuItem(
        name: meal.title,
        description: '描述或其他相關資訊',
        iconPath: 'assets/icons/menu_item_icon.png',
        mealId: meal.id, // 傳遞 meal.id 給 mealId 屬性
      ),
    );
  }

  return customMenuItems;
}

class MenuCameraScreenState extends State<MenuCameraScreen>
    with WidgetsBindingObserver {
  List<CustomMenuItem> _customMenuItems = []; //用於存儲新增過後的菜單項
  bool _isResuming = false; //頁面是否需要恢復
  late Meal meal; // 當前正在執行的動作
  late Timer _timer; // 計時器
  int _elapsedSeconds = 0; // 經過的秒數
  bool _isAllPosesCompleted = false; // 所有動作是否完成的標誌
  FlutterTts flutterTts = FlutterTts(); // 語音合成物件
  bool ischeckPoseLooping = false; // 檢查姿勢循環的標誌
  String poseTip = ''; // 姿勢提示
  bool _shouldUpdateUI = false; // 是否需要更新 UI 的標誌
  int poseIndex = 0; // 當前完成的最高動作階段
  bool isDetecting = false; // 是否正在檢測姿勢的標誌
  Map<String, int> angles = {}; // 存儲身體各部位的角度
  late PoseDetector _poseDetector; // 姿勢檢測器
  List<Pose> poses = []; // 檢測到的姿勢列表
  late CameraController _cameraController; // 相機控制器
  bool isFrontCamera = true; // 是否使用前置相機
  double _fpsAverage = 0.0; // 平均 FPS
  int _fpsCounter = 0; // FPS 計數器
  DateTime? _lastFrameTime; // 上一幀的時間
  String poseType = ''; // 姿勢類型
  int currentMealIndex = 0; // 當前執行的動作索引
  int currentMealCount = 0; // 當前動作的執行次數

  bool _showFps = true;
  bool _showAngles = false;
  double _fontSize = 16.0; // 預設為中等字體大小
  double _tipBoxHeight = 50.0; // 語音提示框的高度
  bool isTreePoseCase1Played = false;
  bool isTreePoseCase2Played = false;
  bool isTreePoseCase3Played = false;
  bool isWarrior2Case1Played = false;
  bool isWarrior2Case2Played = false;
  bool isWarrior2Case3Played = false;

  String _guideText = '';
  String _guideImagePath = '';

  String _treePoseRearImage1 = 'assets/images/tree_pose_rear_1.jpg';
  String _treePoseRearImage2 = 'assets/images/tree_pose_rear_2.jpg';
  String _treePoseRearImage3 = 'assets/images/tree_pose_rear_3.jpg';
  String _warrior2RearImage1 = 'assets/images/warrior2_pose_rear_1.jpg';
  String _warrior2RearImage2 = 'assets/images/warrior2_pose_rear_2.jpg';
  String _warrior2RearImage3 = 'assets/images/warrior2_pose_rear_3.jpg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    meal = widget.selectedMeals[currentMealIndex];
    currentMealCount = widget.mealCounts[currentMealIndex];
    _initializeCamera();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        model: PoseDetectionModel.base,
        mode: PoseDetectionMode.stream,
      ),
    );
    checkPoses();

    // 賦值新增過後的菜單項
    _customMenuItems = widget.selectedMeals.map((meal) {
      return CustomMenuItem(
        name: meal.title,
        description: '描述或其他相關資訊',
        iconPath: 'assets/icons/menu_item_icon.png',
        mealId: meal.id,
      );
    }).toList();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('設置'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('鏡頭翻轉'),
                    value: !isFrontCamera,
                    onChanged: (value) {
                      setState(() {
                        isFrontCamera = !value;
                        _initializeCamera();
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('顯示FPS'),
                    value: _showFps,
                    onChanged: (value) {
                      setState(() {
                        _showFps = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('顯示角度'),
                    value: _showAngles,
                    onChanged: (value) {
                      setState(() {
                        _showAngles = value;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('字體大小'),
                    trailing: DropdownButton<double>(
                      value: _fontSize,
                      onChanged: (double? newValue) {
                        setState(() {
                          _fontSize = newValue!;
                          _tipBoxHeight = _fontSize * 3; // 根據字體大小調整提示框高度
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 12.0,
                          child: Text('小'),
                        ),
                        DropdownMenuItem(
                          value: 16.0,
                          child: Text('中'),
                        ),
                        DropdownMenuItem(
                          value: 20.0,
                          child: Text('大'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  void _toggleCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
      _initializeCamera();
    });
  }

  void _toggleFps() {
    setState(() {
      _showFps = !_showFps;
    });
  }

  void _toggleAngles() {
    setState(() {
      _showAngles = !_showAngles;
    });
  }

  void _changeFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

  Future<void> _initializeCamera() async {
    // 初始化相機
    final CameraDescription selectedCamera = isFrontCamera
        ? widget.cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front)
        : widget.cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(selectedCamera, ResolutionPreset.high);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
      _startTimer(); // 啟動計時器
      _cameraController.startImageStream((CameraImage image) {
        if (!isDetecting) {
          isDetecting = true;
          _detectPose(image, isFrontCamera);
        }
      });
    }
  }

  void _startTimer() {
    // 啟動計時器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        _elapsedSeconds++;
      });
      if (_isAllPosesCompleted) {
        _timer.cancel();
        await Future.delayed(const Duration(seconds: 5));
        _navigateToResultPage();
      }
    });
  }

  void _navigateToResultPage() {
    // 導航到結果頁面
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MenuResultPage(
          duration: _elapsedSeconds,
        ),
      ),
    );
  }

  Future<void> _detectPose(CameraImage image, bool isFrontCamera) async {
    // 檢測姿勢
    if (_isAllPosesCompleted) {
      await Future.delayed(const Duration(seconds: 1));
      return; // 如果所有動作已完成,直接返回,不再進行姿勢檢測
    }

    final InputImageRotation rotation = isFrontCamera
        ? InputImageRotation.rotation270deg // 前置相機
        : InputImageRotation.rotation90deg; // 後置相機

    final InputImage inputImage = InputImage.fromBytes(
      bytes: _concatenatePlanes(image.planes),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    try {
      final List<Pose> detectedPoses =
          await _poseDetector.processImage(inputImage);
      this.angles.clear();

      if (detectedPoses.isNotEmpty) {
        final Pose firstPose = detectedPoses.first;
        // 獲取身體各部位的座標
        final PoseLandmark? leftShoulder =
            firstPose.landmarks[PoseLandmarkType.leftShoulder];
        final PoseLandmark? leftElbow =
            firstPose.landmarks[PoseLandmarkType.leftElbow];
        final PoseLandmark? leftWrist =
            firstPose.landmarks[PoseLandmarkType.leftWrist];
        final PoseLandmark? leftHip =
            firstPose.landmarks[PoseLandmarkType.leftHip];
        final PoseLandmark? leftKnee =
            firstPose.landmarks[PoseLandmarkType.leftKnee];
        final PoseLandmark? leftAnkle =
            firstPose.landmarks[PoseLandmarkType.leftAnkle];
        final PoseLandmark? leftIndex =
            firstPose.landmarks[PoseLandmarkType.leftIndex];
        final PoseLandmark? leftFootIndex =
            firstPose.landmarks[PoseLandmarkType.leftFootIndex];
        final PoseLandmark? rightShoulder =
            firstPose.landmarks[PoseLandmarkType.rightShoulder];
        final PoseLandmark? rightElbow =
            firstPose.landmarks[PoseLandmarkType.rightElbow];
        final PoseLandmark? rightWrist =
            firstPose.landmarks[PoseLandmarkType.rightWrist];
        final PoseLandmark? rightHip =
            firstPose.landmarks[PoseLandmarkType.rightHip];
        final PoseLandmark? rightKnee =
            firstPose.landmarks[PoseLandmarkType.rightKnee];
        final PoseLandmark? rightAnkle =
            firstPose.landmarks[PoseLandmarkType.rightAnkle];
        final PoseLandmark? rightIndex =
            firstPose.landmarks[PoseLandmarkType.rightIndex];
        final PoseLandmark? rightFootIndex =
            firstPose.landmarks[PoseLandmarkType.rightFootIndex];

        // 計算身體各部位的角度
        if (rightIndex != null && rightWrist != null && rightElbow != null) {
          final int r_wrist =
              getAngle(rightIndex, rightWrist, rightElbow).round();
          angles['r_wrist'] = r_wrist;
        }
        if (rightWrist != null && rightElbow != null && rightShoulder != null) {
          final int r_elbow =
              getAngle(rightWrist, rightElbow, rightShoulder).round();
          angles['r_elbow'] = r_elbow;
        }
        if (rightElbow != null && rightShoulder != null && rightHip != null) {
          final int r_shoulder =
              getAngle(rightElbow, rightShoulder, rightHip).round();
          angles['r_shoulder'] = r_shoulder;
        }
        if (rightShoulder != null && rightHip != null && rightKnee != null) {
          final int r_hip =
              getAngle(rightShoulder, rightHip, rightKnee).round();
          angles['r_hip'] = r_hip;
        }
        if (rightHip != null && rightKnee != null && rightAnkle != null) {
          final int r_knee = getAngle(rightHip, rightKnee, rightAnkle).round();
          angles['r_knee'] = r_knee;
        }
        if (rightKnee != null && rightAnkle != null && rightFootIndex != null) {
          final int r_footindex =
              getAngle(rightKnee, rightAnkle, rightFootIndex).round();
          angles['r_footindex'] = r_footindex;
        }
        if (leftIndex != null && leftWrist != null && leftElbow != null) {
          final int l_wrist = getAngle(leftIndex, leftWrist, leftElbow).round();
          angles['l_wrist'] = l_wrist;
        }
        if (leftWrist != null && leftElbow != null && leftShoulder != null) {
          final int l_elbow =
              getAngle(leftWrist, leftElbow, leftShoulder).round();
          angles['l_elbow'] = l_elbow;
        }
        if (leftElbow != null && leftShoulder != null && leftHip != null) {
          final int l_shoulder =
              getAngle(leftElbow, leftShoulder, leftHip).round();
          angles['l_shoulder'] = l_shoulder;
        }
        if (leftShoulder != null && leftHip != null && leftKnee != null) {
          final int l_hip = getAngle(leftShoulder, leftHip, leftKnee).round();
          angles['l_hip'] = l_hip;
        }
        if (leftHip != null && leftKnee != null && leftAnkle != null) {
          final int l_knee = getAngle(leftHip, leftKnee, leftAnkle).round();
          angles['l_knee'] = l_knee;
        }
        if (leftKnee != null && leftAnkle != null && leftFootIndex != null) {
          final int l_footindex =
              getAngle(leftKnee, leftAnkle, leftFootIndex).round();
          angles['l_footindex'] = l_footindex;
        }
      }
      setState(() {
        poses = detectedPoses;
      });
    } catch (e) {
      print("Error detecting pose: $e");
    } finally {
      isDetecting = false;
    }
  }

  Future<void> checkPoses() async {
    // 檢查姿勢
    print("1232123");
    _shouldUpdateUI = false;
    await _checkPose(poseIndex); // 從第一個動作開始檢查
  }

  Future<void> _checkPose(int poseIndex) async {
    print('Current meal title: ${meal.title}');
    print('Current pose index: $poseIndex');
    // 設置語音的語言和聲音
    await flutterTts.setLanguage("zh-TW");
    await flutterTts.setVoice(
        {"name": "cmn-tw-x-ctd-network", "locale": "zh-TW"}); //男生聲音-粗曠

    if (!ischeckPoseLooping) {
      String correctionTip = ''; // 存儲修正建議的變數
      bool result = false; // 存儲姿勢檢查結果的變數
      String poseTipText = ''; // 存儲姿勢提示文字的變數
      // Pose的動作修正Switch
      switch (meal.title) {
        case 'TREE POSE(樹式)':
          switch (poseIndex) {
            case 0:
              // 播放第一個樹式姿勢的語音引導和示範圖片
              await _playPoseGuide('TreePose', 1);
              // 檢查第一個樹式姿勢是否需要修正
              correctionTip = checkTreePoseOneNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(const Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await TreePoseOnePass(angles);
                  poseTipText = '這是 樹式1';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(const Duration(seconds: 2));
                poseTipText = '這是 樹式1';
                break;
              }

            case 1:
              // 播放第二個樹式姿勢的語音引導和示範圖片
              await _playPoseGuide('TreePose', 2);
              // 檢查第二個樹式姿勢是否需要修正
              correctionTip = checkTreePoseTwoNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(const Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await TreePoseTwoPass(angles);
                  poseTipText = '這是 樹式2';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(const Duration(seconds: 2));
                poseTipText = '這是 樹式2';
                break;
              }
            case 2:
              // 播放第三個樹式姿勢的語音引導和示範圖片
              await _playPoseGuide('TreePose', 3);
              // 檢查第三個樹式姿勢是否需要修正
              correctionTip = checkTreePoseThreeNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(const Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await TreePoseThreePass(angles);
                  poseTipText = '這是 樹式3';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(const Duration(seconds: 2));
                poseTipText = '這是 樹式3';
                break;
              }
            default:
              return;
          }
        case 'Warrior II(戰士二式)':
          switch (poseIndex) {
            case 0:
              // 播放第一個戰士二式姿勢的語音引導和示範圖片
              await _playPoseGuide('Warrior2', 1);
              // 檢查第一個樹式姿勢是否需要修正
              correctionTip = checkWarrior2OneNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(const Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await Warrior2OnePass(angles);
                  poseTipText = '這是 戰士二式1';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(const Duration(seconds: 2));
                poseTipText = '這是 戰士二式1';
                break;
              }

            case 1:
              // 播放第二個戰士二式姿勢的語音引導和示範圖片
              await _playPoseGuide('Warrior2', 2);
              // 檢查第二個樹式姿勢是否需要修正
              correctionTip = checkWarrior2TwoNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(const Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await Warrior2TwoPass(angles);
                  poseTipText = '這是 戰士二式2';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(const Duration(seconds: 2));
                poseTipText = '這是 戰士二式2';
                break;
              }
            case 2:
              // 播放第三個戰士二式姿勢的語音引導和示範圖片
              await _playPoseGuide('Warrior2', 3);
              // 檢查第三個樹式姿勢是否需要修正
              correctionTip = checkWarrior2ThreeNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(const Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await Warrior2ThreePass(angles);
                  poseTipText = '這是 戰士二式3';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(const Duration(seconds: 2));
                poseTipText = '這是 戰士二式3';
                break;
              }
            default:
              return;
          }
      }

      if (result) {
        // 當前動作檢查通過
        if (poseIndex < 2) {
          // 進入下一個動作檢查
          poseTip = '$poseTipText通過，進入下一個動作';
          flutterTts.speak(poseTip);
          await Future.delayed(const Duration(seconds: 5));
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 700));
          await _checkPose(poseIndex + 1);
        } else {
          // 如果當前階段通過且是最後一個階段
          currentMealCount--;
          if (currentMealCount > 0) {
            // 如果當前動作還有剩餘次數，重新開始檢查
            poseTip = '$poseTipText通過，還有 $currentMealCount 次';
            flutterTts.speak(poseTip);
            await Future.delayed(const Duration(seconds: 5));
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 700));
            await _checkPose(0);
          } else {
            // 如果當前動作完成，進入下一個動作
            currentMealIndex++;
            if (currentMealIndex < widget.selectedMeals.length) {
              meal = widget.selectedMeals[currentMealIndex];
              currentMealCount = widget.mealCounts[currentMealIndex];
              poseTip = '$poseTipText通過，進入下一個動作';
              flutterTts.speak(poseTip);
              await Future.delayed(const Duration(seconds: 5));
              setState(() {});
              await Future.delayed(const Duration(milliseconds: 700));
              await _checkPose(0);
            } else {
              // 如果所有動作都完成，提示所有動作完成
              poseTip = '$poseTipText通過，所有動作完成';
              flutterTts.speak(poseTip);
              await Future.delayed(const Duration(seconds: 5));
              flutterTts.speak("KongShi KongShi");
              FlutterTts().stop();
              await Future.delayed(const Duration(seconds: 5));
              setState(() {
                _isAllPosesCompleted = true; // 設置標誌變量為 true
              });
            }
          }
        }
      } else {
        // 如果當前階段未通過,提示重試當前階段
        poseTip = '$poseTipText未通過，請重試';
        flutterTts.speak(poseTip);
        await Future.delayed(const Duration(seconds: 5));
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 700));
        await _checkPose(poseIndex);
      }
    } else {
      return;
    }
  }

  Future<void> _playPoseGuide(String pose, int step) async {
    String guideText = '';
    String guideImagePath = '';

    switch (pose) {
      case 'TreePose':
        switch (step) {
          case 1:
            guideText = '請按照圖片中的姿勢站立,雙手抱住右膝。';
            guideImagePath = isFrontCamera
                ? 'assets/images/tree_pose_1.jpg'
                : _treePoseRearImage1;
            break;
          case 2:
            guideText = '請慢慢將右腳向外抬起,放在左腿內側。';
            guideImagePath = isFrontCamera
                ? 'assets/images/tree_pose_2.jpg'
                : _treePoseRearImage2;
            break;
          case 3:
            guideText = '保持平衡,雙手合十擺在胸前。';
            guideImagePath = isFrontCamera
                ? 'assets/images/tree_pose_3.jpg'
                : _treePoseRearImage3;
            break;
        }
        break;
      case 'Warrior2':
        switch (step) {
          case 1:
            guideText = '請站直,雙腳打開與肩同寬,右腳尖朝右。';
            guideImagePath = isFrontCamera
                ? 'assets/images/warrior2_pose_1.jpg'
                : _warrior2RearImage1;
            break;
          case 2:
            guideText = '右腳屈膝90度,左腳微向外展開。';
            guideImagePath = isFrontCamera
                ? 'assets/images/warrior2_pose_2.jpg'
                : _warrior2RearImage2;
            break;
          case 3:
            guideText = '右腳屈膝90度,雙臂平舉與地面平行。';
            guideImagePath = isFrontCamera
                ? 'assets/images/warrior2_pose_3.jpg'
                : _warrior2RearImage3;
            break;
        }
        break;
    }

    setState(() {
      _guideImagePath = guideImagePath;
      poseTip = guideText;
    });

    bool shouldPlayGuide = false;

    switch (pose) {
      case 'TreePose':
        switch (step) {
          case 1:
            shouldPlayGuide = !isTreePoseCase1Played;
            isTreePoseCase1Played = true;
            break;
          case 2:
            shouldPlayGuide = !isTreePoseCase2Played;
            isTreePoseCase2Played = true;
            break;
          case 3:
            shouldPlayGuide = !isTreePoseCase3Played;
            isTreePoseCase3Played = true;
            break;
        }
        break;
      case 'Warrior2':
        switch (step) {
          case 1:
            shouldPlayGuide = !isWarrior2Case1Played;
            isWarrior2Case1Played = true;
            break;
          case 2:
            shouldPlayGuide = !isWarrior2Case2Played;
            isWarrior2Case2Played = true;
            break;
          case 3:
            shouldPlayGuide = !isWarrior2Case3Played;
            isWarrior2Case3Played = true;
            break;
        }
        break;
    }

    if (shouldPlayGuide) {
      await flutterTts.speak(guideText);
      await Future.delayed(const Duration(seconds: 6));

      if (step == 1) {
        await flutterTts.speak('請保持動作,檢測即將開始');
        await Future.delayed(const Duration(seconds: 5));
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    setState(() {
      _guideImagePath = guideImagePath;
    });
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    List<int> allBytes = [];
    for (Plane plane in planes) {
      allBytes.addAll(plane.bytes);
    }
    return Uint8List.fromList(allBytes);
  }

//更新率計算
  String _getFps() {
    DateTime currentTime = DateTime.now();
    double currentFps = _lastFrameTime != null
        ? 1000 / currentTime.difference(_lastFrameTime!).inMilliseconds
        : 0;

    _fpsAverage = (_fpsAverage * _fpsCounter + currentFps) / (_fpsCounter + 1);
    _fpsCounter++;

    if (_fpsCounter > 100) {
      _fpsCounter = 0;
      _fpsAverage = currentFps;
    }

    _lastFrameTime = currentTime;

    return _fpsAverage.toStringAsFixed(1);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      onAppBackground();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _isResuming = false;
      });
    }
  }

  void onAppBackground() {
    if (!_isResuming) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: MealResumePage(
                meal: widget.selectedMeals,
                onResume: _resumeMeal,
              ),
            ),
          );
        },
      );
    }
  }

  void _resumeMeal() {
    _isResuming = true;
    Navigator.pop(context);
  }

//放棄資源
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    flutterTts.stop();
    _cameraController.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _cameraController.value.previewSize?.height ?? 1,
                height: _cameraController.value.previewSize?.width ?? 1,
                child: CameraPreview(_cameraController),
              ),
            ),
          ),
          CustomPaint(
            painter: PosePainter(poses, isFrontCamera),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: _showSettingsDialog,
            ),
          ),
          if (_showFps)
            Positioned(
              top: 30.0,
              right: 10.0,
              child: Text(
                'FPS: ${_getFps()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _fontSize,
                ),
              ),
            ),
          // 在 build() 方法中添加以下代碼
          //以下為菜單進度的視窗
          Positioned(
            top: 30.0,
            left: 50.0,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('菜單進度'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: _customMenuItems.map((item) {
                                final index = _customMenuItems.indexOf(item);
                                final isCompleted = index < currentMealIndex;
                                final isInProgress = index == currentMealIndex;
                                final mealImage = dummyMeals
                                    .firstWhere(
                                        (meal) => meal.title == item.name)
                                    .imageUrl;
                                return Container(
                                  color:
                                      isInProgress ? Colors.yellow[100] : null,
                                  child: ListTile(
                                    leading: Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: mealImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: isInProgress
                                            ? FontWeight.bold
                                            : null,
                                      ),
                                    ),
                                    trailing: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCompleted
                                            ? Colors.green
                                            : isInProgress
                                                ? Colors.blue
                                                : Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('關閉'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (_showAngles)
            Positioned(
              bottom: _tipBoxHeight + 10,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var entry in this.angles.entries)
                    Text(
                      '${entry.key}: ${entry.value}度',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _fontSize,
                      ),
                    ),
                ],
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  poseTip,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _fontSize,
                  ),
                ),
              ),
              height: _tipBoxHeight,
            ),
          ),
          if (_guideImagePath.isNotEmpty) // 只顯示動作引導圖片,不顯示文字
            GuideWindow(
              guideImagePath: _guideImagePath,
            ),
        ],
      ),
    );
  }
}

// 繪製身體骨架
class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final bool isFrontCamera;

  PosePainter(this.poses, this.isFrontCamera);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    for (var pose in poses) {
      final landmarks = pose.landmarks.values.toList();

      // 定義身體部位之間的連接關係
      final connections = [
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow],
        [PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
        [PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
        [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
        [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
        [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
        [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
        [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
      ];

      for (final connection in connections) {
        final startLandmark = landmarks[connection[0].index];
        final endLandmark = landmarks[connection[1].index];
        //調整完位置，符合角度。
        double startX = startLandmark.x - 150;
        double startY = startLandmark.y - 150;
        double endX = endLandmark.x - 150;
        double endY = endLandmark.y - 150;

        // 如果是前置摄像头，进行垂直翻转
        if (isFrontCamera) {
          startX = size.width + 300 - startX;
          endX = size.width + 300 - endX;
          startY = size.width - 20 - startY;
          endY = size.width - 20 - endY;
        }

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// 計算角度的函式
double getAngle(
    PoseLandmark firstPoint, PoseLandmark midPoint, PoseLandmark lastPoint) {
  // 確保midPoint在firstPoint和lastPoint之間
  if ((midPoint.x - firstPoint.x) * (lastPoint.x - firstPoint.x) +
          (midPoint.y - firstPoint.y) * (lastPoint.y - firstPoint.y) <
      0) {
    final temp = firstPoint;
    firstPoint = lastPoint;
    lastPoint = temp;
  }

  final result =
      math.atan2(lastPoint.y - midPoint.y, lastPoint.x - midPoint.x) -
          math.atan2(firstPoint.y - midPoint.y, firstPoint.x - midPoint.x);
  final angle = result * (180 / math.pi);

  return angle.abs() <= 180 ? angle.abs() : 360 - angle.abs();
}
