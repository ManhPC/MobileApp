import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'finger_print_event.dart';
part 'finger_print_state.dart';

class FingerPrintBloc extends Bloc<FingerPrintEvent, FingerPrintState> {
  FingerPrintBloc() : super(FingerPrintState()) {
    on<IsChangeObscure>(_onChangeObscure);
  }

  _onChangeObscure(IsChangeObscure event, Emitter<FingerPrintState> emit) {
    emit(state.copyWith(isObscure: event.isObscure));
  }
}
