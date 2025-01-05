// 颜色配置类，用于解析colors.json
import 'dart:ui';

class ColorConfig {
  final List<int> cmyk;
  final List<int> rgb;
  final String hex;
  final String name;
  final String pinyin;

  ColorConfig({
    required this.cmyk,
    required this.rgb,
    required this.hex,
    required this.name,
    required this.pinyin,
  });

  factory ColorConfig.fromJson(Map<String, dynamic> json) {
    return ColorConfig(
      cmyk: List<int>.from(json['CMYK']),
      rgb: List<int>.from(json['RGB']),
      hex: json['hex'],
      name: json['name'],
      pinyin: json['pinyin'],
    );
  }

  Color get color => Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
}
