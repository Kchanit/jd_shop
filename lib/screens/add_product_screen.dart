import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jd_shop/model/product_model.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/services/storage_service.dart';
import 'package:jd_shop/utils/showSnackBar.dart';
import 'package:jd_shop/widgets/input_decoration.dart';
import 'package:jd_shop/widgets/main_btn_widget.dart';
import 'package:provider/provider.dart';

import '../themes/color.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  String? productCategory = 'Pen',
      productName,
      productPrice,
      productQuantity,
      productDescription;

  File? imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
          "Add Product",
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
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: formKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      showBottomSheet(context);
                    },
                    child: imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              imageFile!,
                              width: 153,
                              height: 153,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 153,
                            height: 153,
                            decoration: BoxDecoration(
                              color: kColorsRed,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                  ),
                ),
                CreateProductCategory(),
                CreateProductName(),
                CreateProductPrice(),
                CreateProductQuantity(),
                CreateProductDescription(),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              onTap: () {
                confirmHandle(context: context);
              },
              child: MainBtnWidget(
                  colorBtn: kColorsPurple,
                  textBtn: 'Confirm',
                  isTransparent: false,
                  haveIcon: false),
            ),
          )
        ],
      ),
    );
  }

  Widget CreateProductName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
            productName = value;
          },
          decoration: InputDecorationWidget(context, "Name")),
    );
  }

  Widget CreateProductPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
            productPrice = value;
          },
          decoration: InputDecorationWidget(context, "Price")),
    );
  }

  Widget CreateProductCategory() {
    List<String> category = [
      'Pen',
      'Book',
      'Paper',
      'Eraser',
      'Marker',
      'Folder'
    ];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: InputDecorator(
          decoration: InputDecoration(
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10),
                borderSide: BorderSide(color: kColorsGrey, width: 1),
              ),
              errorStyle: Theme.of(context).textTheme.bodyText2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                value: productCategory,
                icon: SvgPicture.asset('assets/icons/down.svg',
                    color: kColorsGrey),
                elevation: 3,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kColorsPurple),
                items: category.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    productCategory = value.toString();
                  });
                }),
          ),
        ));
  }

  Widget CreateProductQuantity() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
            productQuantity = value;
          },
          decoration: InputDecorationWidget(context, "Quantity")),
    );
  }

  Widget CreateProductDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
            productDescription = value;
          },
          decoration: InputDecorationWidget(context, "Description")),
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

  Future<void> confirmHandle({required context}) async {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    String? imageUrl;

    showDialog(
        context: context,
        builder: ((context) => Center(
              child: CircularProgressIndicator(strokeWidth: 4),
            )));

    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    if (imageFile != null) {
      imageUrl = await storageService.uploadProductImage(imageFile: imageFile!);
    }

    final newProduct = Product(
      type: Product.getProductType(productCategory!),
      name: productName!,
      price: double.parse(productPrice!),
      quantity: int.parse(productQuantity!),
      description: productDescription,
      photoURL: imageUrl,
    );
    databaseService.addProduct(product: newProduct);

    Navigator.of(context).pop();
    showSnackBar('Add product successful.', backgroundColor: Colors.green);
    Navigator.of(context).pop();
  }
  // setProductUid(){
  //   String unixTime = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  //   var name = productName!.replaceAll(' ', '');
  //   final id = '${name}${unixTime}';
  //   return id;
  // }
}
