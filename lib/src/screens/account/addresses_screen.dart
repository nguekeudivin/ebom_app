import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/components/form/input_text_area.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/address.dart';
import 'package:flutter/material.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Address> addresses = [
    Address(
      place: 'Maison',
      label: 'Douala-Logpom',
      description: 'Derriere le marche de logpom',
    ),
  ];

  int? currentIndex;

  TextEditingController placeCtl = TextEditingController();
  TextEditingController labelCtl = TextEditingController();
  TextEditingController descriptionCtl = TextEditingController();

  void showAddressModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 400,
            width: 300,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputText(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    controller: placeCtl,
                    label: 'Entrer la position',
                    placeholder: 'Lieu de travail',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputText(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    controller: labelCtl,
                    label: "Entrer l'addresse",
                    placeholder: 'Douala - Makepe BM',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputTextArea(
                    controller: descriptionCtl,
                    label: 'Description precise',
                    placeholder:
                        'A la fin des Pave du cote du depot de boisson',
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 16,
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
                        addresses.add(
                          Address(
                            place: placeCtl.text,
                            label: labelCtl.text,
                            description: descriptionCtl.text,
                          ),
                        );
                      } else {
                        addresses[currentIndex as int] = Address(
                          place: placeCtl.text,
                          label: labelCtl.text,
                          description: descriptionCtl.text,
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
          'Addresses',
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
              children: List.generate(addresses.length, (index) {
                Address address = addresses[index];

                return AddressItem(
                  address: address,
                  onDelete: (context) {
                    setState(() {
                      addresses.removeAt(index);
                    });
                  },
                  startEdit: () {
                    currentIndex = index;
                    setState(() {
                      placeCtl = TextEditingController(text: address.place);
                      labelCtl = TextEditingController(text: address.label);
                      descriptionCtl =
                          TextEditingController(text: address.description);
                    });
                    showAddressModal(context);
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
            showAddressModal(context);
          },
        ),
      ),
    );
  }
}

class AddressItem extends StatefulWidget {
  final Address address;
  final void Function(BuildContext) onDelete;
  final void Function() startEdit;

  const AddressItem({
    required this.address,
    required this.onDelete,
    required this.startEdit,
    super.key,
  });

  @override
  State<AddressItem> createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
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
              const Icon(
                Icons.pin_drop,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.address.place),
                  Text(
                    widget.address.label,
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
                          'Confirmer la suppression de cet address',
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
