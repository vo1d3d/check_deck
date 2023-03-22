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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void checkLogin() {
    if (usernameController.text.toLowerCase() == "username" &&
        passwordController.text == 'password123') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SecondPage()));
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
            InputBox(
              obscure: true,
              label: 'ENTER PASSWORD',
              controller: passwordController,
            ),
            TextButton(
              onPressed: () {
                checkLogin();
              },
              child: const Text('LOG IN'),
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
  List<String> items = [];
  final newItemController = TextEditingController();
  bool deleteMode = false;
  bool isEditMode = false;

  void _addItem() {
    setState(() {
      if (newItemController.text.isNotEmpty) {
        items.add(newItemController.text);
        newItemController.clear();
      }
    });
  }

  void removeItem(String item) {
    setState(
      () {
        items.remove(item); // DOES NOT WORK (TBC)
      },
    );
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
          TextButton(
            onPressed: () {
              setState(() {
                items = [];
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'RESET LIST',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(
                    title: 'Flutter Practice',
                  ),
                ),
              );
            },
            child: const Text('LOG OUT'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
            child: const Text('MANAGE ITEMS'),
          ),
          for (var item in items)
            CrossOutText(
              label: item.toUpperCase(),
              color: isEditMode ? Colors.red : Colors.black,
              items: items,
            ),
          Row(
            children: [
              TextButton(
                onPressed: _addItem,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.all(20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.w300),
                  '+',
                ),
              ),
              InputBox(
                label: 'NEW ITEM',
                controller: newItemController,
              ),
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
  final List<String> items;
  const CrossOutText({
    Key? key,
    required this.label,
    this.color = Colors.black,
    required this.items,
  }) : super(key: key);
  @override
  _CrossOutTextState createState() => _CrossOutTextState();
}

class _CrossOutTextState extends State<CrossOutText>
    with TickerProviderStateMixin {
  bool isChecked = false;
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut))
      ..addListener(() => setState(() {}));
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => setState(() {
          if (widget.color == Colors.red) {
            SecondPageState().removeItem(widget.label);
          } else {
            isChecked = !isChecked;
            controller.forward(from: 0.0);
          }
        }),
        splashFactory: NoSplash.splashFactory,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: <Widget>[
              Text(widget.label,
                  style: TextStyle(
                      color: widget.color,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w300)),
              Container(
                transform: Matrix4.identity()..scale(animation.value, 1),
                child: Text(widget.label,
                    style: TextStyle(
                      color: Colors.transparent,
                      decorationColor: widget.color,
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w300,
                    )),
              ),
            ],
          ),
        ),
      );
}
