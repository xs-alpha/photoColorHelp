# 功能
一个ps颜色工具,可以帮助对颜色不敏感的同学调色,可以查找当前颜色相近的颜色和相近的中国色, 可以查找和目标颜色的区别,并给出建议
建议分为三个方面,色彩平衡,色相饱和度,和可选颜色,只能做参照

# 使用截图

![https://pic1.imgdb.cn/item/677cbaa0d0e0a243d4f10312.png](https://pic1.imgdb.cn/item/677cbaa0d0e0a243d4f10312.png)

![https://pic1.imgdb.cn/item/677cbad3d0e0a243d4f10352.png](https://pic1.imgdb.cn/item/677cbad3d0e0a243d4f10352.png)

![https://pic1.imgdb.cn/item/677cbaf6d0e0a243d4f10389.png](https://pic1.imgdb.cn/item/677cbaf6d0e0a243d4f10389.png)

![https://pic1.imgdb.cn/item/677cba65d0e0a243d4f102ca.png](https://pic1.imgdb.cn/item/677cba65d0e0a243d4f102ca.png)

# 使用
左侧的输入框可以输入十六进制的颜色,回车会进行比对,默认加载assets/colors.json中的中国色,可以写一个适配器去适配其他的颜色配置文件
右侧的输入框回车后会对比左侧的颜色,左侧的颜色经过ps中部分功能的变换得到右边的颜色,但目前仅作参考

# 待完善
- 屏幕取色功能做了很久,一直有问题,目前用不了,有能力的大佬可以提pr
- 色彩建议功能,感兴趣的大佬可以提pr, 提建议的算法目前很简陋
