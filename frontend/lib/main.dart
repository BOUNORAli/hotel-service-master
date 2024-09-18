import 'package:flutter/material.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:food_order_ui/view/start_page/start_page_view.dart';
import 'package:food_order_ui/view/login_page/login_page_view.dart';
import 'package:food_order_ui/view/register_page/register_page_view.dart';
import 'package:food_order_ui/view/home_page/home_page_view.dart';
import 'package:food_order_ui/view/backoffice_dashboard/dashboard.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/order_list_view.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/order_detail_view.dart';
import 'package:food_order_ui/configuration/order.dart' as order_conf;
import 'package:food_order_ui/configuration/client.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/client_list_view.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/client_detail_view.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/client_edit_view.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/food_list_screen.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/food_form_screen.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/view/admin_options/admin_options_page.dart';
import 'package:flutter/material.dart';
import 'package:food_order_ui/services/api_service.dart';
import 'package:food_order_ui/view/bottom_navigator.dart';
import 'package:food_order_ui/view/admin_options/admin_options_page.dart';
import 'package:food_order_ui/view/login_page/widgets/text_field_widget/text_field_input.dart';
import 'package:food_order_ui/view/login_page/widgets/text_field_widget/text_field_password.dart';
import 'package:food_order_ui/view/login_page/widgets/text_signup.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefsUtil = SharedPrefsUtil();
  await sharedPrefsUtil.initPrefs();
  runApp(MyApp(sharedPrefsUtil: sharedPrefsUtil));
}

class MyApp extends StatelessWidget {
  final SharedPrefsUtil sharedPrefsUtil;

  const MyApp({Key? key, required this.sharedPrefsUtil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPageView(),
        '/login': (context) => const LoginPageView(),
        '/register': (context) => const RegisterPageView(),
        '/home': (context) => const MyHomePage(),
        '/admin_options': (context) => const AdminOptionsPage(),
        '/dashboard': (context) => const BackOfficeDashboard(),
        '/foods': (context) => const FoodListScreen(),
        '/clients': (context) => ClientListView(),
        '/order_list': (context) => OrderListView(sharedPrefsUtil: sharedPrefsUtil),
      },
    onGenerateRoute: (settings) {
      if (settings.name == '/order_detail') {
        final order = settings.arguments as order_conf.Order;
        return MaterialPageRoute(
          builder: (context) {
            return OrderDetailView(order: order);
          },
        );
      }
      if (settings.name == '/client_detail') {
        final client = settings.arguments as Client;
        return MaterialPageRoute(
          builder: (context) {
            return ClientDetailView(client: client);
          },
        );
      }
      if (settings.name == '/client_edit') {
        final client = settings.arguments as Client;
        return MaterialPageRoute(
          builder: (context) {
            return ClientEditView(client: client);
          },
        );
      }
      return null;
    },
    );
  }
}


