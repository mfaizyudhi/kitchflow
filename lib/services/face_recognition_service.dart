// FILE — lib/services/face_recognition_service.dart

import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognitionService {
  static final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
      minFaceSize: 0.1,
    ),
  );

  static Future<List<Face>> detectFaces(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    return await _faceDetector.processImage(inputImage);
  }

  static Future<List<Face>> detectFacesFromCamera(
    CameraImage cameraImage,
    CameraDescription camera,
  ) async {
    final Uint8List bytes;
    final int bytesPerRowForMetadata;

    if (cameraImage.planes.length == 1) {
      // Device benar-benar kasih NV21 murni satu plane — pakai langsung.
      bytes = cameraImage.planes[0].bytes;
      bytesPerRowForMetadata = cameraImage.planes[0].bytesPerRow;
    } else {
      // ✅ PERBAIKAN UTAMA — device kirim YUV_420_888 tiga plane
      // (Y, U, V terpisah dengan row/pixel stride sendiri).
      // Harus dikonversi manual ke NV21 (Y + interleaved VU),
      // bukan sekadar digabung mentah.
      bytes = _convertYUV420toNV21(cameraImage);
      // Setelah dikonversi, buffer sudah rapat tanpa padding,
      // jadi bytesPerRow yang benar adalah width gambar.
      bytesPerRowForMetadata = cameraImage.width;
    }

    final Size imageSize = Size(
      cameraImage.width.toDouble(),
      cameraImage.height.toDouble(),
    );

    final InputImageRotation imageRotation = _getRotation(camera);
    const InputImageFormat imageFormat = InputImageFormat.nv21;

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: imageFormat,
        bytesPerRow: bytesPerRowForMetadata,
      ),
    );

    return await _faceDetector.processImage(inputImage);
  }

  // ✅ TAMBAH — konversi YUV_420_888 (3 plane) ke NV21 (1 buffer)
  // dengan memperhitungkan row stride & pixel stride tiap plane.
  static Uint8List _convertYUV420toNV21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int ySize = width * height;
    final int uvSize = (width * height) ~/ 2;

    final Uint8List nv21 = Uint8List(ySize + uvSize);

    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final int yRowStride = yPlane.bytesPerRow;
    final int yPixelStride = yPlane.bytesPerPixel ?? 1;

    int pos = 0;

    // --- Salin channel Y, hormati row stride/pixel stride ---
    if (yPixelStride == 1 && yRowStride == width) {
      // Tidak ada padding, bisa copy langsung
      nv21.setRange(0, ySize, yPlane.bytes);
      pos = ySize;
    } else {
      for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
          nv21[pos++] = yPlane.bytes[row * yRowStride + col * yPixelStride];
        }
      }
    }

    // --- Interleave V lalu U (NV21 = Y + V,U,V,U,...) ---
    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    for (int row = 0; row < height ~/ 2; row++) {
      for (int col = 0; col < width ~/ 2; col++) {
        final int uvIndex = row * uvRowStride + col * uvPixelStride;
        nv21[pos++] = vPlane.bytes[uvIndex]; // V dulu
        nv21[pos++] = uPlane.bytes[uvIndex]; // baru U
      }
    }

    return nv21;
  }

  static InputImageRotation _getRotation(CameraDescription camera) {
    const int deviceRotationDegrees = 0;
    int rotationCompensation =
        (camera.sensorOrientation + deviceRotationDegrees) % 360;

    if (camera.lensDirection == CameraLensDirection.front) {
      rotationCompensation = (360 - rotationCompensation) % 360;
    }

    switch (rotationCompensation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  static bool isFaceValid(Face face) {
    final headEulerY = face.headEulerAngleY ?? 0;
    final headEulerZ = face.headEulerAngleZ ?? 0;

    if (headEulerY.abs() > 30 || headEulerZ.abs() > 30) return false;

    final leftEyeOpen = face.leftEyeOpenProbability;
    final rightEyeOpen = face.rightEyeOpenProbability;

    if (leftEyeOpen != null && rightEyeOpen != null) {
      if (leftEyeOpen < 0.3 || rightEyeOpen < 0.3) return false;
    }

    return true;
  }

  static Future<void> saveFaceRegistered(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('face_registered_$userId', true);
    await prefs.setString('face_registered_user', userId);
  }

  static Future<bool> isFaceRegistered(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('face_registered_$userId') ?? false;
  }

  static Future<String?> getRegisteredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('face_registered_user');
  }

  static Future<void> clearFaceData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('face_registered_$userId');
    await prefs.remove('face_registered_user');
  }

  static void dispose() {
    _faceDetector.close();
  }
}