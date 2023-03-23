// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Practice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Practice'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String incorrectText = "";

  void checkLogin() {
    if (usernameController.text.toLowerCase() == "username" &&
        passwordController.text == 'password123') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SecondPage()));
      setState(() {
        incorrectText = "";
        usernameController.clear();
        passwordController.clear();
      });
    } else {
      setState(() {
        incorrectText = "Incorrect Username Or Password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                "assets/shopping-list.png",
                height: 150,
                width: 150,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'CHECK\nDECK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            InputBox(
              label: 'ENTER USERNAME',
              controller: usernameController,
            ),
            Text(
              incorrectText,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w300,
                fontSize: 17,
              ),
            ),
            InputBox(
              obscure: true,
              label: 'ENTER PASSWORD',
              controller: passwordController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(200, 200, 200, 1),
                  ),
                ),
                onPressed: () {
                  checkLogin();
                },
                child: const Text(
                  'LOG IN',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;

  const InputBox({
    Key? key,
    required this.label,
    required this.controller,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextField(
              obscureText: obscure,
              controller: controller,
              style: const TextStyle(
                backgroundColor: Color.fromRGBO(235, 235, 235, 1),
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(235, 235, 235, 1),
                hintText: label,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                hintStyle: const TextStyle(
                    color: Color.fromRGBO(153, 153, 153, 1), fontSize: 20),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2.0),
                  borderRadius: BorderRadius.zero,
                ),
              ),
            )));
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  Map<Key, List<dynamic>> items = {};
  final newItemController = TextEditingController();
  bool isEditMode = false;

  void _addItem() {
    setState(() {
      if (newItemController.text.isNotEmpty) {
        items[UniqueKey()] = [newItemController.text, false];
        newItemController.clear();
      }
    });
  }

  void _removeItem(Key itemID) {
    setState(() => items.remove(itemID));
  }

  void _switchItem(Key itemID) {
    setState(() => items[itemID] = [items[itemID]![0], !items[itemID]![1]]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(217, 217, 217, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1.5,
                  blurRadius: 3,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'CHECK\nDECK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextButton(
              onPressed: () => setState(() => items = {}),
              child: const Text(
                'RESET LIST',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(title: 'Flutter Practice'),
              ),
            ),
            child: const Text(
              'LOG OUT',
              style: TextStyle(color: Colors.black),
            ),
          ),
          for (var item in items.entries)
            CrossOutText(
              ID: item.key,
              label: item.value[0],
              color: isEditMode ? Colors.red : Colors.black,
              isChecked: item.value[1],
            ),
          Row(
            children: [
              TextButton(
                onPressed: _addItem,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text(
                  '+',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.w300),
                ),
              ),
              InputBox(label: 'NEW ITEM', controller: newItemController),
            ],
          )
        ],
      ),
    );
  }
}

class CrossOutText extends StatefulWidget {
  final String label;
  final Color color;
  final bool isChecked;
  final Key ID;

  const CrossOutText(
      {Key? key,
      required this.label,
      required this.ID,
      this.color = const Color.fromARGB(255, 0, 0, 0),
      required this.isChecked})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _CrossOutTextState createState() => _CrossOutTextState();
}

class _CrossOutTextState extends State<CrossOutText>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    )..addListener(() => setState(() {}));
    controller.forward(from: 0.0);
  }

  void removeItem() {
    final state = context.findAncestorStateOfType<SecondPageState>();
    state?._removeItem(widget.ID);
  }

  void switchItem() {
    final state = context.findAncestorStateOfType<SecondPageState>();
    state?._switchItem(widget.ID);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dismissible(
        onDismissed: (direction) {
          setState(() {
            removeItem();
          });
        },
        key: widget.ID,
        child: InkWell(
          onTap: () {
            setState(() {
              switchItem();
              controller.forward(from: 0.0);
            });
          },
          splashFactory: NoSplash.splashFactory,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: <Widget>[
                Text(
                  widget.label,
                  style: TextStyle(
                      color: widget.color,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w300),
                ),
                Container(
                  transform: Matrix4.identity()..scale(animation.value, 1),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.transparent,
                      decorationColor: widget.color,
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: widget.isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
