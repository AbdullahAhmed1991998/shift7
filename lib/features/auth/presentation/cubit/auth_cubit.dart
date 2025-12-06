import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/auth/data/repos/auth_repo.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit({required this.authRepo}) : super(AuthState.initial());

  Future<void> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    emit(
      state.copyWith(
        loginStatus: ApiStatus.loading,
        errorMessage: null,
        requiresOtp: false,
        otpUserId: null,
      ),
    );
    final result = await authRepo.login(
      email: email,
      phone: phone,
      password: password,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loginStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
            requiresOtp: false,
            otpUserId: null,
          ),
        );
      },
      (response) {
        final data = (response is Map) ? response['data'] : null;
        final requires = (data is Map) ? (data['requires_otp'] == true) : false;
        final uid =
            (data is Map)
                ? (data['user_id'] is int ? data['user_id'] as int : null)
                : null;
        emit(
          state.copyWith(
            loginStatus: ApiStatus.success,
            errorMessage: null,
            requiresOtp: requires,
            otpUserId: uid,
          ),
        );
      },
    );
  }

  Future<void> register({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String otpType,
  }) async {
    emit(
      state.copyWith(
        registerStatus: ApiStatus.loading,
        errorMessage: null,
        requiresOtp: false,
        otpUserId: null,
      ),
    );
    final result = await authRepo.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      otpType: otpType,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            registerStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
            requiresOtp: false,
            otpUserId: null,
          ),
        );
      },
      (response) {
        final data = (response is Map) ? response['data'] : null;
        final requires = (data is Map) ? (data['requires_otp'] == true) : false;
        final uid =
            (data is Map)
                ? (data['user_id'] is int ? data['user_id'] as int : null)
                : null;
        emit(
          state.copyWith(
            registerStatus: ApiStatus.success,
            errorMessage: null,
            requiresOtp: requires,
            otpUserId: uid,
          ),
        );
      },
    );
  }

  Future<void> verifyEmail({
    String? email,
    String? phone,
    required String otp,
  }) async {
    emit(state.copyWith(verifyStatus: ApiStatus.loading, errorMessage: null));
    final result = await authRepo.verifyEmail(
      email: email,
      otp: otp,
      phone: phone,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            verifyStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (response) async {
        await getIt<CacheHelper>().setData(
          key: CacheHelperKeys.isLogin,
          value: true,
        );
        emit(
          state.copyWith(
            verifyStatus: ApiStatus.success,
            errorMessage: null,
            requiresOtp: false,
            otpUserId: null,
          ),
        );
      },
    );
  }

  Future<void> sendOtp({
    String? email,
    String? phone,
    required String type,
  }) async {
    emit(state.copyWith(resendStatus: ApiStatus.loading, errorMessage: null));
    final result = await authRepo.sentOtp(
      email: email,
      phone: phone,
      type: type,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            resendStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(resendStatus: ApiStatus.success, errorMessage: null),
        );
      },
    );
  }

  Future<void> verifyCodeOfForgetPassword({
    String? email,
    String? phone,
    required String otp,
  }) async {
    emit(state.copyWith(verifyStatus: ApiStatus.loading, errorMessage: null));
    final result = await authRepo.verifyCodeOfForgetPassword(
      email: email,
      phone: phone,
      otp: otp,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            verifyStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(verifyStatus: ApiStatus.success, errorMessage: null),
        );
      },
    );
  }

  Future<void> changePassword({
    String? phone,
    String? email,
    required String confirmPassword,
    required String password,
  }) async {
    emit(
      state.copyWith(
        changePasswordStatus: ApiStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await authRepo.changePassword(
      phone: phone,
      email: email,
      confirmPassword: confirmPassword,
      password: password,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            changePasswordStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            changePasswordStatus: ApiStatus.success,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> googleAuth() async {
    emit(
      state.copyWith(
        googleStatus: ApiStatus.loading,
        errorMessage: null,
        requiresOtp: false,
        otpUserId: null,
      ),
    );
    final result = await authRepo.googleAuth();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            googleStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            googleStatus: ApiStatus.success,
            errorMessage: null,
            requiresOtp: false,
            otpUserId: null,
          ),
        );
      },
    );
  }
}
