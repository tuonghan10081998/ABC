import 'package:flutter/material.dart';
import 'package:mastering_payments/provider/products_provider.dart';
import 'package:mastering_payments/provider/user_provider.dart';
import 'package:mastering_payments/screens/login1.dart';
import 'package:mastering_payments/screens/manage_cards.dart';
import 'package:mastering_payments/screens/putchase.dart';
import 'package:mastering_payments/services/functions.dart';
import 'package:mastering_payments/services/stripe.dart';
import 'package:mastering_payments/services/styles.dart';
import 'package:mastering_payments/widgets/custom_text.dart';
import 'package:mastering_payments/widgets/product_card.dart';
import 'package:provider/provider.dart';

import 'credit_card.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StripeServices stripe = StripeServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    stripe.addCard(
//      cardNumber: 4242424242424242,
//      month: 1,
//      year: 22,
//      cvc: 212,
//      stripeId: 'cus_GcEe3UCPBC3xXs'
//    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
        title: Text(
          "Languages Market",
          style: TextStyle(color: Colors.green),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: CustomText(
                msg: "Santos@enoque.com",
                color: white,
              ),
              accountName: CustomText(
                msg: "Santos Enoque",
                color: white,
              ),
            ),

            ListTile(
              leading: Icon(Icons.add),
              title: CustomText(
                msg: "Add Credit Card",
              ),
              onTap: () {
                changeScreen(context, CreditCard(title: "Add card",));
              },
            ),

            ListTile(
              leading: Icon(Icons.credit_card),
              title: CustomText(
                msg: "Manage Cards",
              ),
              onTap: () {
                changeScreen(context, ManagaCardsScreen());
              },
            ),






            ListTile(
              leading: Icon(Icons.history),
              title: CustomText(
                msg: "Purchase history",
              ),
              onTap: () {
                changeScreen(context,Purchases());
              },
            ),

            ListTile(
              leading: Icon(Icons.memory),
              title: CustomText(
                msg: "Subscriptions",
              ),
              onTap: () {
                changeScreen(context, ManagaCardsScreen());
              },
            ),

            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: CustomText(
                msg: "Log out",
              ),
              onTap: () {
                user.signOut();
                changeScreenReplacement(context, LoginOne());
              },
            ),
          ],
        ),
      ),
      body:  Stack(
        children: <Widget>[



          Container(
          color: white,
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: !user.hasStripeId,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      changeScreen(context, CreditCard(title: "Add card",));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: red[400],
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top:8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.warning, color: white,),
                            SizedBox(width: 10,),
                            CustomText(msg: "Please add your card details", size: 14, color: white,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(1, 1),
                        blurRadius: 4),
                  ]),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: green,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: "Find languages",
                        border: InputBorder.none,
                      ),
                    ),
                    trailing: Icon(
                      Icons.filter_list,
                      color: green,
                    ),
                  ),
                ),
              ),
              Container(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: products.productsList.length,
                      itemBuilder: (_, index){
                    return                 Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        width: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                  color: green[200],
                                  offset: Offset(2, 1),
                                  blurRadius: 5
                              )
                            ]
                        ),child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Image.network("${products.productsList[index].image}", width: 70,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CustomText(msg: products.productsList[index].name,),
                                CustomText(msg: "\$" + products.productsList[index].price.toString(), weight: FontWeight.bold,)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: green
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CustomText(msg: "Buy", color: white,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    );

                      })
                ),
              ),
              Column(
                children: products.productsList.map((item)=> ProductCard(image: item.image,name: item.name, price: item.price)).toList(),
              ),

            ],
          )
    ),

//          Visibility(
//            visible: user.userModel?.stripeId == null,
//            child: Positioned(
//              top: 0,
//              left: 0,
//              child: Container(
//                width: MediaQuery.of(context).size.width,
//                color: red[200],
//                child: Padding(padding: EdgeInsets.all(9),
//                child: CustomText(msg: "You must add a credit card", color: red,),)
//
//              ),
//            ),
//          )
        ],
      ),
    );
  }
}
