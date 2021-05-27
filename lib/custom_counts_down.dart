import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum HSYTimerState {
  Start, // 开始倒计时
  Bouncing, // 倒计时中
  Ended, // 倒计时结束
}

/// 点击倒计时按钮启动倒计时功能
typedef HSYClickCountDownCallBack = Future<bool> Function(
    int maxTimes, int minTimes);

/// 倒计时开始，每间隔一定时间后回调外部
typedef HSYTimerStateCallBack = void Function(
    int currentTimes, int residueTimes, HSYTimerState state);

/// 通过获取外部的缓存的计时器当前所走到的位置
typedef HSYCurrentTimersCallBack = int Function();

/// 获取外部控制的计时器在开始时或者结束后所显示的文本内容
typedef HSYTimerDefaultTextCallBack = String Function(
    bool isEndedStateCallBack);

/// 外部控制倒计时按钮是否停止计时器
typedef HSYClosedTimerCallBack = StreamController<bool> Function(
    int currentTimes);

class HSYCountDownButton extends StatefulWidget {
  /// 倒计时最大的值
  final int maxTimes;

  /// 倒计时最小的值，默认为0
  final int minTimes;

  /// 倒计时间隔时间，默认为间隔1s
  final Duration timerDuration;

  /// 启动倒计时的callback回调事件
  final HSYClickCountDownCallBack onTap;

  /// 倒计时的计时器正在计时时，通过这个callback回调事件
  final HSYTimerStateCallBack onTimerChanged;

  /// 停止计时器
  final HSYClosedTimerCallBack onReleaseTimer;

  /// 通过这个callback获取外部同步缓存的当前倒计时时间
  final HSYCurrentTimersCallBack onCurrentTimes;

  /// 倒计时开始前或者结束后的[Text]的占位内容
  final HSYTimerDefaultTextCallBack onDefaultText;

  /// 允许外部传入一个流控制器来从外部控制这个流控制的[close]状态
  final StreamController<String> changedStreamController;

  /// 倒计时按钮的内边距
  final EdgeInsets padding;

  /// 倒计时的text的文字风格
  final TextStyle textStyle;

  const HSYCountDownButton({
    Key key,
    @required this.onDefaultText,
    @required this.maxTimes,
    @required this.onTap,
    this.minTimes = 0,
    this.timerDuration = const Duration(seconds: 1),
    this.padding = EdgeInsets.zero,
    this.changedStreamController,
    this.textStyle,
    this.onTimerChanged,
    this.onCurrentTimes,
    this.onReleaseTimer,
  }) : super(key: key);

  @override
  _HSYCountDownButtonState createState() => _HSYCountDownButtonState();
}

class _HSYCountDownButtonState extends State<HSYCountDownButton> {
  int _currentTimes;
  bool _stopTimerState;
  StreamController<String> _timerStreamController;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stopTimerState = true;
    _currentTimes = this.widget.minTimes;
    _timerStreamController = (this.widget.changedStreamController ??
        StreamController<String>.broadcast());
    if (this.widget.onReleaseTimer != null) {
      this.widget.onReleaseTimer(_currentTimes).stream.listen(
            (event) {
          _releaseTimer(event);
        },
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (this.widget.changedStreamController == null) {
      _timerStreamController.close();
      _stopTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: this.widget.padding,
        child: StreamBuilder(
          stream: _timerStreamController.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            final TextStyle textStyle = this.widget.textStyle ??
                TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                );
            String text = '';
            if (this.widget.onCurrentTimes != null) {
              final int currentTimes = this.widget.onCurrentTimes();
              if (currentTimes > this.widget.minTimes &&
                  currentTimes < this.widget.maxTimes) {
                text = '${currentTimes}s';
              }
            }
            return Text(
              (snapshot.data ??
                  (text.isNotEmpty ? text : this.widget.onDefaultText(false))),
              style: textStyle,
            );
          },
        ),
      ),
      onTap: () {
        if (_stopTimerState && this.widget.onTap != null) {
          this.widget.onTap(this.widget.maxTimes, this.widget.minTimes).then(
                (value) {
              _startTimer();
            },
          );
        }
        _stopTimerState = false;
      },
    );
  }

  /// 启动计时器
  void _startTimer() {
    if (_timer == null) {
      _timer = _createTimer();
    }
  }

  /// 销毁计时器
  void _stopTimer() {
    if (_timer != null) {
      _currentTimes = this.widget.minTimes;
      _stopTimerState = true;
      _timer.cancel();
      _timer = null;
    }
  }

  /// 创建计时器
  Timer _createTimer() {
    _onChangedTimes(HSYTimerState.Start);
    _timerStreamController.sink.add('${this.widget.maxTimes}s');
    return Timer.periodic(
      this.widget.timerDuration,
          (Timer timer) {
        HSYTimerState state = HSYTimerState.Bouncing;
        _currentTimes = min((_currentTimes + 1), this.widget.maxTimes);
        String signal = '${this.widget.maxTimes - _currentTimes}s';
        if (_currentTimes >= this.widget.maxTimes) {
          state = HSYTimerState.Ended;
          signal = this.widget.onDefaultText(true);
          _stopTimer();
        }
        _timerStreamController.sink.add(signal);
        _onChangedTimes(state);
      },
    );
  }

  /// 计时器跳动时回调
  void _onChangedTimes([
    HSYTimerState state = HSYTimerState.Start,
  ]) {
    if (this.widget.onTimerChanged != null) {
      this.widget.onTimerChanged(
        _currentTimes,
        (this.widget.maxTimes - _currentTimes),
        state,
      );
    }
  }

  /// 销毁计时器并重置计时器按钮的文本内容
  void _releaseTimer([
    bool isEndedStateCallBack = false,
  ]) {
    _stopTimer();
    _timerStreamController.sink
        .add(this.widget.onDefaultText(isEndedStateCallBack));
  }
}
