import 'dart:math'; // 导入math库

import 'package:flutter/material.dart';

class colorTool {
  // 新增：色相饱和度调整计算方法
  static String calculateHSLAdjustment(Color inputColor, Color targetColor) {
    final HSLColor inputHSL = HSLColor.fromColor(inputColor);
    final HSLColor targetHSL = HSLColor.fromColor(targetColor);

    // 计算色相差值（需要考虑环形特性）
    double hueDiff = targetHSL.hue - inputHSL.hue;
    if (hueDiff > 180) hueDiff -= 360;
    if (hueDiff < -180) hueDiff += 360;

    // 计算饱和度和亮度的差值
    final saturationDiff = (targetHSL.saturation - inputHSL.saturation) * 100;
    final lightnessDiff = (targetHSL.lightness - inputHSL.lightness) * 100;

    return '''
色相/饱和度/明度调整建议：
  - 色相: ${hueDiff.round()}
  - 饱和度: ${saturationDiff.round()}%
  - 明度: ${lightnessDiff.round()}%
''';
  }

  // 新增：确定主色调的方法
  static List<String> determineMainColors(Color color) {
    final List<String> mainColors = [];
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    // 计算RGB中的最大值和最小值
    final int maxVal = [r, g, b].reduce(max);
    final int minVal = [r, g, b].reduce(min);
    final int diff = maxVal - minVal;

    // 设定阈值来判断颜色的主要成分
    const threshold = 50;

    if (diff < threshold) {
      // 如果RGB差值很小，可能是灰色系
      if (maxVal > 200) return ['白色'];
      if (maxVal < 50) return ['黑色'];
      return ['中性色'];
    }

    // 判断主要颜色成分
    if (r > g + threshold && r > b + threshold) mainColors.add('红色');
    if (g > r + threshold && g > b + threshold) mainColors.add('绿色');
    if (b > r + threshold && b > g + threshold) mainColors.add('蓝色');
    if (r > threshold && g > threshold && b < threshold) mainColors.add('黄色');
    if (r > threshold && b > threshold && g < threshold) mainColors.add('洋红');
    if (g > threshold && b > threshold && r < threshold) mainColors.add('青色');

    return mainColors.isEmpty ? ['中性色'] : mainColors;
  }

  static selectedColorAdjustment(
      List<String> mainColors, int redDiff, int greenDiff, int blueDiff) {
    String suggestion = '';
    suggestion += '可选颜色调整建议：\n';
    // 根据主要颜色成分给出建议
    for (String color in mainColors) {
      suggestion += '调整 $color：\n';
      switch (color) {
        case '红色':
          suggestion +=
              '''   - 青色：${-redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '绿色':
          suggestion +=
              '''   - 青色：${redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${-greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '蓝色':
          suggestion +=
              '''   - 青色：${redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${-blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '黄色':
          suggestion +=
              '''   - 青色：${redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '青色':
          suggestion +=
              '''   - 青色：${-redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${-greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${-blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '洋红':
          suggestion +=
              '''   - 青色：${-redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${-blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '白色':
          suggestion +=
              '''   - 青色：${redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * -100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '黑色':
          suggestion +=
              '''   - 青色：${-redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${-greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${-blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
        case '中性色':
          suggestion +=
              '''   - 青色：${redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 洋红：${greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黄色：${blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).abs().toStringAsFixed(0)}%
   - 黑色：${((redDiff + greenDiff + blueDiff) / (3 * 255) * 100).abs().toStringAsFixed(0)}%\n''';
          break;
      }
    }
    return suggestion;
  }

  static colorReblanceAdjustment(int redDiff, int greenDiff, int blueDiff) {
    String suggestion = '';
    suggestion += '''色彩平衡调整建议：
1. 中间调：
   - 青色/红色：${redDiff > 0 ? '+' : ''}${(redDiff / 255 * 100).toStringAsFixed(0)}
   - 洋红/绿色：${greenDiff > 0 ? '+' : ''}${(greenDiff / 255 * 100).toStringAsFixed(0)}
   - 黄色/蓝色：${blueDiff > 0 ? '+' : ''}${(blueDiff / 255 * 100).toStringAsFixed(0)}

2. 高光：
   - 青色/红色：${(redDiff / 255 * 70).toStringAsFixed(0)}
   - 洋红/绿色：${(greenDiff / 255 * 70).toStringAsFixed(0)}
   - 黄色/蓝色：${(blueDiff / 255 * 70).toStringAsFixed(0)}

3. 阴影：
   - 青色/红色：${(redDiff / 255 * 130).toStringAsFixed(0)}
   - 洋红/绿色：${(greenDiff / 255 * 130).toStringAsFixed(0)}
   - 黄色/蓝色：${(blueDiff / 255 * 130).toStringAsFixed(0)}
\n''';
    return suggestion;
  }
}
