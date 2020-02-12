import 'package:flutter/material.dart';

class BreathAnimation extends StatefulWidget {
  BreathAnimation({
    this.child,
    @required this.radius,
    @required this.maxRadius,
    this.cycles,
    this.spreadColor = Colors.grey,
    this.duration = const Duration(milliseconds: 3000),
  });

  final Widget child;
  final double radius;
  final double maxRadius;
  final int cycles;
  final Color spreadColor;
  final Duration duration;
  static bool isRun=false;

  @override
  _BreathAnimationState createState() => _BreathAnimationState();
}

class _BreathAnimationState extends State<BreathAnimation>
    with TickerProviderStateMixin {
  List<Widget> children = [];
  List<AnimationController> controllers = [];
  bool isExpand=true;

  @override
  void initState() {
    super.initState();
    if (widget.child != null) {
      children.add(
        ClipOval(
          child: SizedBox(
            width: widget.radius,
            height: widget.radius,
            child: widget.child,
          ),
        ),
      );
    }
    start();
  }

  void start() async {
    int i = 0;
    while (widget.cycles == null ? true : i < widget.cycles) {
      if (mounted) {
        try {
          setState(() {
            Animation<double> _animation;
             AnimationController  _animationController =
                AnimationController(vsync: this, duration: widget.duration);
            _animation = CurvedAnimation(
                parent: _animationController, curve: Curves.linear);
            animationControl(_animationController);
            controllers.add(_animationController);
            _animationController.forward();
            widget.child != null
                ?
            getAnimate(_animation)
                :
            getAnimate(_animation)
            ;
          }) ;}catch(e){
          }
        }
      if (widget.cycles != null) i++;
      await  Future<dynamic>.delayed(
          Duration(milliseconds: widget.duration.inMilliseconds ~/ 3)
      );
    }
  }

  void animationControl(AnimationController _animationController) {
            _animationController.addStatusListener((status) {
             // print("animationControl() status=${status}");
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 1000), () {
          //关闭loading
          _animationController.reverse();
          isExpand=false;
        });
      }
      if (status == AnimationStatus.dismissed) {
        Future.delayed(Duration(milliseconds: 1000), () {
        _animationController.forward();
        isExpand=true;
        });
      }
    });
  }

  void getAnimate(Animation<double> _animation) {
   // print("getAnimate=${widget.radius}");
    if(children.length==0) {
      return children.add(AnimatedSpread(
        animation: _animation,
        radius: widget.radius,
        maxRadius: widget.maxRadius,
        color: widget.spreadColor,
      )
      );
    }else{

    }
  }


  @override
  void dispose() {
    try {
      super.dispose();
      controllers.forEach((c) {
        c.dispose();
        c = null;
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children,
      alignment: Alignment.center,
    );
  }
}

class AnimatedSpread extends AnimatedWidget {
  final Tween<double> _opacityTween = Tween(begin: 1, end: 0);
  final Tween<double> _radiusTween;
  final Color color;

  AnimatedSpread(
      {Key key,
      @required Animation<double> animation,
      @required double radius,
      @required double maxRadius,
      @required this.color})
      : _radiusTween = Tween(begin: radius, end: maxRadius),
        super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double width=_radiusTween.evaluate(animation);
    double height= _radiusTween.evaluate(animation);
   // print("width:$width|height:$height");
    return Container(
      width: _radiusTween.evaluate(animation),
      height: _radiusTween.evaluate(animation),
      child: ClipOval(
        child: Opacity(
          opacity: _opacityTween.evaluate(animation),
          child: Container(
            color: color,
          ),
        ),
      ),
    );
  }
}
