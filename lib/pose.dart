// import 'package:mvp_one/screens/move_detail.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/pose_related/posePainter.dart';
import 'package:mvp_one/screens/move_result.dart';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:mvp_one/customize_menu/pose_menu.dart' as poseMenu;
// TreePose
import 'Pose_Guide/TreePose/TreePose_Guide_One.dart';
import 'Pose_Guide/TreePose/TreePose_Guide_Two.dart';
import 'Pose_Guide/TreePose/TreePose_Guide_Three.dart';
import 'Pose_Correction/TreePose/TreePose_Correction_One.dart';
import 'Pose_Correction/TreePose/TreePose_Correction_Two.dart';
import 'Pose_Correction/TreePose/TreePose_Correction_Three.dart';

//Warrior2
import 'Pose_Guide/Warrior2/Warrior2_Guide_One.dart';
import 'Pose_Guide/Warrior2/Warrior2_Guide_Two.dart';
import 'Pose_Guide/Warrior2/Warrior2_Guide_Three.dart';
import 'Pose_Correction/Warrior2/Warrior2_Correction_One.dart';
import 'Pose_Correction/Warrior2/Warrior2_Correction_Two.dart';
import 'Pose_Correction/Warrior2/Warrior2_Correction_Three.dart';

//http
import 'package:http/http.dart' as http;
import 'dart:convert';


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

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;
  final List<poseMenu.CustomMenuItem> customMenuItems;
  final VoidCallback onPoseCompleted;

  const CameraScreen({
    Key? key,
    required this.cameras,
    required this.meal,
    required this.onToggleFavorite,
    required this.customMenuItems,
    required this.onPoseCompleted,
  }) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  // 本地重新宣告一個meal
  late Meal meal;
  // 本地重新宣告一個toggleFav
  late final void Function(Meal meal) onToggleFavorite;

  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isAllPosesCompleted = false; // 新增一個標誌變量

  FlutterTts flutterTts = FlutterTts();

  bool ischeckPoseLooping = false;
  String poseTip = '';
  //
  bool _shouldUpdateUI = false;
  int poseIndex = 0; // 記錄當前完成的最高動作階段
  //每個階段的PASS
  bool isDetecting = false;
  //googlemlkit相關，動作角度座標等等
  Map<String, int> angles = {};
  late PoseDetector _poseDetector;
  List<Pose> poses = [];
  //相機相關
  late CameraController _cameraController;
  bool isFrontCamera = true;
  //fps設定
  double _fpsAverage = 0.0;
  int _fpsCounter = 0;
  DateTime? _lastFrameTime;
  String poseType = '';
  //初始化camera 以及 poseDetector
  bool _showFps = true;
  bool _showAngles = false;
  bool _showMLResult = false;
  double _fontSize = 16.0; // 預設為中等字體大小
  double _tipBoxHeight = 50.0; // 語音提示框的高度
  bool isTreePoseCase1Played = false;
  bool isTreePoseCase2Played = false;
  bool isTreePoseCase3Played = false;
  bool isWarrior2Case1Played = false;
  bool isWarrior2Case2Played = false;
  bool isWarrior2Case3Played = false;

  String _treePoseRearImage1 = 'assets/images/tree_pose_rear_1.jpg';
  String _treePoseRearImage2 = 'assets/images/tree_pose_rear_2.jpg';
  String _treePoseRearImage3 = 'assets/images/tree_pose_rear_3.jpg';
  String _warrior2RearImage1 = 'assets/images/warrior2_pose_rear_1.jpg';
  String _warrior2RearImage2 = 'assets/images/warrior2_pose_rear_2.jpg';
  String _warrior2RearImage3 = 'assets/images/warrior2_pose_rear_3.jpg';
  final List<String> modelPaths = ['/predict/init', '/predict/warrior'];
  String selectedModelPath = '/predict/warrior';
  int frameCounter = 0;
  int correctCount = 0;
  bool isPassed = false;
  final int framesToSendHttpRequest = 5;

  @override
  void initState() {
    //賦予本地的meal 為 接收的meal值
    meal = widget.meal;
    onToggleFavorite = widget.onToggleFavorite;

    // 根據meal的id判斷要檢測的動作類型
    if (meal.id == 'm6') {
      poseType = 'TreePose';
    } else if (meal.id == 'm9') {
      poseType = 'Warrior2';
    }

    super.initState();
    Wakelock.enable();
    _initializeCamera();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        model: PoseDetectionModel.base,
        mode: PoseDetectionMode.stream,
      ),
    );
    checkPoses();
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
                  SwitchListTile(
                    title: const Text('ML result(devs)'),
                    value: _showMLResult,
                    onChanged: (value) {
                      setState(() {
                        _showMLResult = value;
                      });
                    },
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

// 添加一個新的方法用於顯示菜單進度對話框
  void _showMenuProgressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('菜單進度'),
          content: SingleChildScrollView(
            child: ListBody(
              children: List.generate(widget.customMenuItems.length, (index) {
                final menuItem = widget.customMenuItems[index];
                final isCurrentPose = menuItem.mealId == meal.id;

                return Container(
                  color: isCurrentPose ? Colors.grey[200] : null,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${index + 1}. ${menuItem.name}',
                    style: TextStyle(
                      fontWeight: isCurrentPose ? FontWeight.bold : null,
                    ),
                  ),
                );
              }),
            ),
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

  //實作初始化相機
  Future<void> _initializeCamera() async {
    final CameraDescription selectedCamera = isFrontCamera
        ? widget.cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front)
        : widget.cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(selectedCamera, ResolutionPreset.high);
    await _cameraController.initialize();
    //如果初始化了
    if (mounted) {
      setState(() {}); //更新widget

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
    widget.onPoseCompleted();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          duration: _elapsedSeconds,
          meal: widget.meal,
          onToggleFavorite: widget.onToggleFavorite,
          uid: '',
        ),
      ),
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

  void _toggleResult() {
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

  Future<void> _detectPose(CameraImage image, bool isFrontCamera) async {
    if (_isAllPosesCompleted) {
      await Future.delayed(const Duration(seconds: 1));
      return; // 如果所有動作已完成,直接返回,不再進行姿勢檢測
    }
    // print("_detectPose poseIndex$poseIndex");

    final InputImageRotation rotation = isFrontCamera
        ? InputImageRotation.rotation270deg // 前置鏡頭
        : InputImageRotation.rotation90deg; // 後置鏡頭

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
      final List<Map<String, dynamic>> jsonPoses = detectedPoses.map((pose) {
        final Map<String, dynamic> poseMap = {};
        for (var landmark in pose.landmarks.values) {
          final Map<String, dynamic> landmarkMap = {
            "x": landmark.x.toStringAsFixed(2),
            "y": landmark.y.toStringAsFixed(2),
            "z": 0.0,
            "v": landmark.likelihood.toStringAsFixed(2)
          };
            poseMap[landmark.type.toString()] = landmarkMap;
        }
        return poseMap;
      }).toList();
      this.angles.clear();
      // Map<String, int> angles = {};
      //把所有的landmark抓取成變數
      if (detectedPoses.isNotEmpty) {
        final Pose firstPose = detectedPoses.first;
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

        /*右邊*/
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
        //開始計算身體各點的角度 變儲存
        /*右手腕 */
        if (rightIndex != null && rightWrist != null && rightElbow != null) {
          final int r_wrist =
              getAngle(rightIndex, rightWrist, rightElbow).round();
          angles['r_wrist'] = r_wrist;
        }
        /*右手肘 */
        if (rightWrist != null && rightElbow != null && rightShoulder != null) {
          final int r_elbow =
              getAngle(rightWrist, rightElbow, rightShoulder).round();
          angles['r_elbow'] = r_elbow;
        }
        /*右肩膀 */
        if (rightElbow != null && rightShoulder != null && rightHip != null) {
          final int r_shoulder =
              getAngle(rightElbow, rightShoulder, rightHip).round();
          angles['r_shoulder'] = r_shoulder;
        }
        /*右髖部 */
        if (rightShoulder != null && rightHip != null && rightKnee != null) {
          final int r_hip =
              getAngle(rightShoulder, rightHip, rightKnee).round();
          angles['r_hip'] = r_hip;
        }
        /*右膝蓋 */
        if (rightHip != null && rightKnee != null && rightAnkle != null) {
          final int r_knee = getAngle(rightHip, rightKnee, rightAnkle).round();
          angles['r_knee'] = r_knee;
        }
        /*右腳趾 */
        if (rightKnee != null && rightAnkle != null && rightFootIndex != null) {
          final int r_footindex =
              getAngle(rightKnee, rightAnkle, rightFootIndex).round();
          angles['r_footindex'] = r_footindex;
        }
        /*左手腕 */
        if (leftIndex != null && leftWrist != null && leftElbow != null) {
          final int l_wrist = getAngle(leftIndex, leftWrist, leftElbow).round();
          angles['l_wrist'] = l_wrist;
        }
        /*左手肘 */
        if (leftWrist != null && leftElbow != null && leftShoulder != null) {
          final int l_elbow =
              getAngle(leftWrist, leftElbow, leftShoulder).round();
          angles['l_elbow'] = l_elbow;
        }
        /*左肩膀 */
        if (leftElbow != null && leftShoulder != null && leftHip != null) {
          final int l_shoulder =
              getAngle(leftElbow, leftShoulder, leftHip).round();
          angles['l_shoulder'] = l_shoulder;
        }
        /*左髖部 */
        if (leftShoulder != null && leftHip != null && leftKnee != null) {
          final int l_hip = getAngle(leftShoulder, leftHip, leftKnee).round();
          angles['l_hip'] = l_hip;
        }
        /*左膝蓋 */
        if (leftHip != null && leftKnee != null && leftAnkle != null) {
          final int l_knee = getAngle(leftHip, leftKnee, leftAnkle).round();
          angles['l_knee'] = l_knee;
        }
        /*左腳趾 */
        if (leftKnee != null && leftAnkle != null && leftFootIndex != null) {
          final int l_footindex =
              getAngle(leftKnee, leftAnkle, leftFootIndex).round();
          angles['l_footindex'] = l_footindex;
        }
        // 集中輸出所有 print 語句
        Future.delayed(const Duration(seconds: 1));
      }
      setState(() {
        poses = detectedPoses;
      });
      frameCounter++;
      if (frameCounter == framesToSendHttpRequest) {
        // 发送 HTTP 请求到服务器
        _sendHttpRequest(jsonPoses);
        frameCounter = 0; // 重置帧计数器
      }
    } catch (e) {
      print("Error detecting pose: $e");
    } finally {
      isDetecting = false;
    }
  }

  //循序跑完三個檢查點

  Future<void> checkPoses() async {
    //print("checkPoses poseIndex$poseIndex");

    _shouldUpdateUI = false;
    await _checkPose(poseIndex); // 從第一個動作開始檢查
  }

  Future<void> _checkPose(int poseIndex) async {
    // 設置語音的語言和聲音
    await flutterTts.setLanguage("zh-TW"); //
    // await flutterTts
    //     .setVoice({"name": "zh-TW-default", "locale": "zho-default"});
    // await flutterTts
    //     .setVoice({"name": "en-in-x-end-network", "locale": "en-IN"}); //印度口音-男生
    await flutterTts.setVoice(
        {"name": "cmn-tw-x-ctd-network", "locale": "zh-TW"}); //男生聲音-粗曠
    // await flutterTts.setVoice(
    //     {"name": "cmn-tw-x-cte-network", "locale": "zh-TW"}); //男生聲音-官腔
    // await flutterTts.setVoice(
    //     {"name": "cmn-tw-x-ctc-network", "locale": "zh-TW"}); //女生聲音-溫柔

    // 獲取所有可用語音
    List<dynamic> voices = await flutterTts.getVoices;

    // 打印語音信息
    for (var voice in voices) {
      print(voice);
    }

    if (!ischeckPoseLooping) {
      //print("_checkPoses poseIndex$poseIndex");
      String correctionTip = ''; // 存儲修正建議的變數
      bool result = false; // 存儲姿勢檢查結果的變數
      String poseTipText = ''; // 存儲姿勢提示文字的變數
      // Pose的動作修正Swich
      switch (poseType) {
        case 'TreePose':
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
        case 'Warrior2':
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
          poseTip = '$poseTipText通過,進入下一個動作';
          flutterTts.speak(poseTip);
          await Future.delayed(const Duration(seconds: 5));
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 700));
          await _checkPose(poseIndex + 1);
        } else {
          // 如果當前階段通過且是最後一個階段,提示所有動作完成
          poseTip = '$poseTipText通過,所有動作完成';
          flutterTts.speak(poseTip);
          await Future.delayed(const Duration(seconds: 5));

          // 播放 "KongShi KongShi" 語音
          flutterTts.speak("KongShi KongShi");

          // 等待語音播放完畢
          await Future.delayed(const Duration(milliseconds: 2000));

          // 停止語音播放
          await flutterTts.stop();

          // 導航到結果頁面
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                duration: _elapsedSeconds,
                meal: meal,
                onToggleFavorite: onToggleFavorite,
                uid: '',
              ),
            ),
          );
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

