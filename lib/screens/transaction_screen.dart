import 'package:jd_shop/model/transaction_model.dart';
import 'package:jd_shop/services/auth_service.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  User? user;

  List<Transaction?>? item = [];

  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.currentUser().then((currentUser) {
      if (!mounted) return;
      setState(() {
        user = currentUser;
      });
    });
    return Scaffold(
      backgroundColor: kColorsCream,
      appBar: AppBar(
        title:
            Text('Transaction', style: Theme.of(context).textTheme.headline3),
        backgroundColor: kColorsPurple,
        elevation: 0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back.svg', color: kColorsWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/msg.svg',
                  color: kColorsWhite)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile-screen');
              },
              icon:
                  SvgPicture.asset('assets/icons/me.svg', color: kColorsWhite))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
                color: kColorsPurple),
          ),
          Positioned(
            top: 50,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: kColorsWhite,
                        boxShadow: [
                          BoxShadow(
                            color: kColorsBlack.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latest Transactions',
                          style: Theme.of(context).textTheme.headline4),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: kColorsCream),
                        ),
                      ),
                      StreamBuilder<List<Transaction?>>(
                        stream: databaseService.getStreamListTransaction(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Column(
                              children: [
                                Text('An error occure.'),
                                Text('${snapshot.error}')
                              ],
                            ));
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text('No Transaction'),
                            );
                          } else {
                            int i = 0;
                            while (i < snapshot.data!.length) {
                              if (snapshot.data![i]!.buyerUid == user!.uid) { //why user is null wtf?
                                item!.add(snapshot.data![i]!);
                              }
                            }

                            return SizedBox(
                              height: 500,
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          // mainAxisAlignment:  MainAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              SvgPicture.asset(
                                                  'assets/icons/withdraw.svg',
                                                  color: kColorsPurple),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                '${item![index]!.type!.name.toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                            ]),
                                            // SizedBox(
                                            //   width: 100,
                                            // ),
                                            Text("\$ ${item![index]!.price}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                                textAlign: TextAlign.right)
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Container(
                                          height: 1.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: kColorsCream),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }
                        }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
