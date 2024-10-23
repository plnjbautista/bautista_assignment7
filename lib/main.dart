import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Controllers for all input fields
  final TextEditingController _add1Controller = TextEditingController();
  final TextEditingController _add2Controller = TextEditingController();
  final TextEditingController _sub1Controller = TextEditingController();
  final TextEditingController _sub2Controller = TextEditingController();
  final TextEditingController _mul1Controller = TextEditingController();
  final TextEditingController _mul2Controller = TextEditingController();
  final TextEditingController _div1Controller = TextEditingController();
  final TextEditingController _div2Controller = TextEditingController();

  // Results for each operation.
  // Changed from int to double to handle decimal results and ensure precision, especially for division where outcomes may not be whole numbers.
  double addResult = 0;
  double subResult = 0;
  double mulResult = 0;
  double divResult = 0;

  // Helper function to parse input safely
  double parseInput(String value) {
    return double.tryParse(value) ??
        0; // Parses the input or returns 0 if invalid
  }

  // Operation functions
  // Implementing addition
  void add() {
    setState(() {
      addResult =
          parseInput(_add1Controller.text) + parseInput(_add2Controller.text);
    });
  }

  // 3.c Implementing subtraction, multiplication, and division operations
  void subtract() {
    setState(() {
      subResult =
          parseInput(_sub1Controller.text) - parseInput(_sub2Controller.text);
    });
  }

  void multiply() {
    setState(() {
      mulResult =
          parseInput(_mul1Controller.text) * parseInput(_mul2Controller.text);
    });
  }

  void divide() {
    setState(() {
      final divisor = parseInput(_div2Controller.text);
      if (divisor != 0) {
        divResult = parseInput(_div1Controller.text) / divisor;
      } else {
        divResult = 0; // Handle division by zero
      }
    });
  }

  // Clear function for each row
  void clearRow(List<TextEditingController> controllers, String operation) {
    setState(() {
      for (var controller in controllers) {
        controller.clear(); // Clear the text fields
      }
      switch (operation) {
        case 'add':
          addResult = 0; // Reset the addition result
          break;
        case 'sub':
          subResult = 0; // Reset the subtraction result
          break;
        case 'mul':
          mulResult = 0; // Reset the multiplication result
          break;
        case 'div':
          divResult = 0; // Reset the division result
          break;
      }
    });
  }

  // Create a reusable calculator row
  Widget calculatorRow({
    required TextEditingController controller1,
    required TextEditingController controller2,
    required String operator,
    required double result,
    required VoidCallback onCalculate,
    required VoidCallback onClear,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: TextField(
              controller: controller1,
              decoration: const InputDecoration(labelText: "First Number"),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(operator), // Display the operator (+, -, ×, ÷)
          ),
          Expanded(
            child: TextField(
              controller: controller2,
              decoration: const InputDecoration(labelText: "Second Number"),
              keyboardType: TextInputType.number,
            ),
          ),
          Text(
              ' = ${result.toStringAsFixed(2)}'), // Show the result with 2 decimal places

          // 3.a: IconButton to perform the selected operation on the two inputs and update the result.
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: onCalculate, // Button to perform calculation
          ),

          // 3.b: ElevatedButton to clear the input fields and reset the result for this operation.
          ElevatedButton(
            onPressed: onClear, // Button to clear input fields and results
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 5 Calculator"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Addition Row
              calculatorRow(
                controller1: _add1Controller,
                controller2: _add2Controller,
                operator: '+',
                result: addResult,
                onCalculate: add, // Function for addition
                onClear: () => clearRow([_add1Controller, _add2Controller],
                    'add'), // Clear for addition
              ),
              const Divider(),
              // Subtraction Row
              calculatorRow(
                controller1: _sub1Controller,
                controller2: _sub2Controller,
                operator: '-',
                result: subResult,
                onCalculate: subtract, // Function for subtraction
                onClear: () => clearRow([_sub1Controller, _sub2Controller],
                    'sub'), // Clear for subtraction
              ),
              const Divider(),
              // Multiplication Row
              calculatorRow(
                controller1: _mul1Controller,
                controller2: _mul2Controller,
                operator: '×',
                result: mulResult,
                onCalculate: multiply, // Function for multiplication
                onClear: () => clearRow([_mul1Controller, _mul2Controller],
                    'mul'), // Clear for multiplication
              ),
              const Divider(),
              // Division Row
              calculatorRow(
                controller1: _div1Controller,
                controller2: _div2Controller,
                operator: '÷',
                result: divResult,
                onCalculate: divide, // Function for division
                onClear: () => clearRow([_div1Controller, _div2Controller],
                    'div'), // Clear for division
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _add1Controller.dispose();
    _add2Controller.dispose();
    _sub1Controller.dispose();
    _sub2Controller.dispose();
    _mul1Controller.dispose();
    _mul2Controller.dispose();
    _div1Controller.dispose();
    _div2Controller.dispose();
    super.dispose();
  }
}
