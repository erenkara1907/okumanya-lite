// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:edumind_intro_app/feature/book/view_model/book_state.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_view_model.dart';
import 'package:edumind_intro_app/product/state/base/base_state.dart';
import 'package:edumind_intro_app/product/utility/audio/core_audio_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part './mixin/microphone_mixin.dart';

/// Enhanced microphone widget with core integration and external control
class Microphone extends StatefulWidget {
  /// Creates an instance of [Microphone].
  const Microphone({
    required this.state,
    required this.bookId,
    super.key,
    this.onTap,
  });

  /// Callback when the microphone is tapped
  final void Function()? onTap;

  /// Current state of the book, used to determine if open mic is active
  final BookState state;

  /// Book ID for which the recording is being made
  final String bookId;

  @override
  State<Microphone> createState() => _MicrophoneState();

  /// Static method to check if recording is active (for external control)
  // static bool get isRecordingActive => _MicrophoneState._globalRecordingState;

  /// Static method to stop recording from outside (for page navigation)
  static Future<void> stopRecordingExternal() async {
    if (_MicrophoneState._currentInstance != null) {
      await _MicrophoneState._currentInstance!._stopRecordingExternal();
    }
  }
}

class _MicrophoneState extends BaseState<Microphone>
    with TickerProviderStateMixin<Microphone>, MicrophoneMixin {
  static _MicrophoneState? _currentInstance;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _currentInstance = this;
    if (kDebugMode) {
      print('🎯 Microphone widget initialized');
    }

    // Automatically start recording on initial load
    _automaticStartRecording();
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('🧹 Disposing microphone widget...');
    }

    _pulseController.dispose();
    _scaleController.dispose();
    _expandController.dispose();
    _timerController.dispose();

    // Clear static instance if this is the current one
    if (_currentInstance == this) {
      _currentInstance = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scaleAnimation.value * _expandAnimation.value,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: BlocBuilder<BookViewModel, BookState>(
          buildWhen: (previous, current) =>
              previous.isRecording != current.isRecording ||
              previous.duration != current.duration,
          builder: (context, state) {
            return animatedBody(state);
          },
        ),
      ),
    );
  }

  Widget animatedBody(BookState state) {
    return AnimatedContainer(
      key: ValueKey(state.isRecording),
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: state.isRecording
            ? Colors.red.withOpacity(0.8)
            : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              state.isRecording ? Colors.red.withOpacity(0.6) : Colors.white24,
          width: state.isRecording ? 2 : 1,
        ),
        boxShadow: state.isRecording
            ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 12 * _pulseAnimation.value,
                  spreadRadius: 3 * _pulseAnimation.value,
                ),
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 20 * _pulseAnimation.value,
                  spreadRadius: 6 * _pulseAnimation.value,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _buildMicContent(state),
    );
  }

  Widget _buildMicContent(BookState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Microphone icon with subtle animation
        Icon(
          state.isRecording ? Icons.mic : Icons.mic_none,
          key: ValueKey(state.isRecording),
          color: Colors.white,
          size: 24,
        ),

        // Animated timer display
        if (state.isRecording) ...[
          _buildRecordingTimer(state),
        ],
      ],
    );
  }

  Widget _buildRecordingTimer(BookState state) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recording indicator dot
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),

          // Timer text
          Text(
            '${state.duration.inMinutes.toString().padLeft(2, '0')}:${(state.duration.inSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
