import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/input_select.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/payment_method.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> paymentMethods = [];

  int? currentIndex;

  String provider = 'ORANGE_MONEY';
  final List<SelectOption> _providerOptions = [
    SelectOption(label: 'Orange Money', value: 'ORANGE_MONEY'),
    SelectOption(label: 'MTN Mobile Money', value: 'MTN_MOMO'),
  ];

  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneNumberCtl = TextEditingController();

  void showPaymentMethodModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 350,
            width: 300,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  InputSelect(
                    value: provider,
                    onChanged: (value) {
                      setState(() {
                        provider = value;
                      });
                    },
                    label: 'Chosir le mode',
                    options: _providerOptions,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputText(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    controller: nameCtl,
                    label: 'Entrer le nom associe',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputText(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    controller: phoneNumberCtl,
                    label: 'Numero de telephone associe',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(
                  text: currentIndex == null ? 'Ajouter' : 'Enregistrer',
                  onPressed: (context) {
                    setState(() {
                      if (currentIndex == null) {
                        paymentMethods.add(
                          PaymentMethod(
                            provider: provider,
                            phoneNumber: phoneNumberCtl.text,
                            name: nameCtl.text,
                          ),
                        );
                      } else {
                        paymentMethods[currentIndex as int] = PaymentMethod(
                          provider: provider,
                          phoneNumber: phoneNumberCtl.text,
                          name: nameCtl.text,
                        );
                      }
                    });

                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Methodes de paiements',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Column(
              children: List.generate(paymentMethods.length, (index) {
                PaymentMethod method = paymentMethods[index];

                return PaymentMethodItem(
                  method: method,
                  onDelete: (context) {
                    setState(() {
                      paymentMethods.removeAt(index);
                    });
                  },
                  startEdit: () {
                    currentIndex = index;
                    setState(() {
                      provider = method.provider;
                      nameCtl = TextEditingController(text: method.name);
                      phoneNumberCtl =
                          TextEditingController(text: method.phoneNumber);
                    });
                    showPaymentMethodModal(context);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: 'Ajouter ',
          onPressed: (context) {
            showPaymentMethodModal(context);
          },
        ),
      ),
    );
  }
}

class PaymentMethodItem extends StatefulWidget {
  final PaymentMethod method;
  final void Function(BuildContext) onDelete;
  final void Function() startEdit;

  const PaymentMethodItem({
    required this.method,
    required this.onDelete,
    required this.startEdit,
    super.key,
  });

  @override
  State<PaymentMethodItem> createState() => _PaymentMethodItemState();
}

class _PaymentMethodItemState extends State<PaymentMethodItem> {
  List<String> providers = ['ORANGE_MONEY', 'MTN_MOMO'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Builder(
                  builder: (context) {
                    if (providers.contains(widget.method.provider)) {
                      return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          widget.method.provider == 'ORANGE_MONEY'
                              ? AppAssets.orangeMoney
                              : AppAssets.mtnMomo,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Container(
                        color: AppColors.primary,
                        width: 50,
                        height: 50,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.method.name,
                  ),
                  Text(
                    widget.method.phoneNumber,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text(
                          'Confirmer la suppression de ce mode de paiement',
                        ),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                child: const Text(
                                  'Supprimer',
                                  style: TextStyle(color: AppColors.red),
                                ),
                                onPressed: () {
                                  widget.onDelete(context);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Annuler'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete, color: AppColors.red),
              ),
              const SizedBox(
                width: 4,
              ),
              IconButton(
                onPressed: widget.startEdit,
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
