# 1.实现效果图
![drawingBoard](https://github.com/SmileYang966/drawingBoard/blob/master/drawingBoard.gif)

# 2.画板主要功能：
1.画线
2.撤销上一步操作
3.清空当前画板
4.橡皮擦
5.保存所画内容

# 3.两种画板制作思路：
## 3.1 drawRect + Touch操作(TouchesBegan、TouchesMoved以及TouchesEnd)
我们需要保存所有的线，假如用户已经画了4条线，在画第五条线的时候(第5条线TouchMoved的过程中)，第5条线每画一个点，就要将前面4条线在drawRect方法里重绘一下，否则，前面的画的线就会丢失。
可能存在的问题：因为这些drawrect都是保存在内存中的，每次都叠加前面的绘图操作，很容易引起内存的爆炸。所以使用时得格外注意。


如何解决这个问题呢？我们可以看看CAShapeLayer方法
## 3.2 CAShapeLayer + UIBeizerPath +Touch操作(TouchesBegan、TouchesMoved以及TouchesEnd)
使用CAShapeLayer+ UIBeizerPath 来绘图，不需要用到drawRect，使用CAShapeLayer方法的本质上就是创建了很多
子CAShapeLayer，每个子CAShapeLayer对象都单独保存了一个path，所以最后在屏幕显示时，系统会将当前view的layer以及它的所有子layer都渲染出来。
无形之中，其实我们创建了很多子CAShapeLayer对象，而这些CAShapeLayer据说时GPU管理的的（不懂？？），对内存优化确实挺大。（大家可以测试了看看）

# 4.橡皮擦功能
设计思路：
1.在ViewController模块，准备一个ImageView，并设置相应的图片，imageView添加到self.view当中。

2.在imageView添加一个子view(SCDrawingView)，我们将要在这个子view上做一些touchesBegan、TouchesMoved以及TouchedEnd操作。

3.创建SCStrokeLine对象，我们将要用这个对象存储每次画的path，以及每条path的一些属性(线宽、线条颜色、blendMode)

悲伤的是，如果要用到橡皮擦功能，我们就不能用CAShapeLayer去画线条了，至少暂时我没找到解决方法。

# 5.保存所画内容
按照步骤4可知，我们准备了一个imageView，以及在imageView添加了子view(SCDrawingView)，最后我们要将所画的内容保存成一张图片。
这时候，我们需要用到一个方法：
- (void)renderInContext:(CGContextRef)ctx;
注意，我们应该在imageView上去开一个图形上下文，将imageView的layer渲染到当前的上下文中，因为我们在imageView中添加了子view(SCDrawingView)，换句话说imageView的layer也包含了SCDrawingView对象的layer，因此我们需要将imageview的layer渲染到画板上，这样才能得到SCDrawingView所画的带背景的线条。
