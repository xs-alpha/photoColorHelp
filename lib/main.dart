import 'dart:convert'; // 导入json解析库

import 'package:color_detect/tool/color_picker_manager.dart';
import 'package:color_detect/tool/color_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 导入文件加载库
import 'package:screenshot/screenshot.dart'; // 使用 screenshot 插件
import 'package:window_size/window_size.dart';

import 'tool/color_config.dart';
import 'tool/color_matcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  String _closestFixedColor = '';
  Color _inputColor = Colors.white;
  Color _targetColor = Colors.transparent;
  Color _closestConfigColor = Colors.transparent;
  String _closestConfigColorName = '';
  String _adjustmentSuggestion = '';

  // 固定颜色定义
  final Map<String, Map<String, dynamic>> fixedColors =
      ColorMatcher.fixedColors;

  // 从colors.json中加载的颜色列表
  List<ColorConfig> configColors = [];

  // 创建 ScreenshotController 实例
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _loadColorsFromFile(); // 初始化时加载颜色数据
    _setWindowSize(); // 设置窗口大小
    // _adjustmentSuggestion = suggestion;
  }

  // 设置窗口大小为400x400
  void _setWindowSize() {
    setWindowTitle('Color Detector'); // 设置窗口标题
    setWindowFrame(const Rect.fromLTWH(100, 100, 1260, 650)); // 设置窗口大小
    setWindowMinSize(const Size(1260, 650)); // 设置最小窗口大小
    setWindowMaxSize(const Size(1260, 650)); // 设置最大窗口大小
  }

  // 从colors.json文件中加载颜色数据
  Future<void> _loadColorsFromFile() async {
    try {
      final jsonString = await rootBundle.loadString('assets/colors.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        configColors =
            jsonList.map((json) => ColorConfig.fromJson(json)).toList();
      });
    } catch (e) {
      print('加载colors.json失败: $e');
    }
  }

  // 修改 _findClosestFixedColor 调用处的代码
  void _findClosestFixedColor(Color inputColor) {
    final result = ColorMatcher.findClosestFixedColor(inputColor);
    setState(() {
      _closestFixedColor = result['display'];
    });
  }

  // 查找最接近的配置颜色
  void _findClosestConfigColor(Color inputColor) {
    final result =
        ColorMatcher.findClosestConfigColor(inputColor, configColors);
    setState(() {
      _closestConfigColor = result['color'];
      _closestConfigColorName = result['display'];
    });
  }

  // 打开取色器
  void _openColorPicker() {
    ColorPickerManager.openColorPicker(
      context: context,
      currentColor: _inputColor,
      onColorChanged: (Color color) {
        setState(() {
          _inputColor = color;
          _findClosestFixedColor(color);
          _findClosestConfigColor(color);
        });
      },
    );
  }

  // 从屏幕上取色
  void _openEyeDropper() {
    ColorPickerManager.openEyeDropper(
      context: context,
      screenshotController: _screenshotController,
      onColorSelected: (Color color) {
        setState(() {
          _inputColor = color;
          _findClosestFixedColor(color);
          _findClosestConfigColor(color);
        });
      },
    );
  }

  void _onSubmitted(String value) {
    if (value.isEmpty) return;

    // 将16进制颜色转换为Color
    try {
      final hexColor = value.replaceFirst('#', '');
      final color = Color(int.parse('0xFF$hexColor'));
      setState(() {
        _inputColor = color;
        _findClosestFixedColor(color);
        _findClosestConfigColor(color);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无效的16进制颜色值')),
      );
    }
  }

  void _onTargetSubmitted(String value) {
    if (value.isEmpty) return;

    // 将16进制颜色转换为Color
    try {
      final hexColor = value.replaceFirst('#', '');
      final color = Color(int.parse('0xFF$hexColor'));
      setState(() {
        _targetColor = color;
        _calculateAdjustment();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无效的16进制颜色值')),
      );
    }
  }

  void _calculateAdjustment() {
    final inputRed = _inputColor.red;
    final inputGreen = _inputColor.green;
    final inputBlue = _inputColor.blue;

    final targetRed = _targetColor.red;
    final targetGreen = _targetColor.green;
    final targetBlue = _targetColor.blue;

    final redDiff = targetRed - inputRed;
    final greenDiff = targetGreen - inputGreen;
    final blueDiff = targetBlue - inputBlue;

    // 获取主要颜色
    final List<String> mainColors = colorTool.determineMainColors(_inputColor);

    String suggestion = '';

    // 1. 添加色相饱和度调整建议
    suggestion += colorTool.calculateHSLAdjustment(_inputColor, _targetColor);
    // 2. 色彩平衡建议
    suggestion +=
        colorTool.colorReblanceAdjustment(redDiff, greenDiff, blueDiff);

    // 3. 可选颜色建议
    suggestion += colorTool.selectedColorAdjustment(
        mainColors, redDiff, greenDiff, blueDiff);
    setState(() {
      _adjustmentSuggestion = suggestion;
    });
  }

  void _clearInput() {
    _controller.clear();
    setState(() {
      _inputColor = Colors.transparent;
      _closestFixedColor = '';
      _closestConfigColor = Colors.transparent;
      _closestConfigColorName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Detector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          children: [
            SizedBox(
              width: 450,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearInput,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: '请输入16进制颜色值（例如#f9f4dc）',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: _onSubmitted,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.color_lens),
                        onPressed: _openColorPicker,
                      ),
                      IconButton(
                        icon: const Icon(Icons.colorize),
                        onPressed: _openEyeDropper,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_inputColor != Colors.transparent)
                    Column(
                      children: [
                        Text(
                            '输入的RGB三原色: R:${_inputColor.red} G:${_inputColor.green} B:${_inputColor.blue}'),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 30,
                          color: _inputColor,
                        ),
                        const SizedBox(height: 8),
                        Text('最接近的固定颜色: $_closestFixedColor'),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 30,
                          color: fixedColors[_closestFixedColor.split(' ')[0]]
                                  ?["color"] ??
                              Colors.transparent,
                        ),
                        const SizedBox(height: 8),
                        Text('最接近的(中国传统色): $_closestConfigColorName'),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 30,
                          color: _closestConfigColor,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const VerticalDivider(
              thickness: 1,
              color: Colors.black,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _targetController,
                      decoration: const InputDecoration(
                        hintText: '请输入目标16进制颜色值（例如#f9f4dc）',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _onTargetSubmitted,
                    ),
                    const SizedBox(height: 20),
                    if (_targetColor != Colors.transparent)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '目标RGB三原色: R:${_targetColor.red} G:${_targetColor.green} B:${_targetColor.blue}',
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 30,
                                color: _targetColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '调整建议：',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              SelectableText(_adjustmentSuggestion),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
