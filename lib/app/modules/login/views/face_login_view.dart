// FILE — lib/features/auth/views/face_login/face_login_view.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/face_recognition_service.dart';

class FaceLoginView extends StatefulWidget {
  final Future<void> Function() onSuccess;
  const FaceLoginView({super.key, required this.onSuccess});

  @override
  State<FaceLoginView> createState() => _FaceLoginViewState();
}

class _FaceLoginViewState extends State<FaceLoginView> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  bool _faceDetected = false;
  bool _isLoggingIn = false;
  String _message = "Arahkan wajah ke kamera";
  int _captureCountdown = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // ✅ TAMBAH — paksa format NV21
    );

    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
      _startFaceDetection();
    }
  }

  void _startFaceDetection() {
    _cameraController!.startImageStream((CameraImage image) async {
      if (_isDetecting || _isLoggingIn) return;
      _isDetecting = true;

      try {
        final faces = await FaceRecognitionService.detectFacesFromCamera(
          image,
          _cameraController!.description,
        );

        if (!mounted) return;

        if (faces.isEmpty) {
          setState(() {
            _faceDetected = false;
            _message = "Wajah tidak terdeteksi";
          });
        } else {
          final isValid = FaceRecognitionService.isFaceValid(faces.first);
          setState(() {
            _faceDetected = isValid;
            _message = isValid
                ? "Wajah dikenali! Sedang masuk..."
                : "Hadapkan wajah ke depan & buka mata";
          });

          if (isValid && _captureCountdown == 0) {
            _captureCountdown = 30;
            await _processLogin();
          }
        }
      } catch (e) {
        // ✅ TAMBAH — tangkap error deteksi supaya tidak diam-diam gagal terus
        debugPrint('Face detection error: $e');
        if (mounted) {
          setState(() => _message = "Deteksi gagal, coba lagi");
        }
      } finally {
        _isDetecting = false;
        if (_captureCountdown > 0) _captureCountdown--;
      }
    });
  }

  Future<void> _processLogin() async {
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
      _message = "Memverifikasi wajah...";
    });

    await _cameraController!.stopImageStream();

    try {
      final photo = await _cameraController!.takePicture();
      final faces = await FaceRecognitionService.detectFaces(photo.path);

      if (faces.isEmpty || !FaceRecognitionService.isFaceValid(faces.first)) {
        if (mounted) {
          setState(() {
            _isLoggingIn = false;
            _message = "Wajah tidak valid, coba lagi";
          });
          _startFaceDetection();
        }
        return;
      }

      await widget.onSuccess();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
          _message = "Gagal, coba lagi";
        });
        _startFaceDetection();
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Login dengan Wajah",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _faceDetected ? Colors.green : Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_cameraController?.value.isInitialized ?? false)
                  ClipOval(
                    child: SizedBox(
                      width: 280,
                      height: 360,
                      child: CameraPreview(_cameraController!),
                    ),
                  )
                else
                  Container(
                    width: 280,
                    height: 360,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black26,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                Container(
                  width: 286,
                  height: 366,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _faceDetected ? Colors.green : AppColors.primary,
                      width: 3,
                    ),
                  ),
                ),

                if (_isLoggingIn)
                  Container(
                    width: 280,
                    height: 360,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}