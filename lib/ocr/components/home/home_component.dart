import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveltranslation/ocr/components/ocr/show_muliti_pic_page.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/helpers/intent_data_helpers.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:traveltranslation/page/mainlist_page.dart';
import 'package:traveltranslation/page/mainpage/main_page.dart';

import '../../../main.dart';

class HomeComponent extends StatefulWidget {
  final bool isBackHome;

  HomeComponent({this.isBackHome});

  @override
  _HomeComponentState createState() {
    return _HomeComponentState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _HomeComponentState extends State<HomeComponent>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  //批量图像每次识别次数
  static final String batchPerNum = "batch_per_limit";
  String imagePath;
  var batchImagePaths = <String>[];

  bool isBatch = false;
  bool showAnimation = false;
  bool showCount = false;
  num lastQuitClickTime;

  bool refreshCamera = false;

  //相机控制器
  CameraController controller;

  //拍照动画控制器
  AnimationController animationController;
  static double animationMoveValue = 0.0;

  @override
  void initState() {
    super.initState();
    print("homepage initState");
    EventUtil.beginPageView("home");
    WidgetsBinding.instance.addObserver(this);
    animationController =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    if (this.widget.isBackHome != null) {
      refreshCamera = this.widget.isBackHome;
    }
  }

  @override
  void dispose() {
    print('dispose');
    EventUtil.endPageView("home");
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    controller = null;
    animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: refreshCamera ? 500 : 0)).then((v) {
      getCameras();
      refreshCamera = false;
    });
  }

  Future getCameras() async {
    for (var item in cameras) {
      if (item.lensDirection == CameraLensDirection.back) {
        if (controller != null && controller.value.isInitialized) {
          onNewCameraSelected(controller.description);
        } else {
          onNewCameraSelected(item);
        }
        break;
      }
    }
  }

  @override
  void deactivate() {
    imagePath = null;
    batchImagePaths.clear();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> showSwitchModeDialog(BuildContext context) async {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("提示"),
            content: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                "切换成单张模式，已拍的图片会被删除，是否继续？",
                style: TextStyle(fontSize: 15.0, color: Color(0xFF666666)),
                textAlign: TextAlign.start,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text("取消"),
              ),
              Container(
                  color: Color(0xFF1C68FF),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(
                      "继续",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    animationMoveValue =
        ScreenUtil.instance.width - ScreenUtil.instance.setWidth(128);

    _backPress() async {
      if (lastQuitClickTime == null) {
        lastQuitClickTime = new DateTime.now().millisecondsSinceEpoch;
        Toast.show("再按一次退出应用", context);
      } else {
        var millisecondsSinceEpoch2 = new DateTime.now().millisecondsSinceEpoch;
        if ((millisecondsSinceEpoch2 - lastQuitClickTime) < 2 * 1000) {
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else {
          lastQuitClickTime = new DateTime.now().millisecondsSinceEpoch;
          Toast.show("再按一次退出应用", context);
        }
      }
    }

    return
//      WillPopScope(
//        child:
    Scaffold(
            key: _scaffoldKey, appBar: _buildAppbar(), body: _buildBody());
//        onWillPop: _backPress
//      );
  }

  Animation<EdgeInsets> animationEdgeInsets;

  Widget buildCameraView() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: _cameraPreviewWidget(),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: controller != null && controller.value.isRecordingVideo
                    ? Colors.redAccent
                    : Colors.grey,
                width: 3.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Image.asset(
                    "images/icon_picture.png",
                    width: ScreenUtil().setWidth(68),
                    height: ScreenUtil().setHeight(68),
                  ),
                  onPressed: _getImage,
                ),
              ),
              Expanded(
                //拍照按钮
                flex: 1,
                child: FlatButton(
                  child: Image.asset("images/icon_takephoto.png"),
                  onPressed: onTakePictureButtonPressed,
                ),
              ),
              Expanded(
                  child: FlatButton(
                onPressed: isBatch ? preViewImages : null,
                child: SizedBox(
                  width: ScreenUtil().setWidth(68),
                  height: ScreenUtil().setHeight(68),
                ),
              ))
            ],
          ),
        ),
      ],
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return InkWell(
        child: const Text(
          'text',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    } else {
      animationEdgeInsets = EdgeInsetsTween(
        begin: const EdgeInsets.only(left: 0.0, right: 0.0),
        end: const EdgeInsets.only(left: 400.0, right: 0.0),
      ).animate(
        CurvedAnimation(
          parent: animationController.view,
          curve: Interval(
            0.0,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
      return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: AnimatedBuilder(
              animation: animationController.view,
              builder: _buildTakePictureAnimation));
    }
  }

  Widget _buildTakePictureAnimation(BuildContext context, Widget child) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: CameraPreview(controller)),
        Visibility(
            visible: showAnimation,
            child: Container(
              alignment: Alignment.bottomRight,
              margin: animationEdgeInsets.value,
              child: imagePath != null
                  ? Image.file(
                      File(imagePath),
                    )
                  : Container(),
            )),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
                constraints: BoxConstraints.expand(
                    width: ScreenUtil.instance.setWidth(128),
                    height: ScreenUtil.instance.setHeight(128)),
                child: GestureDetector(
                  onTap: () {
                    if (isBatch) {
                      preViewImages();
                    }
                  },
                  child: imagePath != null && batchImagePaths.length > 0
                      ? Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                          Image.file(
                              File(imagePath),
                              height: ScreenUtil.instance.setHeight(130.0),
                              width: ScreenUtil.instance.setWidth(130.0),
                              fit: BoxFit.cover,
                              // ignore: missing_return
//                              loadStateChanged: (ExtendedImageState state) {
//                                switch (state.extendedImageLoadState) {
//                                  case LoadState.loading:
//                                    showCount = false;
//                                    break;
//                                  case LoadState.completed:
//                                    showCount = true;
//                                    break;
//                                  case LoadState.failed:
//                                    showCount = false;
//                                    break;
//                                }
//                              },
                            ),
                            Visibility(
                                visible: showCount,
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: Color(0x77B4B4B4),
                                  child: batchImagePaths.length > 0
                                      ? Text(
                                          "${batchImagePaths.length}",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        )
                                      : Container(),
                                ))
                          ],
                        )
                      : Container(),
                )))
      ],
    );
  }

  Future<void> _playAnimation(String path) async {
    try {
      await animationController.forward().orCancel;
      showAnimation = false;
      imagePath = path;
      setState(() {});
      await animationController.reverse();
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> _getImage() async {
    int max_choose = 20;
    if (isBatch) {
      if (UserDelegate.userStatus == UserStatus.GUEST) {
        var configParams =
            await OnlineConfigUtils.getInstance().getConfigParams(batchPerNum);
        if (batchImagePaths.length >= int.parse(configParams)) {
          Toast.show("批量处理最多${int.parse(configParams)}张", context);
          return;
        } else {
          max_choose = int.parse(configParams) - batchImagePaths.length;
        }
      }
      try {
        List<Asset> images = List<Asset>();
        List<Asset> resultList = List<Asset>();
        resultList = await MultiImagePicker.pickImages(
          maxImages: max_choose,
          enableCamera: true,
          selectedAssets: images,
        );
//        for (var r in resultList) {
//          var filepath = await r.getByteData(filePath);
//          batchImagePaths.add(filepath);
//        }
        setState(() {
          imagePath = batchImagePaths.last;
        });
      } on Exception catch (e) {
        // ignore: unused_local_variable
        String error = e.toString();
      }
    } else {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      print("选择的Imagepath=" + image.absolute.path);
      if (image.absolute.path.endsWith(".gif")) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("不能选择GIF")));
        return;
      }
      if (mounted) {
        setState(() {
          imagePath = image.absolute.path;
        });
      }

      Application.router.navigateTo(context,
          ("/show?imagesPath=${DataHelper.encodeData(image.absolute.path)}"));
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void preViewImages() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowMultiPicturePage(imagePaths: batchImagePaths),
      ),
    );
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void onTakePictureButtonPressed() async {
    EventUtil.onEvent(EventUtil.photoTake);

////    //如果是游客，批量处理张数需要限制
//    if (UserDelegate.userStatus == UserStatus.GUEST) {
//      var configParams =
//          await OnlineConfigUtils.getInstance().getConfigParams(batchPerNum);
//      int limit = 5;
//      if (configParams.isNotEmpty) {
//        print("configParams =${configParams}");
//        limit = int.parse(configParams);
//        print("kv配置最多处理$configParams张");
//      }
//      if (batchImagePaths.length >= limit) {
//        Toast.show("批量处理最多$limit张", context);
//        return null;
//      }
//    }

    try {
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      // Attempt to take a picture and log where it's been saved.
      await controller.takePicture(path);
      //此处拍照成功
      if (isBatch) {
        imagePath = path;
        batchImagePaths.add(imagePath);
        setState(() {
          //刷新
          if (mounted) {
            showCount = false;
            showAnimation = true;
            Future.delayed(Duration(milliseconds: 500)).then((t) {
              _playAnimation(path);
            });
          }
        });
      } else {
        controller?.dispose();
        controller = null;
        setState(() {});
        Application.router
            .navigateTo(
                context, "/show?imagesPath=${DataHelper.encodeData(path)}")
            .then((value) {});
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Widget _buildAppbar() {
    return AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Image.asset(
                "images/icon_history.png",
                width: ScreenUtil().setWidth(48),
                height: ScreenUtil().setHeight(48),
              ),
              onPressed: () {
                EventUtil.onEvent(EventUtil.recordButtonClick);
                Application.router.navigateTo(context, "/history");
              }),
        ],
        leading: IconButton(
            icon: Image.asset(
              "images/icon_arrow_back_black.png",
              width: ScreenUtil().setWidth(48),
              height: ScreenUtil().setHeight(48),
            ),
            onPressed: () {
              //跳转到主界面
              Navigator.of(context).pop();
//              Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (context) => new MainPage()));
//              Application.router.navigateTo(context, "/setting");
              EventUtil.onEvent(EventUtil.setButtonClick);
            }),
        title: Container(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          height: ScreenUtil.instance.setHeight(70),
          width: ScreenUtil.instance.setWidth(200),
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20.0)),
//          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              Text(
//                "批量",
//                style: TextStyle(fontSize: 12.0),
//              ),
//              Switch(
//                value: this.isBatch,
//                activeColor: Colors.white,
//                activeTrackColor: AppColor.switchActiveColor,
//                onChanged: (bool val) {
//                  if (!val) {
//                    print("切换单张");
//                    if (batchImagePaths.isNotEmpty) {
//                      showSwitchModeDialog(context).then((choose) {
//                        if (choose) {
//                          switchMode();
//                        }
//                      });
//                    } else {
//                      switchMode();
//                    }
//                  } else {
//                    switchMode();
//                  }
//                },
//              ),
//            ],
//          ),
        ));
  }

//  void switchMode() {
//    EventUtil.onEvent(EventUtil.batchButtonClick);
//    //并且删除images
//    batchImagePaths.clear();
//    this.setState(() {
//      this.isBatch = !this.isBatch;
//    });
//    print("bathImagesSize=${batchImagePaths.length}");
//  }

  Widget _buildBody() {
    return buildCameraView();
  }
}
