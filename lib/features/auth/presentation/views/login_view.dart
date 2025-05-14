import 'package:autism_empowering/View/Child%20Info/patient_screen.dart';
import 'package:autism_empowering/View/Doctors/doctor_screen.dart';
import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:autism_empowering/core/exceptions/user_verified_exception.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/error_handler/auth_error_handler.dart';
import 'package:autism_empowering/core/utils/show_message.dart';
import 'package:autism_empowering/features/auth/presentation/manager/auth_cubit.dart';
import 'package:autism_empowering/features/auth/presentation/widgets/login_view_body.dart';
import 'package:autism_empowering/generated/app_localizations.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = '/LoginScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Success<UserType>) {
            if (state.data == UserType.doctor) {
              context.goNamed(DoctorScreen.routeName);
            } else {
              context.goNamed(PatientScreen.routeName);
            }
            ShowMessage.show(msg: AppLocalizations.of(context)!.success);
          }
          if (state is Error<FirebaseAuthException>) {
            final message =
                AuthErrorHandler.getErrorMessage(errorMessage: state.message);
            ShowMessage.show(msg: message);
          }
          if (state is Error<UserVerifiedException>) {
            ShowMessage.show(msg: state.message);
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return BlurryModalProgressHUD(
              inAsyncCall: false,
              progressIndicator: SpinKitCircle(
                color: AppColors.primaryColor,
                size: 30,
              ),
              child: Container(),
            );
          }
          return LofinViewBody();
        },
      ),
    );
  }
}
