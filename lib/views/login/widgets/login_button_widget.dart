part of '../login_screen.dart';

class LoginButtonWidget extends StatelessWidget {
  final formKey;
  const LoginButtonWidget({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      buildWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          SnackbarUtil.showSnckBar(
            context,
            "Wellcome ${state.userModel!.name} ❤❤",
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.homeScreen,
            (route) => false,
          );
        } else if (state.status == LoginStatus.failure) {
          SnackbarUtil.showSnckBar(context, state.message.toString());
        }
      },
      builder: (context, state) {
        return AppButton(
          text: AppLocalizations.of(context)!.loginTxt,
          isLoading: state.status == LoginStatus.loading,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginButtonPressed());
            }
          },
        );
      },
    );
  }
}
