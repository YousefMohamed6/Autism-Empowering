import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/View/Child%20Info/patient_screen.dart';
import 'package:autism_empowering/View/Doctors/doctor_screen.dart';
import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/component.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:autism_empowering/features/auth/presentation/manager/auth_cubit.dart';
import 'package:autism_empowering/features/auth/presentation/views/choose_type.dart';
import 'package:autism_empowering/generated/app_localizations.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = '/LoginScreen';

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final cubit = context.read<AuthCubit>();
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Success<UserType>) {
            if (state.data == UserType.doctor) {
              context.goNamed(DoctorScreen.routeName);
            } else {
              context.goNamed(PatientScreen.routeName);
            }
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return BlurryModalProgressHUD(
              inAsyncCall: false,
              progressIndicator:
                  SpinKitCircle(color: AppColors.primaryColor, size: 30),
              child: Container(),
            );
          }
          return Form(
            key: cubit.formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                FadeInUp(
                  child: Image.asset(
                    AppImages.logo,
                    height: 200.h,
                    width: 200.w,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: text(
                    appLocalization.welcome,
                    fontSize: 25.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                FadeInLeft(
                  child: CustomTextField(
                    hint: appLocalization.email,
                    controller: cubit.emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    image: AppImages.account,
                  ),
                ),
                const SizedBox(height: 16),
                FadeInRight(
                  child: CustomTextField(
                    hint: appLocalization.password,
                    controller: cubit.passwordTextController,
                    keyboardType: TextInputType.visiblePassword,
                    image: AppImages.email,
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 32),
                FadeInLeft(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.w),
                    child: CustomButton(
                      title: appLocalization.login,
                      onTap: cubit.login,
                      color: AppColors.primaryColor.withOpacity(0.8),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(ChooseTypeScreen.routeName);
                    },
                    child: text(appLocalization.have_an_account,
                        color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
