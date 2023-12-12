import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  // inicializar variaveis
  String userInput = "";
  String result = "0";

  List<String> buttonList = [
    "AC",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "-",
    "C",
    "0",
    ".",
    "="
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //cria um array de possiveis widgets
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.79,
            child: resultWidget(),
          ),
          // Cria um widget que expande a child de uma row, column ou flex
          Expanded(child: buttonWidget()),
        ],
      ),
    ));
  }

  Widget resultWidget() {
    return Container(
      color: Colors.blue[50],
      child: Column(
        // coloca o widget no canto direito
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            // Vai ilustrar o valor que for digitado
            child: Text(userInput,
                style: const TextStyle(
                  fontSize: 32,
                )),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            // Vai ilustrar o valor que for digitado
            child: Text(result,
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget buttonWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color.fromARGB(66, 232, 232, 232),
      // procurar saber depois sobre isso
      child: GridView.builder(
        itemCount: buttonList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return button(buttonList[index]);
        },
      ),
    );
  }

// Criamos esse metodo so para fazer get das cores
  getColor(String text) {
    if (text == "/" ||
        text == "*" ||
        text == "-" ||
        text == "C" ||
        text == "(" ||
        text == ")") {
      return Colors.redAccent;
    }

    if (text == "=" || text == "AC") {
      return Colors.white;
    }
    return Colors.indigo;
  }

  getBgColor(String text) {
    if (text == "AC") {
      return Colors.redAccent;
    }

    if (text == "=") {
      return Color.fromARGB(255, 104, 204, 159);
    }

    return Colors.white;
  }

  Widget button(String text) {
    // O que e inkWell
    return InkWell(
      onTap: () {
        setState(() {
          handleButtonPress(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: getBgColor(text),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1,
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  handleButtonPress(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    }

    if (text == "C") {
      if (userInput.length > 0) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }

    if (text == "=") {
      result = calculate();
      userInput = result;

      if (userInput.endsWith(".0")) {
        userInput = userInput.replaceAll(".0", "");
      }

      if (result.endsWith(".0")) {
        result = userInput.replaceAll(".0", "");
      }
      return;
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var eveluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return eveluation.toString();
    } catch (e) {
      return "BUG MAU";
    }
  }
}
