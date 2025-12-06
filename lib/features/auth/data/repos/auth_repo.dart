import 'package:dartz/dartz.dart';
import 'package:shift7_app/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failures, dynamic>> login({
    String? email,
    String? phone,
    required String password,
  });

  Future<Either<Failures, dynamic>> register({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String otpType,
  });

  Future<Either<Failures, dynamic>> verifyEmail({
    String? email,
    String? phone,
    required String otp,
  });

  Future<Either<Failures, dynamic>> sentOtp({
    String? email,
    String? phone,
    required String type,
  });

  Future<Either<Failures, dynamic>> verifyCodeOfForgetPassword({
    String? email,
    String? phone,
    required String otp,
  });

  Future<Either<Failures, dynamic>> changePassword({
    String? phone,
    String? email,
    required String confirmPassword,
    required String password,
  });

  Future<Either<Failures, dynamic>> googleAuth();
}
