part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final ApiStatus loginStatus;
  final ApiStatus registerStatus;
  final ApiStatus verifyStatus;
  final ApiStatus resendStatus;
  final ApiStatus changePasswordStatus;
  final ApiStatus googleStatus;
  final String? errorMessage;
  final bool requiresOtp;
  final int? otpUserId;

  const AuthState({
    required this.loginStatus,
    required this.registerStatus,
    required this.verifyStatus,
    required this.resendStatus,
    required this.changePasswordStatus,
    required this.googleStatus,
    this.errorMessage,
    this.requiresOtp = false,
    this.otpUserId,
  });

  factory AuthState.initial() => const AuthState(
    loginStatus: ApiStatus.initial,
    registerStatus: ApiStatus.initial,
    verifyStatus: ApiStatus.initial,
    resendStatus: ApiStatus.initial,
    changePasswordStatus: ApiStatus.initial,
    googleStatus: ApiStatus.initial,
    errorMessage: null,
    requiresOtp: false,
    otpUserId: null,
  );

  AuthState copyWith({
    ApiStatus? loginStatus,
    ApiStatus? registerStatus,
    ApiStatus? verifyStatus,
    ApiStatus? resendStatus,
    ApiStatus? changePasswordStatus,
    ApiStatus? googleStatus,
    String? errorMessage,
    bool? requiresOtp,
    int? otpUserId,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      registerStatus: registerStatus ?? this.registerStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      resendStatus: resendStatus ?? this.resendStatus,
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      googleStatus: googleStatus ?? this.googleStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      requiresOtp: requiresOtp ?? this.requiresOtp,
      otpUserId: otpUserId ?? this.otpUserId,
    );
  }

  @override
  List<Object?> get props => [
    loginStatus,
    registerStatus,
    verifyStatus,
    resendStatus,
    changePasswordStatus,
    googleStatus,
    errorMessage,
    requiresOtp,
    otpUserId,
  ];
}
