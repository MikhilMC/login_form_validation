import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);

    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  // @override
  // void onChange(Change<AuthState> change) {
  //   super.onChange(change);
  //   print("AuthBloc - Change - $change");
  // }

  // @override
  // void onTransition(Transition<AuthEvent, AuthState> transition) {
  //   super.onTransition(transition);
  //   print("AuthBloc - Transition - $transition");
  // }

  void _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final email = event.email;
      final password = event.password;

      if (password.length < 6) {
        return emit(
          AuthFailure("Password can not be less than 6 characters"),
        );
      }

      RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        caseSensitive: false,
      );
      if (!emailRegex.hasMatch(email)) {
        return emit(
          AuthFailure("Invalid email format"),
        );
      }

      await Future.delayed(const Duration(seconds: 1), () {
        return emit(
          AuthSuccess(uid: "$email-$password"),
        );
      });
    } catch (e) {
      return emit(
        AuthFailure(e.toString()),
      );
    }
  }

  void _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          return emit(
            AuthInitial(),
          );
        },
      );
    } catch (e) {
      return emit(
        AuthFailure(e.toString()),
      );
    }
  }
}
