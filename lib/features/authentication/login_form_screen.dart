import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {}; // formData를 저장하기 위한 Map

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
        print(formData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                validator: (value) {
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
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                validator: (value) {
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
                child: const FormButton(
                  disabled: false,
                  text: 'Log in',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
