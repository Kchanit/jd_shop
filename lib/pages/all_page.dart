import 'package:jd_shop/model/product_model.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  List<Product?>? type_picked_list = [];
  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(3.0),
      child: StreamBuilder<List<Product?>>(
        stream: databaseService.getStreamListProduct(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [Text('An error occure.'), Text('${snapshot.error}')],
            ));
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('No Product'),
            );
          } else {
            type_picked_list = snapshot.data;
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.75),
                itemCount: type_picked_list!.length,
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
                              child: '${type_picked_list![index]!.photoURL}' !=
                                      ""
                                  ? Image.network(
                                      '${type_picked_list![index]!.photoURL}',
                                      width: 153,
                                      height: 153,
                                      fit: BoxFit.cover)
                                  : Container(
                                      decoration:
                                          BoxDecoration(color: kColorsCream))),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            '${type_picked_list![index]!.name}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "\$ ${type_picked_list![index]!.price}",
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
}
