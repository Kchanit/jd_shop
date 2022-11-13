import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jd_shop/model/product_model.dart';
import 'package:jd_shop/model/user_model.dart';
import 'package:jd_shop/services/auth_service.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:jd_shop/utils/showSnackBar.dart';
import 'package:jd_shop/widgets/main_btn_widget.dart';
import 'package:provider/provider.dart';

import '../model/transaction_model.dart';

class ProductInfoScreen extends StatefulWidget {
  const ProductInfoScreen({super.key});

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  User? user;
  bool _addBtnVisible = true;
  String? transactionCategory = 'buy';
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final authService = Provider.of<AuthService>(context, listen: false);
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    authService.currentUser().then((currentUser) {
      if (!mounted) return;
      setState(() {
        user = currentUser;
      });
    });
    if (user!.role == 'user') {
      _addBtnVisible = false;
    }
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
          "Product Info",
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
          Visibility(
            visible: _addBtnVisible,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/edit-product",
                      arguments: product);
                },
                icon: SvgPicture.asset(
                  "assets/icons/edit.svg",
                  color: kColorsWhite,
                )),
          ),
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
          Padding(
            padding: EdgeInsets.all(25),
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
                Text(
                  '${product.name}',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: kColorsPurple,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Price: ${product.price} coins',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kColorsRed),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Amount: ${product.quantity}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kColorsPurple),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Description: ${product.description}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kColorsPurple),
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Buy'),
                        content:
                            Text('Buy this item for ${product.price} coins.'),
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
                              user!.coin =
                                  user!.coin! - product.price.toDouble();
                              product.quantity = product.quantity - 1;

                              final databaseService =
                                  Provider.of<DatabaseService>(context,
                                      listen: false);
                              String datetime = DateTime.now().toString();

                              String name = user!.username.replaceAll(" ", "");
                              final newTransaction = Transaction(
                                buyerUid: user!.uid,
                                price: product.price,
                                type: Transaction.getTransactionType(
                                    transactionCategory!),
                                productUid: product.uid,
                                time: datetime,
                              );
                              databaseService.addTransaction(
                                  transaction: newTransaction);

                              databaseService
                                  .updateUserFromUid(
                                      uid: user!.uid, user: user!)
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
                      textBtn: 'Buy',
                      isTransparent: false,
                      haveIcon: false),
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
                        content: Text('Delete ${product.name} from shop.'),
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
                                  .deleteProduct(product: product)
                                  .then((value) {
                                //success state
                                showSnackBar('Delete product successful',
                                    backgroundColor: Colors.green);
                              }).catchError((e) {
                                //handle error
                                showSnackBar(e, backgroundColor: Colors.red);
                              });
                              Navigator.pop(context, 'Ok');
                              Navigator.pushNamed(context, '/home');
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: MainBtnWidget(
                      colorBtn: Colors.red,
                      textBtn: 'Delete',
                      isTransparent: false,
                      haveIcon: false),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
