import 'package:flutter/material.dart';
import 'package:diego/presentation/helpers/common_widgets_herlpers.dart';
class ContadorScreen extends StatefulWidget {
  const ContadorScreen({super.key});

  

  

  @override
  State<ContadorScreen> createState() => _ContadorScreenState();
}

class _ContadorScreenState extends State<ContadorScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.pinkAccent,
        
        title: CommonWidgetsHelper.buildBoldTitle('Contador'),
      ),
      drawer: CommonWidgetsHelper.buildDrawer(context),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              _counter > 0
                  ? 'El contador es positivo'
                  : _counter < 0
                  ? 'El contador es negativo'
                  : 'El contador es cero',
              style: TextStyle(
                fontSize: 16,
                color:
                    _counter > 0
                        ? Colors.green
                        : (_counter < 0 ? Colors.red : Colors.black),
              ),
            ),
           
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag:  'Increment',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'Decrement',
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 10), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'Reset',
            onPressed: _resetCounter,
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}