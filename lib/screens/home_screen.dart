import 'package:jd_shop/model/user_model.dart';
import 'package:jd_shop/pages/all_page.dart';
import 'package:jd_shop/pages/book_page.dart';
import 'package:jd_shop/pages/eraser_page.dart';
import 'package:jd_shop/pages/folder_page.dart';
import 'package:jd_shop/pages/marker_page.dart';
import 'package:jd_shop/pages/paper_page.dart';
import 'package:jd_shop/pages/pen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jd_shop/model/product_model.dart';
import 'package:jd_shop/screens/product_info_screen.dart';
import 'package:jd_shop/services/auth_service.dart';
import 'package:jd_shop/services/database_service.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? type_picked = '';

  List<Product?>? item = [];
  List<Product?>? type_picked_list = [];

  User? user;
  bool _addBtnVisible = true;

  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.currentUser().then((currentUser) {
      setState(() {
        user = currentUser;
      });
      if (user!.role == 'user') {
        _addBtnVisible = false;
      }
    });

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
          child: Container(
              height: 60,
              child: DefaultTabController(
                length: 6,
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: kColorsPurple,
                    indicatorWeight: 4,
                    controller: _tabController,
                    tabs: [
                      Tab(
                          child: Text(
                        'All',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                      Tab(
                          child: Text(
                        'Pen',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                      Tab(
                        child: Text(
                          'Book',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Tab(
                          child: Text(
                        'Paper',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                      Tab(
                          child: Text(
                        'Eraser',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                      Tab(
                          child: Text(
                        'Marker',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                      Tab(
                          child: Text(
                        'Folder',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                    ]),
              )),
        ),
        //สร้างปุ่มด้านขวา
        actions: [
          Visibility(
            visible: _addBtnVisible,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-product');
                },
                icon: SvgPicture.asset('assets/icons/add.svg')),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/test');
              }, icon: SvgPicture.asset('assets/icons/msg.svg')),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile-screen');
              },
              icon: SvgPicture.asset('assets/icons/me.svg'))
        ],
      ),
      body: TabBarView(controller: _tabController, children: [
        AllPage(),
        PenPage(),
        BookPage(),
        PaperPage(),
        EraserPage(),
        MarkerPage(),
        FolderPage(),
      ]),
    );
  }

  void _sort() {
    type_picked_list!.clear();
    int i = 0;
    while (i < item!.length) {
      print(item![i]!.type!.name.toString());
      print(item![i].runtimeType);
      print(type_picked);
      print((item![i]!.type!.name.toString()).compareTo(type_picked!));
      print('=============');
      if ((item![i]!.type!.name.toString()).compareTo(type_picked!) == 0) {
        Product pd = item![i]!;
        type_picked_list!.add(pd);
        print(type_picked_list);
        print('------------');
      }
      i++;
    }

    if (type_picked_list == []) {
      Center(child: Text('no product'));
    }
    print(type_picked_list);
  }
}
