import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/edit_profile_validators.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/core/utils/widgets/not_logged_in_widget.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_edit_profile_actions_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_edit_profile_form_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _editMode = false;
  bool _autoValidate = false;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  String? _serverEmail;
  String? _serverPhone;
  String? _completePhone = '';
  String? _dialCode = '';

  @override
  void initState() {
    super.initState();
    _checkTokenAndFetch();
  }

  Future<void> _checkTokenAndFetch() async {
    final token = await _secureStorage.read(key: userToken);
    _isLoggedIn = token != null && token.isNotEmpty;

    if (_isLoggedIn) {
      // ignore: use_build_context_synchronously
      await context.read<ProfileCubit>().getProfile();
      // ignore: use_build_context_synchronously
      final st = context.read<ProfileCubit>().state;
      final p = st.profile?.data;
      if (st.status == ApiStatus.success && p != null) {
        nameController.text = (p.name).trim();
        _serverEmail = p.email;
        _serverPhone = p.phone;
        emailController.text = (_serverEmail ?? '').trim();
        if ((_serverPhone ?? '').startsWith('+')) {
          phoneController.text = '';
          _completePhone = _serverPhone;
        } else {
          phoneController.text = (_serverPhone ?? '').trim();
          _completePhone = (_serverPhone ?? '').trim();
        }
      }
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    setState(() {
      _editMode = true;
      _autoValidate = false;
      passwordController.clear();
    });
  }

  void _cancelEdit() {
    FocusScope.of(context).unfocus();
    setState(() {
      _editMode = false;
      _autoValidate = false;
    });
    nameController.text =
        (nameController.text.isEmpty) ? '' : nameController.text;
    emailController.text = _serverEmail ?? '';
    if ((_serverPhone ?? '').startsWith('+')) {
      phoneController.text = '';
      _completePhone = _serverPhone;
    } else {
      phoneController.text = _serverPhone ?? '';
      _completePhone = _serverPhone ?? '';
    }
    passwordController.clear();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    setState(() => _autoValidate = true);
    if (!_formKey.currentState!.validate()) return;

    final fullPhone =
        (_completePhone ?? '').isNotEmpty
            ? _completePhone!.trim()
            : '${_dialCode ?? ''}${phoneController.text.trim()}';

    context.read<ProfileCubit>().updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      pass: passwordController.text.trim(),
      phone: fullPhone,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: CustomAppBar(
            title: 'editProfileTitle'.tr(),
            onBackPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (!_isLoggedIn) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: CustomAppBar(
            title: 'editProfileTitle'.tr(),
            onBackPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: NotLoggedInWidget(resourceName: 'profile'.tr())),
      );
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.updateProfileStatus == ApiStatus.success) {
          _serverEmail =
              emailController.text.trim().isEmpty
                  ? null
                  : emailController.text.trim();
          _serverPhone =
              ((_completePhone ?? '').trim().isEmpty)
                  ? (phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim())
                  : _completePhone!.trim();
          showToast(
            context,
            isSuccess: true,
            message: 'profileUpdateSuccess'.tr(),
            icon: Icons.check,
          );
          setState(() => _editMode = false);
          passwordController.clear();
        }

        if (state.updateProfileStatus == ApiStatus.error) {
          showToast(
            context,
            isSuccess: false,
            message: state.updateProfileErrorMessage.toString(),
            icon: Icons.error,
          );
        }

        if (state.status == ApiStatus.success && !_isLoading) {
          final p = state.profile?.data;
          if (p != null) {
            nameController.text = (p.name).trim();
            _serverEmail = p.email;
            _serverPhone = p.phone;
            emailController.text = (_serverEmail ?? '').trim();
            if ((_serverPhone ?? '').startsWith('+')) {
              phoneController.text = '';
              _completePhone = _serverPhone;
            } else {
              phoneController.text = (_serverPhone ?? '').trim();
              _completePhone = (_serverPhone ?? '').trim();
            }
            setState(() {});
          }
        }
      },
      builder: (context, state) {
        final loadingProfile = state.status == ApiStatus.loading;
        final updating = state.updateProfileStatus == ApiStatus.loading;
        final fieldsEnabled = _editMode && !updating && !loadingProfile;
        final hasEmailFromServer =
            (_serverEmail != null && _serverEmail!.trim().isNotEmpty);
        final hasPhoneFromServer =
            (_serverPhone != null && _serverPhone!.trim().isNotEmpty);

        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.h),
            child: CustomAppBar(
              title: 'editProfileTitle'.tr(),
              onBackPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child:
                loadingProfile
                    ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.secondaryColor,
                        size: 36.sp,
                      ),
                    )
                    : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode:
                            _autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            KeyedSubtree(
                              key: ValueKey(_completePhone ?? ''),
                              child: CustomEditProfileFormWidget(
                                nameController: nameController,
                                emailController: emailController,
                                phoneController: phoneController,
                                passwordController: passwordController,
                                fieldsEnabled: fieldsEnabled,
                                onDialCodeChanged: (d) => _dialCode = d,
                                onFullNumberChanged: (v) => _completePhone = v,
                                initialFullNumber: _completePhone,
                                defaultIsoCode:
                                    context.locale.countryCode ?? 'JO',
                                validators: EditProfileValidators(),
                                showEmailField:
                                    fieldsEnabled || hasEmailFromServer,
                                showPhoneField:
                                    fieldsEnabled || hasPhoneFromServer,
                              ),
                            ),
                            SizedBox(height: 80.h),
                          ],
                        ),
                      ),
                    ),
          ),
          bottomNavigationBar:
              loadingProfile
                  ? null
                  : SafeArea(
                    minimum: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                    child: SizedBox(
                      height: 50.h,
                      child:
                          updating
                              ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: AppColors.secondaryColor,
                                  size: 30.sp,
                                ),
                              )
                              : CustomEditProfileActionsWidget(
                                isEditMode: _editMode,
                                onEdit: _enterEditMode,
                                onCancel: _cancelEdit,
                                onSave: _save,
                              ),
                    ),
                  ),
        );
      },
    );
  }
}
