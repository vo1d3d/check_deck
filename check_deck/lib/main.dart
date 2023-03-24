// ignore_for_file: non_constant_identifier_names
import "package:flutter/material.dart";
import "package:flutter/services.dart";

String password = "password123";

void main() {
  runApp(const App());
}

// ----------------
// ** LOGIN PAGE **
// ----------------

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String incorrectText = "";

  void checkLogin() {
    if (usernameController.text.toLowerCase() == "username" &&
        passwordController.text == password) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CheckListPage()));
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

  void forgotPass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPassPage(),
      ),
    );
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
                "CHECK\nDECK",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            InputBox(
              label: "ENTER USERNAME",
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
              label: "ENTER PASSWORD",
              controller: passwordController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 50),
              child:
                  ButtonPreset(buttonText: "LOG IN", pressFunction: checkLogin),
            ),
            ButtonPreset(
                buttonText: "FORGOT PASSWORD", pressFunction: forgotPass),
          ],
        ),
      ),
    );
  }
}

// ---------------
// ** LIST PAGE **
// ---------------

class CheckListPage extends StatefulWidget {
  const CheckListPage({Key? key}) : super(key: key);

  @override
  CheckListPageState createState() => CheckListPageState();
}

class CheckListPageState extends State<CheckListPage> {
  Map<Key, List<dynamic>> items = {};
  final newItemController = TextEditingController();

  void _addItem() {
    setState(() {
      if (newItemController.text.trim().isNotEmpty) {
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

  void _resetList() {
    setState(
      () => items = {},
    );
  }

  void _logOut() {
    Navigator.pop(
      context,
      const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: <Widget>[
          const SafeArea(child: HeaderTitle()),
          Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: ButtonPreset(
                  buttonText: "RESET LIST", pressFunction: _resetList)),
          ButtonPreset(buttonText: "LOG OUT", pressFunction: _logOut),
          for (var item in items.entries)
            CrossOutText(
              ID: item.key,
              label: item.value[0],
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
                  "+",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.w300),
                ),
              ),
              InputBox(label: "NEW ITEM", controller: newItemController),
            ],
          )
        ],
      ),
    );
  }
}

// -------------------------
// ** RESET PASSWORD PAGE **
// -------------------------

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({Key? key}) : super(key: key);

  @override
  ResetPassPageState createState() => ResetPassPageState();
}

class ResetPassPageState extends State<ResetPassPage> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  String sentEmail = "";
  String codeResult = "";
  String resetInputText = "EMAIL";
  String resetButtonText = "SEND EMAIL";

  void returnLogin() {
    Navigator.pop(
      context,
      const LoginPage(),
    );
  }

  void sendEmail() {
    setState(() {
      if (resetButtonText == "SEND EMAIL") {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text)) {
          sentEmail = "Code emailed to ${emailController.text}";
        } else {
          sentEmail = "${emailController.text} is an invalid email";
        }
      } else {
        password = emailController.text;
        sentEmail = "New password set";
      }
    });
  }

  void submitCode(code) {
    setState(() {
      if (code == "12345") {
        emailController.clear();
        codeResult = "Enter your new password above";
        resetButtonText = "RESET PASSWORD";
        resetInputText = "NEW PASSWORD";
        sentEmail = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            const SafeArea(child: HeaderTitle()),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: ButtonPreset(
                  buttonText: "RETURN TO LOG IN",
                  pressFunction: returnLogin,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "PASSWORD RESET",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3),
              ),
            ),
            InputBox(label: resetInputText, controller: emailController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ButtonPreset(
                  buttonText: resetButtonText, pressFunction: sendEmail),
            ),
            Text(
              sentEmail,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 17,
              ),
            ),
            InputBox(
              label: "CODE",
              controller: codeController,
              onChange: submitCode,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------
// ** EXTRACTED WIDGETS **
// -----------------------

// TextButton Preset
class ButtonPreset extends StatelessWidget {
  const ButtonPreset({
    super.key,
    required this.buttonText,
    required this.pressFunction,
  });

  final String buttonText;
  final void Function() pressFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromRGBO(236, 236, 236, 1),
          ),
        ),
        onPressed: pressFunction,
        child: Text(
          buttonText,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              letterSpacing: 4),
        ),
      ),
    );
  }
}

// InputBox Preset
class InputBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final void Function(String)? onChange;

  filler() {}

  const InputBox({
    Key? key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: TextField(
          onChanged: onChange,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r"[ -~]"), // ASCII characters from 32 to 126
            ),
          ],
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
        ),
      ),
    );
  }
}

// CROSS-OUT LIST ITEM
class CrossOutText extends StatefulWidget {
  final String label;
  final bool isChecked;
  final Key ID;

  const CrossOutText(
      {Key? key,
      required this.label,
      required this.ID,
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
    final state = context.findAncestorStateOfType<CheckListPageState>();
    state?._removeItem(widget.ID);
  }

  void switchItem() {
    final state = context.findAncestorStateOfType<CheckListPageState>();
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
          setState(
            () {
              removeItem();
            },
          );
        },
        key: widget.ID,
        child: InkWell(
          onTap: () {
            setState(
              () {
                switchItem();
                controller.forward(from: 0.0);
              },
            );
          },
          splashFactory: NoSplash.splashFactory,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: <Widget>[
                Text(
                  widget.label,
                  style: const TextStyle(
                      color: Colors.black,
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
                      decorationColor: Colors.black,
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

// NON-LOGIN HEADER (TOP OF SCREEN)
class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          "CHECK\nDECK",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
