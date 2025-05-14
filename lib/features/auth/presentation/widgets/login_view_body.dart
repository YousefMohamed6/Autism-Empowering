import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/component.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:autism_empowering/features/auth/presentation/manager/auth_cubit.dart';
import 'package:autism_empowering/features/auth/presentation/views/choose_type.dart';
import 'package:autism_empowering/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LofinViewBody extends StatelessWidget {
  const LofinViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final cubit = context.read<AuthCubit>();
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
  }
}
