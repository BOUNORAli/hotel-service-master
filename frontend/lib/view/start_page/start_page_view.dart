import 'package:flutter/material.dart';

class StartPageView extends StatelessWidget {
  const StartPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.732,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/main/bg.png'), fit: BoxFit.fill)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.83,
                height: MediaQuery.of(context).size.height / 5.174,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/main/logo.png"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.height / 68.3,
                    0,
                    MediaQuery.of(context).size.height / 11.38),
                child: Column(children: [
                  const Center(
                    child: Text(
                      "WELCOME",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 10.28,
                        vertical: MediaQuery.of(context).size.height / 136.6),
                    child: const Center(
                      child: Text(
                        "Discover amazing hospitality experiences. Login or Sign up to continue.",
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("LOGIN"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("SIGNUP"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
