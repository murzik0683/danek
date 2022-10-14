import 'package:danek/generated/locale_keys.g.dart';
import 'package:danek/helpers/colors.dart';
import 'package:danek/helpers/user_preferences.dart';
import 'package:danek/models/animation_button.dart';
import 'package:danek/models/models.dart';
import 'package:danek/models/shop_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<String> myPurchases = [];
  upgradeMyItems() {
    setState(() {
      myPurchases;
      print('upg + $myPurchases');
    });
  }

  Future addPurchase(myPurchase) async {
    await UserPreferences().setMyPurchases(myPurchase);
  }

  @override
  void initState() {
    super.initState();
    myPurchases = UserPreferences().getMyPurchases() ?? [];
    print('init + $myPurchases');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/menubackground.png',
            ),
          ),
        ),
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Магазин'),
          //   centerTitle: true,
          // ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            initialData: bloc.shopList,
            stream: bloc.getStream,
            builder: (context, snapshot) {
              return shopItemsListBuilder(
                  snapshot, context, myPurchases, upgradeMyItems, addPurchase);
            },
          ),
        ),
      ),
    );
  }
}

Widget shopItemsListBuilder(
    snapshot, context, myPurchases, upgradeMyItems, addPurchase) {
  return Column(children: [
    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
    SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: GridView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: snapshot.data["shop_items"].length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (contextsnapshot, index) {
            final shopList = snapshot.data["shop_items"];
            return InkWell(
              onTap: (() {
                showAlertDialog(context, shopList, index, myPurchases,
                    upgradeMyItems, addPurchase);
              }),
              child: Card(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      shopList[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      shopList[index]['image'],
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          shopList[index]['price'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          'assets/images/coin.png',
                          width: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    ),
    const SizedBox(height: 10),
    AnimatedButton(
      color: CustomColors.yellowColor,
      borderColor: CustomColors.yellowColor,
      shadowColor: CustomColors.orangeColor,
      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
      child: Text(
        LocaleKeys.back.tr().toUpperCase(),
        style: textStyleButton(),
      ),
    ),
  ]);
}

showAlertDialog(
    context, shopList, index, myPurchases, upgradeMyItems, addPurchase) {
  Widget cancelButton = TextButton(
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
    child: Text(
      LocaleKeys.cancel.tr(),
      style: TextStyle(color: Colors.black),
    ),
    onPressed: () {
      Navigator.of(context).pop();
      //Navigator.pushNamed(context, '/shoppage');
    },
  );
  Widget okButton = TextButton(
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
    child: Text(
      LocaleKeys.buy.tr(),
      style: TextStyle(color: Colors.black),
    ),
    onPressed: () {
      // функция переодевания героя
      // bloc.addToCart(shopList[index]);
      myPurchases.add(shopList[index].toString());
      upgradeMyItems();
      print("onpre + $myPurchases");
      addPurchase(myPurchases);
      // var re = bloc.shopList['my_items'];
      // print(re);
      // Navigator.pushReplacementNamed(
      //   context,
      //   '/mypurchases',
      // );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/mypurchases',
        (route) => false,
      );
    },
  );

  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
    ),
    titlePadding: const EdgeInsets.only(left: 100, top: 10),
    actionsAlignment: MainAxisAlignment.center,
    title: Text(
      shopList[index]['name'],
    ),
    content: Wrap(children: [
      Row(
        children: [
          const SizedBox(width: 20),
          Image.asset(
            shopList[index]['image'],
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(shopList[index]['price']),
          const SizedBox(width: 10),
          Image.asset(
            'assets/images/coin.png',
            width: 40,
          )
        ],
      ),
    ]),
    actions: [
      okButton,
      cancelButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
          data: ThemeData(
              //dialogTheme: DialogTheme(backgroundColor: CustomColors.whiteColor),
              ),
          child: alert);
    },
  );
}
