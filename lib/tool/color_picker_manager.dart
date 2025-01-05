import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:screenshot/screenshot.dart';

// 颜色选择管理器类
class ColorPickerManager {
  // 打开颜色选择器
  static void openColorPicker({
    required BuildContext context,
    required Color currentColor,
    required Function(Color) onColorChanged,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择颜色'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 从屏幕获取颜色
  static Future<void> openEyeDropper({
    required BuildContext context,
    required ScreenshotController screenshotController,
    required Function(Color) onColorSelected,
  }) async {
    try {
      // 使用 screenshot 插件截取当前 Widget
      final imageBytes = await screenshotController.capture();

      if (imageBytes == null) {
        debugPrint('截屏失败');
        return;
      }

      // 加载截屏图片
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // 显示截屏图片并等待用户点击
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('从屏幕选择颜色'),
            content: GestureDetector(
              onTapDown: (TapDownDetails details) async {
                // 获取点击位置的颜色
                final offset = details.localPosition;

                // 将 offset 的 double 值转换为 int
                final x = offset.dx.toInt();
                final y = offset.dy.toInt();

                // 确保点击位置在图片范围内
                if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
                  final pixel = await image.toByteData();
                  final pixelData = pixel!.buffer.asUint8List();

                  // 计算像素偏移量
                  final pixelOffset = (y * image.width + x) * 4;

                  // 获取颜色值
                  final color = Color.fromARGB(
                    pixelData[pixelOffset + 3], // Alpha
                    pixelData[pixelOffset + 2], // Red
                    pixelData[pixelOffset + 1], // Green
                    pixelData[pixelOffset], // Blue
                  );

                  onColorSelected(color);
                  Navigator.of(context).pop();
                } else {
                  debugPrint('点击位置超出图片范围');
                }
              },
              child: Image.memory(imageBytes),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('截屏或取色失败: $e');
    }
  }
}
