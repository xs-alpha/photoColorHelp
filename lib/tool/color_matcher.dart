import 'dart:math';

import 'package:flutter/material.dart';

import 'color_config.dart';

// 颜色匹配器类
class ColorMatcher {
  // 固定颜色定义
  static final Map<String, Map<String, dynamic>> fixedColors = {
    "红色": {
      "color": const Color.fromRGBO(255, 0, 0, 1),
      "rgb": [255, 0, 0],
      "hex": "#ff0000",
    },
    "绿色": {
      "color": const Color.fromRGBO(0, 255, 0, 1),
      "rgb": [0, 255, 0],
      "hex": "#00ff00",
    },
    "蓝色": {
      "color": const Color.fromRGBO(0, 0, 255, 1),
      "rgb": [0, 0, 255],
      "hex": "#0000ff",
    },
    "黄色": {
      "color": const Color.fromRGBO(255, 255, 0, 1),
      "rgb": [255, 255, 0],
      "hex": "#ffff00",
    },
    "紫色": {
      "color": const Color.fromRGBO(128, 0, 128, 1),
      "rgb": [128, 0, 128],
      "hex": "#800080",
    },
    "橙色": {
      "color": const Color.fromRGBO(255, 165, 0, 1),
      "rgb": [255, 165, 0],
      "hex": "#ffa500",
    },
    "粉色": {
      "color": const Color.fromRGBO(255, 192, 203, 1),
      "rgb": [255, 192, 203],
      "hex": "#ffc0cb",
    },
    "青色": {
      "color": const Color.fromRGBO(0, 255, 255, 1),
      "rgb": [0, 255, 255],
      "hex": "#00ffff",
    },
    "棕色": {
      "color": const Color.fromRGBO(165, 42, 42, 1),
      "rgb": [165, 42, 42],
      "hex": "#a52a2a",
    },
    "灰色": {
      "color": const Color.fromRGBO(128, 128, 128, 1),
      "rgb": [128, 128, 128],
      "hex": "#808080",
    },
    "白色": {
      "color": const Color.fromRGBO(255, 255, 255, 1),
      "rgb": [255, 255, 255],
      "hex": "#ffffff",
    },
    "黑色": {
      "color": const Color.fromRGBO(0, 0, 0, 1),
      "rgb": [0, 0, 0],
      "hex": "#000000",
    },
    "浅橙色": {
      "color": const Color.fromRGBO(255, 229, 185, 1),
      "rgb": [255, 229, 185],
      "hex": "#ffe5b9",
    },
    "浅绿色": {
      "color": const Color.fromRGBO(144, 238, 144, 1),
      "rgb": [144, 238, 144],
      "hex": "#90ee90",
    },
    "浅蓝色": {
      "color": const Color.fromRGBO(173, 216, 230, 1),
      "rgb": [173, 216, 230],
      "hex": "#add8e6",
    },
    "深红色": {
      "color": const Color.fromRGBO(139, 0, 0, 1),
      "rgb": [139, 0, 0],
      "hex": "#8b0000",
    },
    "深绿色": {
      "color": const Color.fromRGBO(0, 100, 0, 1),
      "rgb": [0, 100, 0],
      "hex": "#006400",
    },
    "深蓝色": {
      "color": const Color.fromRGBO(0, 0, 139, 1),
      "rgb": [0, 0, 139],
      "hex": "#00008b",
    },
    "深紫色": {
      "color": const Color.fromRGBO(148, 0, 211, 1),
      "rgb": [148, 0, 211],
      "hex": "#9400d3",
    },
    "深黄色": {
      "color": const Color.fromRGBO(204, 204, 0, 1),
      "rgb": [204, 204, 0],
      "hex": "#cccc00",
    },
    "深橙色": {
      "color": const Color.fromRGBO(255, 140, 0, 1),
      "rgb": [255, 140, 0],
      "hex": "#ff8c00",
    },
  };

  // 计算两个颜色之间的欧几里得距离
  static double _colorDistance(Color color1, Color color2) {
    return sqrt(pow(color1.red - color2.red, 2) +
        pow(color1.green - color2.green, 2) +
        pow(color1.blue - color2.blue, 2));
  }

  // 查找最接近的固定颜色
  static Map<String, dynamic> findClosestFixedColor(Color inputColor) {
    double minDistance = double.infinity;
    String closestColor = '未知颜色';
    List<int> closestRGB = [0, 0, 0];
    String closestHex = '';
    Color closestColorValue = Colors.transparent;

    fixedColors.forEach((name, colorData) {
      final color = colorData["color"] as Color;
      double distance = _colorDistance(inputColor, color);
      if (distance < minDistance) {
        minDistance = distance;
        closestColor = name;
        closestRGB = colorData["rgb"] as List<int>;
        closestHex = colorData["hex"] as String;
        closestColorValue = color;
      }
    });

    return {
      'name': closestColor,
      'rgb': closestRGB,
      'hex': closestHex,
      'color': closestColorValue,
      'display':
          '$closestColor (RGB: ${closestRGB[0]}, ${closestRGB[1]}, ${closestRGB[2]}, Hex: $closestHex)'
    };
  }

  // 查找配置文件中与输入颜色最接近的颜色
  static Map<String, dynamic> findClosestConfigColor(
      Color inputColor, List<ColorConfig> configColors) {
    double minDistance = double.infinity;
    Color closestColor = Colors.transparent;
    String closestColorName = '';
    String closestColorHex = '';
    List<int> closestColorRGB = [0, 0, 0];

    for (var colorConfig in configColors) {
      final color = colorConfig.color;
      double distance = _colorDistance(inputColor, color);
      if (distance < minDistance) {
        minDistance = distance;
        closestColor = color;
        closestColorName = colorConfig.name;
        closestColorHex = colorConfig.hex;
        closestColorRGB = colorConfig.rgb;
      }
    }

    return {
      'name': closestColorName,
      'rgb': closestColorRGB,
      'hex': closestColorHex,
      'color': closestColor,
      'display':
          '$closestColorName (RGB: ${closestColorRGB[0]}, ${closestColorRGB[1]}, ${closestColorRGB[2]}, Hex: $closestColorHex)'
    };
  }

  // 获取颜色的十六进制表示
  static String getColorHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
