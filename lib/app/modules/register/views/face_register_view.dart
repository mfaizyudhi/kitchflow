// FILE — lib/features/auth/views/face_register/face_register_view.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/face_recognition_service.dart';

class FaceRegisterView extends StatefulWidget {
  final String userId;
  const FaceRegisterView({super.key, required this.userId});

  @override
  State<FaceRegisterView> createState() => _FaceRegisterViewState();
}

class _FaceRegisterViewState extends State<FaceRegisterView>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isDetecting = false;
  bool _faceDetected = false;
  bool _isSaving = false;
  String _message = "Arahkan wajah ke kamera";
  int _captureCountdown = 0;
  DateTime? _lastFrameTime;

  static const double _ovalWidth = 280;
  static const double _ovalHeight = 360;

  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
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
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    await _cameraController!.initialize();

    // ✅ TAMBAH — print info kamera sekali saat init, supaya kita tahu
    // sensorOrientation & lensDirection device ini tanpa perlu tunggu frame
    debugPrint(
      '📷 CAMERA INIT | lensDirection=${frontCamera.lensDirection} | '
      'sensorOrientation=${frontCamera.sensorOrientation}',
    );

    if (mounted) {
      setState(() {});
      _startFaceDetection();
    }
  }

  void _startFaceDetection() {
    _cameraController!.startImageStream((CameraImage image) async {
      if (_isDetecting || _isSaving) return;

      final now = DateTime.now();
      if (_lastFrameTime != null &&
          now.difference(_lastFrameTime!) < const Duration(milliseconds: 250)) {
        return;
      }
      _lastFrameTime = now;

      _isDetecting = true;

      try {
        final faces = await FaceRecognitionService.detectFacesFromCamera(
          image,
          _cameraController!.description,
        );

        // ✅ TAMBAH — debug utama untuk cek rotasi/format/ukuran buffer
        debugPrint(
          '🔍 faces=${faces.length} | planes=${image.planes.length} | '
          'w=${image.width} h=${image.height} | '
          'bytesPerRow=${image.planes[0].bytesPerRow} | '
          'sensorOrientation=${_cameraController!.description.sensorOrientation} | '
          'lensDirection=${_cameraController!.description.lensDirection}',
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
                ? "Wajah terdeteksi! Tahan sebentar..."
                : "Hadapkan wajah ke depan & buka mata";
          });

          if (isValid && _captureCountdown == 0) {
            _captureCountdown = 30;
            Future.microtask(_captureFace);
          }
        }
      } catch (e) {
        // ✅ TAMBAH — tangkap error deteksi supaya tidak diam-diam gagal terus
        debugPrint('❌ Face detection error: $e');
        if (mounted) {
          setState(() => _message = "Deteksi gagal, coba lagi");
        }
      } finally {
        _isDetecting = false;
        if (_captureCountdown > 0) _captureCountdown--;
      }
    });
  }

  Future<void> _captureFace() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _message = "Mendaftarkan wajah...";
    });

    try {
      await _cameraController!.stopImageStream();
      await Future.delayed(const Duration(milliseconds: 200));

      final photo = await _cameraController!.takePicture();

      final faces = await FaceRecognitionService.detectFaces(photo.path);

      if (faces.isEmpty || !FaceRecognitionService.isFaceValid(faces.first)) {
        if (mounted) {
          setState(() {
            _isSaving = false;
            _captureCountdown = 0;
            _message = "Gagal, coba lagi";
          });
          _startFaceDetection();
        }
        return;
      }

      await FaceRecognitionService.saveFaceRegistered(widget.userId);

      if (mounted) {
        Get.back();
        Get.snackbar(
          "Berhasil! 🎉",
          "Wajah berhasil didaftarkan!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _captureCountdown = 0;
          _message = "Error, coba lagi";
        });
        _startFaceDetection();
      }
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
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
          "Daftarkan Wajah",
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
                      width: _ovalWidth,
                      height: _ovalHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(_cameraController!),

                          if (!_faceDetected && !_isSaving)
                            AnimatedBuilder(
                              animation: _scanController,
                              builder: (context, child) {
                                final top = _scanController.value * _ovalHeight;
                                return Positioned(
                                  top: top,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary.withOpacity(0),
                                          AppColors.primary,
                                          AppColors.primary.withOpacity(0),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.8),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          if (_faceDetected && !_isSaving)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.08),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    width: _ovalWidth,
                    height: _ovalHeight,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black26,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                AnimatedBuilder(
                  animation: _scanController,
                  builder: (context, child) {
                    final pulse = _faceDetected
                        ? 3.0
                        : 3.0 + (_scanController.value * 1.5);
                    return Container(
                      width: _ovalWidth + 6,
                      height: _ovalHeight + 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _faceDetected
                              ? Colors.green
                              : AppColors.primary,
                          width: pulse,
                        ),
                      ),
                    );
                  },
                ),

                if (_isSaving)
                  Container(
                    width: _ovalWidth,
                    height: _ovalHeight,
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

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                _buildTip(Icons.wb_sunny_outlined, "Pastikan cahaya cukup terang"),
                _buildTip(Icons.face_outlined, "Hadapkan wajah langsung ke kamera"),
                _buildTip(Icons.remove_red_eye_outlined, "Pastikan kedua mata terbuka"),
                _buildTip(Icons.stay_current_portrait, "Tahan HP tetap stabil"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }
}