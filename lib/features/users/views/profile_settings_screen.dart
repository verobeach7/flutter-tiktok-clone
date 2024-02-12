import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/form_button.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  final String name;
  const ProfileSettingsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _biographyController;
  late final TextEditingController _homepageController;

  late final bool hasBio;
  late final bool hasHomepage;

  @override
  void initState() {
    super.initState();

    final userProfile = ref.read(usersProvider).value;
    if (userProfile!.bio == "undefined") {
      hasBio = false;
    } else {
      hasBio = true;
    }
    if (userProfile.link == "undefined") {
      hasHomepage = false;
    } else {
      hasHomepage = true;
    }

    _nameController = TextEditingController(
      text: userProfile.name,
    );
    _biographyController = TextEditingController(
      text: hasBio ? userProfile.bio : null,
    );
    _homepageController = TextEditingController(
      text: hasHomepage ? userProfile.link : null,
    );
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onNameClearTap() {
    _nameController.clear();
  }

  void _onBiographyClearTap() {
    _biographyController.clear();
  }

  void _onHomepageClearTap() {
    _homepageController.clear();
  }

  void _onSubmitTap() {
    ref.read(usersProvider.notifier).updateProfile(
          _nameController.value.text,
          _biographyController.value.text,
          _homepageController.value.text,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => GestureDetector(
            onTap: _onScaffoldTap,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Profile Settings"),
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                  top: Sizes.size20,
                  left: Sizes.size36,
                  right: Sizes.size36,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Write your name.",
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: _onNameClearTap,
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
                      ),
                      Gaps.v32,
                      Text(
                        "Biography",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      TextFormField(
                        controller: _biographyController,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "Write your biography.",
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: _onBiographyClearTap,
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
                      ),
                      Gaps.v32,
                      Text(
                        "Homepage",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      TextFormField(
                        controller: _homepageController,
                        minLines: 1,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: "Write your homepage.",
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: _onHomepageClearTap,
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: Colors.grey.shade500,
                                  size: Sizes.size20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gaps.v40,
                      GestureDetector(
                        onTap: _onSubmitTap,
                        child: const FormButton(
                          disabled: false,
                          text: "Submit",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
