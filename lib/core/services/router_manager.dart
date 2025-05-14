import 'package:autism_empowering/View/Child%20Info/patient_screen.dart';
import 'package:autism_empowering/View/Doctors/doctor_screen.dart';
import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:autism_empowering/core/services/sf_service.dart';
import 'package:autism_empowering/core/utils/constants/sf_keys.dart';
import 'package:autism_empowering/features/auth/di/auth_service.dart';
import 'package:autism_empowering/features/auth/domain/repos/i_auth_repo.dart';
import 'package:autism_empowering/features/auth/presentation/manager/auth_cubit.dart';
import 'package:autism_empowering/features/auth/presentation/views/choose_type.dart';
import 'package:autism_empowering/features/auth/presentation/views/login_view.dart';
import 'package:autism_empowering/features/auth/presentation/views/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

sealed class RouterManager {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static GoRouter routeConfig = GoRouter(
    redirect: (context, state) async {
      if (state.fullPath?.isNotEmpty ?? false) return state.fullPath;
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        switch (await _userRole) {
          case UserType.doctor:
            return DoctorScreen.routeName;
          case UserType.parent:
            return PatientScreen.routeName;
        }
      } else {
        return LoginView.routeName;
      }
    },
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: LoginView.routeName,
        name: LoginView.routeName,
        builder: (context, state) {
          AuthService().initDi();
          return RepositoryProvider(
            create: (context) => GetIt.instance<IAuthRepo>(),
            child: BlocProvider(
              create: (context) => GetIt.instance<AuthCubit>(),
              child: const LoginView(),
            ),
          );
        },
      ),
      GoRoute(
        path: ChooseTypeScreen.routeName,
        name: ChooseTypeScreen.routeName,
        builder: (context, state) {
          return const ChooseTypeScreen();
        },
      ),
      GoRoute(
        path: SignUpView.routeName,
        name: SignUpView.routeName,
        builder: (context, state) {
          AuthService().initDi();
          return RepositoryProvider(
            create: (context) => GetIt.instance<IAuthRepo>(),
            child: BlocProvider(
              create: (context) => GetIt.instance<AuthCubit>()
                ..userRole = state.extra as UserType,
              child: const SignUpView(),
            ),
          );
        },
      ),
      GoRoute(
        path: PatientScreen.routeName,
        name: PatientScreen.routeName,
        builder: (context, state) => const PatientScreen(),
      ),
      GoRoute(
        path: DoctorScreen.routeName,
        name: DoctorScreen.routeName,
        builder: (context, state) => const DoctorScreen(),
      ),
    ],
  );
  static Future<UserType> get _userRole async {
    final String userRole =
        await SharedPreferencesService.getString(SfKeys.userRole) ?? '';
    switch (userRole) {
      case 'doctor':
        return UserType.doctor;
      default:
        return UserType.parent;
    }
  }
}
