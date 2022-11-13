import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jd_shop/model/product_model.dart';
import 'package:jd_shop/model/user_model.dart';
import 'package:jd_shop/services/auth_service.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/services/storage_service.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:jd_shop/utils/showSnackBar.dart';
import 'package:jd_shop/widgets/input_decoration.dart';
import 'package:jd_shop/widgets/main_btn_widget.dart';
import 'package:provider/provider.dart';

import '../model/transaction_model.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  User? user;
  File? imageFile;
  String? imageUrl;
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    Product? newProduct = product;

    final authService = Provider.of<AuthService>(context, listen: false);
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    authService.currentUser().then((currentUser) {
      if (!mounted) return;
      setState(() {
        user = currentUser;
      });
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/icons/back.svg",
            color: kColorsWhite,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Edit Product Info",
          style: Theme.of(context).textTheme.headline3,
        ),
        backgroundColor: kColorsPurple,
        //สร้างเส้นคั่น
        shape: Border(
            bottom: BorderSide(
          color: kColorsCream,
          width: 4,
        )),
        //shadow
        elevation: 0,
        //ความสูง appbar ด้านบน
        toolbarHeight: 60,

        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/edit.svg",
                color: kColorsWhite,
              )),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/msg.svg",
                color: kColorsWhite,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/profile-screen");
              },
              icon: SvgPicture.asset(
                "assets/icons/me.svg",
                color: kColorsWhite,
              )),
        ],
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: InkWell(
                onTap: () {
                  showBottomSheet(context);
                  imageSave();
                  newProduct.photoURL = imageUrl;
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    height: 600,
                    decoration: BoxDecoration(
                      color: kColorsCream,
                    ),
                    child: Center(
                        child: '${product.photoURL}' != ""
                            ? Image.network('${product.photoURL}',
                                width: 153, height: 153, fit: BoxFit.cover)
                            : Container(
                                decoration: BoxDecoration(color: kColorsRed))),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${product.type!.name.toString()}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kColorsGrey),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        style: Theme.of(context).textTheme.subtitle1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter product name";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          newProduct.name = value;
                        },
                        decoration:
                            InputDecoration(hintText: "${product.name}")),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: false,
                        style: Theme.of(context).textTheme.subtitle1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter product price";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          newProduct.price = double.parse(value);
                        },
                        decoration:
                            InputDecorationWidget(context, "${product.price}")),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: false,
                        style: Theme.of(context).textTheme.subtitle1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter product quantity";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          newProduct.quantity = int.parse(value);
                        },
                        decoration: InputDecorationWidget(
                            context, "${product.quantity}")),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        style: Theme.of(context).textTheme.subtitle1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter product description";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          newProduct.description = value;
                        },
                        decoration: InputDecorationWidget(
                            context, "${product.description}")),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text('Update this product info.'),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                databaseService
                                    .updateProductFromUid(
                                        uid: product.uid,
                                        newProduct: newProduct)
                                    .then((value) {
                                  //success state
                                  showSnackBar('success',
                                      backgroundColor: Colors.green);
                                }).catchError((e) {
                                  //handle error
                                  showSnackBar(e, backgroundColor: Colors.red);
                                });
                                Navigator.pop(context, 'Ok');
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: MainBtnWidget(
                        colorBtn: Colors.green,
                        textBtn: 'Save',
                        isTransparent: false,
                        haveIcon: false),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    openGallery(context);
                  },
                  leading: SvgPicture.asset('assets/icons/gallery.svg',
                      color: kColorsPurple),
                  title: Text('Gallery',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                ListTile(
                  onTap: () {
                    openCamera(context);
                  },
                  leading: SvgPicture.asset('assets/icons/gallery.svg',
                      color: kColorsPurple),
                  title: Text('Camera',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
              ],
            ),
          );
        });
  }

  openGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });
    Navigator.of(context).pop();
  }

  openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });
    Navigator.of(context).pop();
  }

  imageSave() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    if (imageFile != null) {
      imageUrl = await storageService.uploadProductImage(imageFile: imageFile!);
    }
  }
}
