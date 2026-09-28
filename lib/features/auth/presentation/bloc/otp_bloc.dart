import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/fcm_token_provider.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'otp_event.dart';
import 'otp_state.dart';

const _otpCodeLength = 4;
const _cooldownDuration = 60;

/// The OTP screen is the one place with real multi-step logic (countdown
/// timer, auto-submit on the 4th digit, resend cooldown, shake-on-error) so
/// it gets a full event-driven Bloc rather than a Cubit.
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  Timer? _timer;

  OtpBloc(this._verifyOtpUseCase, this._resendOtpUseCase) : super(const OtpState()) {
    on<OtpStarted>(_onStarted);
    on<OtpCodeChanged>(_onCodeChanged);
    on<OtpSubmitted>(_onSubmitted);
    on<OtpResendRequested>(_onResendRequested);
    on<OtpCountdownTicked>(_onCountdownTicked);
  }

  void _onStarted(OtpStarted event, Emitter<OtpState> emit) {
    emit(OtpState(phone: event.phone, flow: event.flow, cooldownSeconds: _cooldownDuration));
    _startCountdown();
  }

  void _onCodeChanged(OtpCodeChanged event, Emitter<OtpState> emit) {
    emit(state.copyWith(code: event.code, status: OtpStatus.idle, clearError: true));
    if (event.code.length == _otpCodeLength) {
      add(const OtpSubmitted());
    }
  }

  Future<void> _onSubmitted(OtpSubmitted event, Emitter<OtpState> emit) async {
    if (state.code.length != _otpCodeLength || state.status == OtpStatus.submitting) return;

    emit(state.copyWith(status: OtpStatus.submitting, clearError: true));
    final fcmToken = await FcmTokenProvider.current();
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(phone: state.phone, code: state.code, fcmToken: fcmToken),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: OtpStatus.error,
        errorMessage: failure.message,
        code: '',
        shake: true,
      )),
      (_) => emit(state.copyWith(status: OtpStatus.verified)),
    );
  }

  Future<void> _onResendRequested(OtpResendRequested event, Emitter<OtpState> emit) async {
    if (!state.canResend || state.status == OtpStatus.resending) return;

    emit(state.copyWith(status: OtpStatus.resending, clearError: true));
    final result = await _resendOtpUseCase(ResendOtpParams(phone: state.phone));

    result.fold(
      (failure) => emit(state.copyWith(status: OtpStatus.error, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(status: OtpStatus.idle, cooldownSeconds: _cooldownDuration, code: ''));
        _startCountdown();
      },
    );
  }

  void _onCountdownTicked(OtpCountdownTicked event, Emitter<OtpState> emit) {
    emit(state.copyWith(cooldownSeconds: event.secondsRemaining));
  }

  void _startCountdown() {
    _timer?.cancel();
    var remaining = _cooldownDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= 1;
      if (remaining <= 0) {
        timer.cancel();
        add(const OtpCountdownTicked(0));
      } else {
        add(OtpCountdownTicked(remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
