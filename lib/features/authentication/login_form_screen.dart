import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/login_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({super.key});

  @override
  ConsumerState<LoginFormScreen> createState() => LoginFormScreenState();
}

class LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {}; // formData를 저장하기 위한 Map
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _obscureText = true;

  void _onSubmitTap() {
    // // 방법 1. currentSate가 없을 수도 있으므로 validate 막 사용할 수 없음. 조건문을 이용하여 해결
    // if (_formKey.currentState != null) {
    //   _formKey.currentState!.validate();
    // }
    // // 방법 2. 다음 한 줄로 textFormField의 validator를 실행함.
    // _formKey.currentState
    //     ?.validate(); // currentState가 있으면 validate를 호출하고 없으면 아무것도 하지 않음. 다트 문법을 사용하여 해결
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!
            .save(); // save를 호출하면 모든 텍스트 입력에 onSaved 콜백 함수를 실행함.
        ref.read(loginProvider.notifier).login(
              formData["email"]!,
              formData["password"]!,
              context,
            );
        // context.goNamed(InterestsScreen.routeName);
      }
    }
  }

  // 입력칸 밖을 탭하면 소프트웨어 키보드가 사라지게 함.
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onEmailClearTap() {
    _emailController.clear();
  }

  void _onPasswordClearTap() {
    _passwordController.clear();
  }

  void _toggleObscureText() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 키보드를 사라지게 하기 위해서 외부 영역을 탭하는 것을 감지해야함.
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log in'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size36,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gaps.v28,
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _onEmailClearTap,
                          child: FaIcon(
                            FontAwesomeIcons.solidCircleXmark,
                            color: Colors.grey.shade500,
                            size: Sizes.size20,
                          ),
                        ),
                        Gaps.h4,
                      ],
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an email.";
                    }
                    final regExp = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                    if (!regExp.hasMatch(value)) {
                      return "The email format is incorrect.";
                    }
                    return null;
                  },
                  // newValue: 저장 된 시점의 값을 저장
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['email'] = newValue;
                    }
                  },
                ),
                Gaps.v16,
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  autocorrect: false,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _toggleObscureText,
                            child: FaIcon(
                              _obscureText
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h16,
                          GestureDetector(
                            onTap: _onPasswordClearTap,
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h4,
                        ],
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the password.";
                    }
                    final regExp = RegExp(
                      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$',
                    );
                    if (!regExp.hasMatch(value)) {
                      return "The password is incorrect.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['password'] = newValue;
                    }
                  }, // newValue: 저장 된 시점의 값을 저장
                ),
                Gaps.v28,
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: FormButton(
                    disabled: ref.watch(loginProvider).isLoading,
                    text: 'Log in',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
