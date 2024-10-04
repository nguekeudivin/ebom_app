import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:ebom/src/manager/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 4) {
      FocusScope.of(context).nextFocus(); // Move to next input
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus(); // Move to previous input
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verify the otp.
    void verifyOTP(BuildContext context, String otp) {
      AuthService auth = AuthService();

      auth.verifyOTP(otp).then((message) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppLayout(),
          ),
        );
      }).catchError((errorMessage) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppLayout(),
          ),
        );
        //Handle Error this here.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Code de verification',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 48),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Veuillez entrer le code à 06 chiffres envoyé sur le numéro  650 *** **7',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.borderGray,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => _onChanged(value, index),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: PrimaryButton(
                    text: 'Verifier',
                    onPressed: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppLayout(),
                        ),
                      );
                      // Handle OTP verification logic here
                      // String otp = _controllers
                      //     .map((controller) => controller.text)
                      //     .join();

                      // if (otp.length == 5) {
                      //   verifyOTP(context, otp);
                      // } else {
                      //   // Show error message
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text('Veuillez entre code valide'),
                      //     ),
                      //   );
                      // }
                    },
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "Vous n'avez pas recu le code ?",
                ),
                TextButton(
                  onPressed: () {
                    // Resend the code.
                  },
                  child: const Text(
                    'Renvoyez-Code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue, // Underline color
                      decorationThickness: 2.0, // Underline thickness
                    ),
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
