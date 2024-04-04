// import 'package:mvp_one/screens/move_detail.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/screens/move_result.dart';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
// TreeOise
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

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;

  const CameraScreen({
    Key? key,
    required this.cameras,
    required this.meal,
    required this.onToggleFavorite,
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
  bool isFrontCamera = false;
  //fps設定
  double _fpsAverage = 0.0;
  int _fpsCounter = 0;
  DateTime? _lastFrameTime;
  String poseType = '';
  //初始化camera 以及 poseDetector
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
    _initializeCamera();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        model: PoseDetectionModel.base,
        mode: PoseDetectionMode.stream,
      ),
    );
    checkPoses();
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        _elapsedSeconds++;
      });
      if (_isAllPosesCompleted) {
        _timer.cancel();
        await Future.delayed(Duration(seconds: 5));
        _navigateToResultPage();
      }
    });
  }

  void _navigateToResultPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          duration: _elapsedSeconds,
          meal: meal,
          onToggleFavorite: onToggleFavorite,
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

  Future<void> _detectPose(CameraImage image, bool isFrontCamera) async {
    if (_isAllPosesCompleted) {
      await Future.delayed(Duration(seconds: 1));
      return; // 如果所有動作已完成,直接返回,不再進行姿勢檢測
    }
    // print("_detectPose poseIndex$poseIndex");

    final InputImageRotation rotation = isFrontCamera
        ? InputImageRotation.rotation270deg // 前置摄像头
        : InputImageRotation.rotation90deg; // 后置摄像头

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
        Future.delayed(Duration(seconds: 1));
        // print("右手腕的角度是: ${angles['r_wrist']} 度");
        // print("右手肘的角度是: ${angles['r_elbow']} 度");
        // print("右肩膀的角度是: ${angles['r_shoulder']} 度");
        // print("右髖部的角度是: ${angles['r_hip']} 度");
        // print("右膝蓋的角度是: ${angles['r_knee']} 度");
        // print("右腳趾的角度是: ${angles['r_footindex']} 度");
        // print("左手腕的角度是: ${angles['l_wrist']} 度");
        // print("左手肘的角度是: ${angles['l_elbow']} 度");
        // print("左肩膀的角度是: ${angles['l_shoulder']} 度");
        // print("左髖部的角度是: ${angles['l_hip']} 度");
        // print("左膝蓋的角度是: ${angles['l_knee']} 度");
        // print("左腳趾的角度是: ${angles['l_footindex']} 度");
        // print("/n");
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
              // 檢查第一個樹式姿勢是否需要修正
              correctionTip = checkTreePoseOneNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await TreePoseOnePass(angles);
                  poseTipText = '這是 Tree Pose 1';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(Duration(seconds: 2));
                poseTipText = '這是 Tree Pose 1';
                break;
              }

            case 1:
              // 檢查第二個樹式姿勢是否需要修正
              correctionTip = checkTreePoseTwoNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await TreePoseTwoPass(angles);
                  poseTipText = '這是 Tree Pose 2';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(Duration(seconds: 2));
                poseTipText = '這是 Tree Pose 2';
                break;
              }
            case 2:
              // 檢查第三個樹式姿勢是否需要修正
              correctionTip = checkTreePoseThreeNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await TreePoseThreePass(angles);
                  poseTipText = '這是 Tree Pose 3';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(Duration(seconds: 2));
                poseTipText = '這是 Tree Pose 3';
                break;
              }
            default:
              return;
          }
        case 'Warrior2':
          switch (poseIndex) {
            case 0:
              // 檢查第一個樹式姿勢是否需要修正
              correctionTip = checkWarrior2OneNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await Warrior2OnePass(angles);
                  poseTipText = '這是 Warrior2 1';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(Duration(seconds: 2));
                poseTipText = '這是 Warrior2 1';
                break;
              }

            case 1:
              // 檢查第二個樹式姿勢是否需要修正
              correctionTip = checkWarrior2TwoNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await Warrior2TwoPass(angles);
                  poseTipText = '這是 Warrior2 2';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(Duration(seconds: 2));
                poseTipText = '這是 Warrior2 2';
                break;
              }
            case 2:
              // 檢查第三個樹式姿勢是否需要修正
              correctionTip = checkWarrior2ThreeNeedsCorrection(angles);
              //直到提示不同才做語音提醒
              if (correctionTip != poseTip) {
                if (correctionTip.isNotEmpty) {
                  // 如果需要修正,提供修正建議並重試當前階段
                  poseTip = correctionTip;
                  flutterTts.speak(poseTip);
                  await Future.delayed(Duration(seconds: 6));
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 700));
                  await _checkPose(poseIndex);
                } else {
                  // 如果不需要修正,執行原有的姿勢檢查邏輯
                  result = await Warrior2ThreePass(angles);
                  poseTipText = '這是 Warrior2 3';
                }
                break;
              } else {
                //不然就等一下再檢查一次
                await Future.delayed(Duration(seconds: 2));
                poseTipText = '這是 Warrior2 3';
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
          await Future.delayed(Duration(seconds: 5));
          setState(() {});
          await Future.delayed(Duration(milliseconds: 700));
          await _checkPose(poseIndex + 1);
        } else {
          // 如果當前階段通過且是最後一個階段,提示所有動作完成
          poseTip = '$poseTipText通過，所有動作完成';
          flutterTts.speak(poseTip);
          await Future.delayed(Duration(seconds: 5));
          flutterTts.speak("KongShi KongShi");
          FlutterTts().stop();
          await Future.delayed(Duration(seconds: 5));
          setState(() {
            _isAllPosesCompleted = true; // 設置標誌變量為 true
          });
        }
      } else {
        // 如果當前階段未通過,提示重試當前階段
        poseTip = '$poseTipText未通過，請重試';
        flutterTts.speak(poseTip);
        await Future.delayed(Duration(seconds: 5));
        setState(() {});
        await Future.delayed(Duration(milliseconds: 700));
        await _checkPose(poseIndex);
      }
    } else {
      return;
    }
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

//放棄資源
  @override
  void dispose() {
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
            right: 10.0,
            child: Text(
              poseTip,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: Text(
              'FPS: ${_getFps()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
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
                      fontSize: 16.0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCamera,
        child: const Icon(Icons.switch_camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
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