// 播放動作引導的函數
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

// 添加Widget來顯示引導圖片和文字
  String _guideText = '';
  String _guideImagePath = '';

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

//放棄資源
  @override
  void dispose() {
    Wakelock.disable();
    _timer.cancel();
    flutterTts.stop();
    _cameraController.dispose();
    _poseDetector.close();
    super.dispose();
  }

  String result = '';
  String prob = '';
  Future<void> _sendHttpRequest(List<Map<String, dynamic>> jsonPoses) async {
    try {
      final response = await http.post(
        Uri.parse('https://mp-hdkf.onrender.com$selectedModelPath'),
        body: jsonEncode({'jsonPoses': jsonPoses}),
        headers: {'Content-Type': 'application/json'},
      );

      setState(() {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        result = responseData['body_language_class'].toString();
        prob = responseData['body_language_prob'].toString();

        if (result == 'correct') {
          correctCount++;
          if (correctCount >= 3) {
            isPassed = true;
            //_speak('通過');
          }
        } else {
          correctCount = 0;
          isPassed = false;
        }
      });
    } catch (e) {
      //print("Error sending HTTP request: $e");
    }
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
          Positioned(
            top: 30.0,
            left: 40.0,
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: _showMenuProgressDialog,
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
                  poseTip, // 在半透明區塊中顯示動作引導提示文字
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
          if (_showMLResult)
            //ML結果
            Positioned(
              bottom: 2.0,
              right: 10.0,
              child: Text(
                '$result $prob',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _fontSize,
                ),
              ),
            ),
        ],
      ),
    );
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
}
