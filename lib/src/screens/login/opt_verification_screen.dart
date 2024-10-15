import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/app_layout.dart';
import 'package:ebom/src/services/auth_service.dart';
import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  final RegisterData data;
  final String mode;
  const OtpVerificationScreen({
    required this.data,
    required this.mode,
    super.key,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).nextFocus(); // Move to next input
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus(); // Move to previous input
    }
  }

  void verifyOTP(BuildContext context, String otp) {
    AuthService auth = AuthService();

    setState(() {
      _isLoading = true;
    });
    auth.verifyOTP(otp, widget.data, widget.mode).then((message) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => AppLayout(),
        ),
      );
    }).catchError((response) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: const Text('Erreur'),
            content: Container(
              //color: Colors.red,
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                response.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verify the otp.

    String phoneNumberStart = widget.data.telephone.substring(0, 3);
    String phoneNumberEnd = widget.data.telephone.substring(
      widget.data.telephone.length - 2,
      widget.data.telephone.length,
    );

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Veuillez entrer le code à 6 chiffres envoyé sur le numéro  $phoneNumberStart****$phoneNumberEnd',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
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
                        isLoading: _isLoading,
                        onPressed: (context) {
                          verifyOTP(
                            context,
                            _controllers
                                .map((controller) => controller.text)
                                .join(),
                          );
                          // Handle OTP verification logic here

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
        ),
      ),
    );
  }
}
