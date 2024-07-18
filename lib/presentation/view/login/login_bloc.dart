import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginInit>(_loginInit);
    on<LoginSubmitted>(_onSubmitted);
    on<IsUsernameChanged>(_isUsernameChanged);
    on<IsPasswordChanged>(_isPasswordChanged);
    on<IsSaveLoginChanged>(_isSaveLoginChanged);
  }

  // LoginState fromJson(Map<String, dynamic> json) {
  //   return LoginState(
  //     isSaveLogin: json['isSaveLogin'] ?? false,
  //     custodycd: json['custodycd'] ?? '',
  //     password: json['password'] ?? '',
  //   );
  // }

  // Map<String, dynamic> toJson(LoginState state) {
  //   return {
  //     'isSaveLogin': state.isSaveLogin,
  //     'custodycd': state.custodycd,
  //     'password': state.password,
  //   };
  // }

  _isSaveLoginChanged(IsSaveLoginChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(isSaveLogin: event.isSaveLogin));
  }

  _isUsernameChanged(IsUsernameChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(custodycd: event.custodycd));
  }

  _isPasswordChanged(IsPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    await HydratedBloc.storage.write('isSaveLogin', state.isSaveLogin);
    await HydratedBloc.storage.write('custodycd', state.custodycd);
    if (state.isSaveLogin) {
      HydratedBloc.storage.write('password', state.password);
    } else {
      //HydratedBloc.storage.delete('custodycd');
      HydratedBloc.storage.delete('password');
    }
  }

  Future<void> _loginInit(LoginInit event, Emitter<LoginState> emit) async {
    final isSaveLogin = await HydratedBloc.storage.read('isSaveLogin');
    final isUsernameSave = await HydratedBloc.storage.read('custodycd');
    final isPasswordSave = await HydratedBloc.storage.read('password');
    if (isSaveLogin != null) {
      emit(state.copyWith(isSaveLogin: isSaveLogin));
      if (isUsernameSave != null && isPasswordSave != null) {
        emit(state.copyWith(custodycd: isUsernameSave));
        emit(state.copyWith(password: isPasswordSave));
      }
    }
  }
}
