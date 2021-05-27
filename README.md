# flutter_count_down

一个倒计时计时器效果的按钮

## Getting Started

``` 

HSYCountDownButton(
                        maxTimes: 60,
                        onCurrentTimes: () {
                          return _currentTimes2;
                        },
                        changedStreamController: _streamController2,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.amber,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        onTap: (int maxTimes, int minTimes) {
                          return Future.value(true);
                        },
                        onTimerChanged: (int currentTimes, int residueTimes,
                            HSYTimerState state) {
                          _currentTimes2 = residueTimes;
                          print(
                              'currentTimes: $currentTimes, residueTimes: $residueTimes, state: ${state.toString()}');
                        },
                        onDefaultText: (bool isEndedStateCallBack) {
                          return (isEndedStateCallBack
                              ? "Reset!"
                              : "Let's Go!");
                        },
                      ),

``` 
