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
      required double progress,
      required VoidCallback onOpenResult,
      required VoidCallback onStart,
      required VoidCallback onCancel})
      : _status = status,
        _progress = progress,
        _onOpenResult = onOpenResult,
        _onStart = onStart,
        _onCancel = onCancel;

  Status _status;
  @override
  Status get status => _status;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenResult;
  final VoidCallback _onStart;
  final VoidCallback _onCancel;

  bool _isStarted = false;

  @override
  void onStart() {
    notifyListeners();

    if (status == Status.stopped && !_isStarted) {
      _isStarted = true;

      _onStart();
      notifyListeners();
    }
  }

  @override
  void onCancel() {
    _progress = 0;
    _isStarted = false;
    _status = Status.stopped;
    _onCancel();
    notifyListeners();
  }

  @override
  void onOpenResult() {
    if (status == Status.finished) {
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
      this.progress = 0.0,
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
    return AspectRatio(
      aspectRatio: 1.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: progress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: _inProgress
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0.0),
            valueColor: AlwaysStoppedAnimation(_inProgress
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2.0,
            value: progress,
          );
        },
      ),
    );
  }

  Widget _buildButtonShape({
    required Widget child,
  }) {
    return AnimatedContainer(
        margin: EdgeInsets.all(20),
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
