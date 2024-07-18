part of 'finger_print_bloc.dart';

class FingerPrintState {
  FingerPrintState({
    this.isObscure = false,
  });
  bool isObscure;

  FingerPrintState copyWith({
    bool? isObscure,
  }) {
    return FingerPrintState(
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
