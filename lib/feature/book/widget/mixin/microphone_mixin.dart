part of '../microphone.dart';

/// A mixin that provides microphone functionality to the [Microphone] widget.
mixin MicrophoneMixin
    on BaseState<Microphone>, TickerProviderStateMixin<Microphone> {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _expandController;
  late AnimationController _timerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _expandAnimation;

  final _audioRecorder = CoreAudioRecorder.instance;

  @override
  void didUpdateWidget(Microphone oldWidget) {
    super.didUpdateWidget(oldWidget);

    final current = widget.state.currentPage;
    final previous = oldWidget.state.currentPage;

    final isPageChanged = current != previous;
    final isMicOpened = widget.state.isOpenMic;

    if (isMicOpened && isPageChanged) {
      context.read<BookViewModel>().handlePageChangeWithStopStart(
            bookId: widget.bookId,
            onAnimationsStart: () {
              Future.delayed(Duration.zero, () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;

                  _expandController.forward();
                  _pulseController.repeat(reverse: true);
                  _timerController.forward();
                });
              });
            },
            onAnimationsStop: () {
              _pulseController.stop();
              _fastReverseAnimations();
            },
            settingsDialog: _showSettingsDialog,
          );
    }
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _timerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _expandAnimation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: Curves.easeOut, // elasticOut yerine daha hızlı easeOut
      ),
    );
  }

  void _fastReverseAnimations() {
    _expandController.stop();
    _expandController.value = 0.0;
    _timerController.stop();
    _timerController.value = 0.0;
  }

  void _automaticStartRecording() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.state.isOpenMic) {
        context.read<BookViewModel>().startRecording(
              bookId: widget.bookId,
              onAnimations: () {
                _expandController.forward();
                _timerController.forward();
                _pulseController.repeat(reverse: true);
              },
              settingsDialog: _showSettingsDialog,
            );
      }
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.settings, color: Colors.blue),
            SizedBox(width: 8),
            Text('Permission Required'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Microphone permission is required for recording.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Please enable it in Settings:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text('• Go to Settings > Apps > [App Name]'),
            Text('• Tap Permissions'),
            Text('• Enable Microphone'),
            Text('• Return to the app'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final opened = await openAppSettings();
              if (!opened && mounted) {
                // CoreSnackBar.showError(context, 'Could not open settings. Please open manually.');
              }
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// External method to stop recording (called from outside)
  Future<void> _stopRecordingExternal() async {
    if (context.read<BookViewModel>().state.isRecording) {
      if (kDebugMode) {
        print('🔄 External stop recording request');
      }

      try {
        await _audioRecorder.stopRecording();
        if (kDebugMode) print('✅ Recorder.cancelRecording() çalıştı');

        _pulseController.stop();
        _fastReverseAnimations();

        context.read<BookViewModel>().setValueToRecording(isRecording: false);

        if (kDebugMode) {
          print('✅ External recording stop completed');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error in external stop: $e');
        }
      }
    }
  }

  void _handleTapDown() {
    _scaleController.forward();
  }

  void _handleTapUp() {
    _scaleController.reverse();
  }
}
