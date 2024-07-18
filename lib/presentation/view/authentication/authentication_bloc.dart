import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Uninitialized()) {
    on<AppStarted>(_appStarted);
    on<LoggedIn>(_loggedIn);
    on<LoggedOut>(_loggedOut);
    on<Unauthentication>((event, emit) => emit(Unauthenticated()));
  }

  _appStarted(event, emit) async {
    final token = await HydratedBloc.storage.read('token') ?? '';
    if (token.isNotEmpty) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  _loggedIn(event, emit) async {
    HydratedBloc.storage.write('token', event.token);
    HydratedBloc.storage.write('custodycd', event.custodycd);
    HydratedBloc.storage.write('password', event.password);

    emit(Authenticated());
  }

  _loggedOut(event, emit) async {
    HydratedBloc.storage.delete('token');
    HydratedBloc.storage.delete('acctno');
    //HydratedBloc.storage.delete('custodycd');
    emit(Unauthenticated());
  }
}
