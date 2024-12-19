//✅ translated
import 'package:catchmflixx/constants/images.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';

import 'package:catchmflixx/state/provider.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/CFXModal/custom_modal.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmail extends ConsumerWidget {
  final String emailId;
  final String password;
  const VerifyEmail({
    super.key,
    required this.emailId,
    required this.password,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translation = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SvgPicture.asset(
                CatchMFlixxImages.verify,
                fit: BoxFit.cover,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      translation.ver,
                      style: size.height > 840
                          ? TextStyles.headingMobile
                          : TextStyles.headingMobileSmallScreens,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      translation.sentEmVer,
                      style: TextStyles.smallSubText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OffsetFullButton(
                          icon: Icons.verified,
                          content: translation.iVerified,
                          fn: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            int res = await ref
                                .read(userLoginProvider.notifier)
                                .makeLogin(emailId, password, context, true);
                            if (res == 200) {
                              await prefs.remove("temp_login_mail");
                              await prefs.remove("temp_login_password");
                              navigateToPage(context, "/check-login",
                                  isReplacement: true);
                            } else {
                              ToastShow.returnToast(translation.notverified);
                              navigateToPage(context, "/custom-modal",
                                  data: CustomModal(
                                    detailedMessage:
                                        "We found out that you haven't verified your email address, to watch content you need to verify your account please verify the link sent to your mail (check your spam folder as well). You can still go ahead and check out content and verify later",
                                    mainMessage: "Are you sure?",
                                    primary: "I have verified, retry again",
                                    secondary: "Cancel",
                                    primaryFunction: () {
                                      // navigateToPage(
                                      //     context, const LaterVerifyScreen());
                                      Navigator.pop(context);
                                    },
                                    secondaryFunction: () {
                                      Navigator.pop(context);
                                    },
                                  ));
                            }
                          }),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10),
                    //   child: OffsetFullButton(
                    //       icon: Icons.confirmation_number,
                    //       content: translation.continueToApp,
                    //       fn: () {
                    //         ToastShow.returnToast(translation.remToVerify);
                    //         navigateToPage(context, const BaseMain());
                    //       }),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
