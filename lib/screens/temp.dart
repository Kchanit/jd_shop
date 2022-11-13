import 'package:jd_shop/model/product_model.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    //fscaf
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kColorsWhite,
          title: Text(
            'JD Shop',
            style: Theme.of(context).textTheme.headline2,
          ),
          //สร้างเส้นคั่น
          shape: Border(bottom: BorderSide(color: kColorsCream, width: 1.5)),
          elevation: 0,
          toolbarHeight: 60,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(height: 60),
          ),
          //สร้างปุ่มด้านขวา
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-product');
                },
                icon: SvgPicture.asset('assets/icons/add.svg')),
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/msg.svg')),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                icon: SvgPicture.asset('assets/icons/me.svg'))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: StreamBuilder<List<Product?>>(
            stream: databaseService.getStreamListProduct(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('An error occure.'));
              }

              if (!snapshot.hasData) {
                return Center(
                  child: Text('No Product'),
                );
              } else {
                print('${snapshot.data![3]!.photoURL}');
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.75),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (() {
                            Navigator.pushNamed(context, "/product-info",
                                arguments: snapshot.data![index]);
                          }),
                          child: Column(
                            // mainAxisAlignment:  MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                  aspectRatio: 1,
                                  // child:  Image.network('${snapshot.data![index]!.photoURL}'),
                                  child: '${snapshot.data![index]!.photoURL}' !=
                                          ""
                                      ? Image.network(
                                          '${snapshot.data![index]!.photoURL}',
                                          width: 153,
                                          height: 153,
                                          fit: BoxFit.cover)
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: kColorsCream))),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                '${snapshot.data![index]!.name}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "\$ ${snapshot.data![index]!.price}",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kColorsPurple),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
          ),
        ));
  }
  // openGallery(BuildContext context) async {
  // final pickedFile = await ;
  // setState(() {
  //   if(pickedFile != null) {
  //     imageFile = File(s);
  //   }else {
  //     print('No Image selected');
  //   }
  // });
  //   Navigator.of(context).pop();
  // }

}
