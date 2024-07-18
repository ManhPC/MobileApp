part of 'finger_print_bloc.dart';

abstract class FingerPrintEvent {
  const FingerPrintEvent();
}

class IsChangeObscure extends FingerPrintEvent {
  final bool isObscure;
  const IsChangeObscure({
    required this.isObscure,
  });
}
