import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String qr;
  bool camState = false;
  bool dirState = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Back"),
                Switch(
                    value: dirState,
                    onChanged: (val) => setState(() => dirState = val)),
                Text("Front"),
              ],
            ),
            Expanded(
                child: camState
                    ? Center(
                        child: SizedBox(
                          width: 300.0,
                          height: 600.0,
                          child: QrCamera(
                            shouldStopCameraOnReadTimeout: false,
                            qrCodeReadTimeout: 5000,
                            qrReadTimeoutCallback: () {
                              debugPrint('Qrcode read timeout');
                            },
                            qrReadErrorCallback: (error) {
                              debugPrint('QrCode read error: $error');
                            },
                            onError: (context, error) => buildPortrait(
                              child: Center(
                                child: Text(
                                  error.toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            notStartedBuilder: (context) => buildPortrait(
                              child: Center(
                                child: Text("Camera Loading ..."),
                              ),
                            ),
                            offscreenBuilder: (context) => buildPortrait(
                              child: Center(
                                child: Text("Camera Paused."),
                              ),
                            ),
                            cameraDirection: dirState
                                ? CameraDirection.FRONT
                                : CameraDirection.BACK,
                            qrCodeCallback: (code) {
                              setState(() {
                                qr = code;
                              });
                            },
                            child: buildPortrait(),
                          ),
                        ),
                      )
                    : Center(child: Text("Camera inactive"))),
            Text("QRCODE: $qr"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Text(
            "on/off",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            setState(() {
              camState = !camState;
            });
          }),
    );
  }

  Widget buildPortrait({Widget child}) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(
          color: Colors.orange,
          width: 10.0,
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
