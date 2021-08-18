import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Status { stopped, inProgress, finished, error }

abstract class FancyButtonController implements ChangeNotifier {
  Status get status;
  double get progress;

  void onStart();
  void onCancel();
  void onOpenResult();
}

class FancyController extends FancyButtonController with ChangeNotifier {
  FancyController(
      {Status status = Status.stopped,
      double progress = 0.0,
      required VoidCallback onOpenResult,
      required VoidCallback onStart,
      required VoidCallback onCancel})
      : _status = status,
        _progress = progress,
        _onOpenResult = onOpenResult,
        _onStart = onStart,
        _onCancel = onCancel;

  bool _isStarted = false;
  Status _status = Status.stopped;
  @override
  Status get status => _status;
  set status(Status value) {
    _status = value;
  }

  double _progress = 0.0;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenResult;
  final VoidCallback _onStart;
  final VoidCallback _onCancel;

  /// Update the progress value and wait for a given duration to simulate awesome downloads
  Future<void> TickTock(double progress, int durationInSeconds) async {
    await Future<void>.delayed(Duration(seconds: durationInSeconds));
    _progress = progress;
    notifyListeners();
  }

  @override
  Future<void> onStart() async {
    _isStarted = true;
    if (_status == Status.stopped) {
      _status = Status.inProgress;
      await TickTock(0.5, 1);

      _onStart();
      _status = Status.finished;
      await TickTock(1, 1);
    }
    _isStarted = false;
  }

  @override
  void onCancel() {
    _progress = 0;
    _status = Status.stopped;
    _onCancel();
    notifyListeners();
  }

  @override
  void onOpenResult() {
    if (_status == Status.finished) {
      _onOpenResult();
    }
  }
}

@immutable
class FancyButton extends StatelessWidget {
  FancyButton(
      {Key? key,
      required this.status,
      this.transitionDuration = const Duration(milliseconds: 500),
      required this.progress,
      required this.onStart,
      required this.onCancel,
      required this.onOpenResult,
      required this.text})
      : super(key: key);

  final VoidCallback onStart;
  final VoidCallback onCancel;
  final VoidCallback onOpenResult;

  final Status status;
  final Duration transitionDuration;
  final double progress;
  final String text;

  bool get _inProgress => status == Status.inProgress;
  bool get _isFinished => status == Status.finished;

  void _onPressed() {
    switch (status) {
      case Status.stopped:
        onStart();
        break;

      case Status.inProgress:
        onCancel();
        break;

      case Status.finished:
        onOpenResult();
        break;

      case Status.error:
        // nothing here!
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onPressed,
        child: Stack(
          children: [
            _buildButtonShape(child: _buildText(context)),
            _buildDownloadingProgress()
          ],
        ));
  }

  Widget _buildDownloadingProgress() {
    return Positioned.fill(
        child: AnimatedOpacity(
            duration: transitionDuration,
            opacity: _inProgress ? 1.0 : 0.0,
            curve: Curves.ease,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildProgressIndicator(),
                if (_inProgress)
                  const Icon(Icons.stop,
                      size: 14.0, color: CupertinoColors.activeBlue)
              ],
            )));
  }

  Widget _buildProgressIndicator() {
    print('_inProgress set to ${_inProgress}');
    var bgColor = _inProgress
        ? CupertinoColors.lightBackgroundGray
        : Colors.white.withOpacity(0.0);
    var valColor = AlwaysStoppedAnimation(_inProgress
        ? CupertinoColors.lightBackgroundGray
        : CupertinoColors.activeBlue);

    var val = _inProgress ? null : progress;
    return AspectRatio(
      aspectRatio: 1.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: progress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: bgColor,
            valueColor: valColor,
            strokeWidth: 2.0,
            value: val,
          );
        },
      ),
    );
  }

  Widget _buildButtonShape({
    required Widget child,
  }) {
    return AnimatedContainer(
        duration: transitionDuration,
        curve: Curves.ease,
        width: 150,
        decoration: _inProgress
            ? ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.white.withOpacity(0.0))
            : const ShapeDecoration(
                shape: StadiumBorder(),
                color: CupertinoColors.lightBackgroundGray),
        child: child);
  }

  Widget _buildText(BuildContext context) {
    final textValue = _isFinished ? 'View Results' : text;
    final opacity = _inProgress ? 0.0 : 1.0;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: opacity,
          curve: Curves.ease,
          child: Text(
            textValue,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button?.copyWith(
                fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
          ),
        ));
  }
}
