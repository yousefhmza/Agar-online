import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:agar_online/config/routing/navigation_service.dart';
import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/modules/auth/cubits/login_cubit/login_cubit.dart';
import 'package:agar_online/modules/auth/cubits/login_cubit/login_states.dart';
import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/resources/values_manager.dart';
import 'package:agar_online/core/utils/validators.dart';
import 'package:agar_online/core/view/app_views.dart';

class ForgetPasswordSheet extends StatelessWidget {
  ForgetPasswordSheet({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: L10n.tr(context).email,
            validator: Validators.emailValidator,
            controller: emailController,
          ),
          VerticalSpace(AppSize.s16.h),
          BlocConsumer<LoginCubit, LoginStates>(
            listenWhen: (prevState, state) => state is SendPasswordFailureState || state is SendPasswordSuccessState,
            listener: (context, state) {
              if (state is SendPasswordFailureState) Alerts.showToast(state.failure.message);
              if (state is SendPasswordSuccessState) {
                NavigationService.goBack(context);
                Alerts.showToast(state.message, Toast.LENGTH_LONG);
              }
            },
            buildWhen: (prevState, state) =>
                state is SendPasswordFailureState ||
                state is SendPasswordSuccessState ||
                state is SendPasswordLoadingState,
            builder: (context, state) => state is SendPasswordLoadingState
                ? const LoadingSpinner()
                : CustomButton(
                    width: double.infinity,
                    text: L10n.tr(context).confirm,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<LoginCubit>(context).sendNewPassword(emailController.text.trim());
                      }
                    },
                  ),
          )
        ],
      ),
    );
  }
}
