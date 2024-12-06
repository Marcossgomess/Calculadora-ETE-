import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDarkMode = true; // Controle global do tema

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home:
          CalculatorScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  CalculatorScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _currentInput = '';
  String _operator = '';
  double _firstOperand = 0;
  List<String> _history = [];

  void _onNumberPress(String number) {
    setState(() {
      if (_display == '0' || (_operator.isNotEmpty && _currentInput.isEmpty)) {
        _currentInput = number;
        _display = number;
      } else {
        _currentInput += number;
        _display += number;
      }
    });
  }

  void _onOperatorPress(String operator) {
    setState(() {
      if (_currentInput.isNotEmpty) {
        _firstOperand = double.parse(_currentInput.replaceAll(',', '.'));
        _operator = operator;
        _display += operator;
        _currentInput = '';
      }
    });
  }

  void _onCalculatePress() {
    if (_operator.isNotEmpty && _currentInput.isNotEmpty) {
      double secondOperand = double.parse(_currentInput.replaceAll(',', '.'));
      double result;

      switch (_operator) {
        case '+':
          result = _firstOperand + secondOperand;
          break;
        case '-':
          result = _firstOperand - secondOperand;
          break;
        case 'x':
          result = _firstOperand * secondOperand;
          break;
        case '÷':
          result =
              secondOperand != 0 ? _firstOperand / secondOperand : double.nan;
          break;
        case '%':
          result = (_firstOperand * secondOperand) / 100;
          break;
        default:
          result = 0.0;
      }

      setState(() {
        String historyEntry =
            '$_firstOperand $_operator $secondOperand = $result';
        _history.add(historyEntry);

        _display = result.toString().replaceAll('.', ',');
        _currentInput = _display;
        _operator = '';
        _firstOperand = 0;
      });
    }
  }

  void _onClearPress() {
    setState(() {
      _display = '0';
      _currentInput = '';
      _operator = '';
      _firstOperand = 0;
    });
  }

  void _onBackspacePress() {
    setState(() {
      if (_currentInput.isNotEmpty) {
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        _display = _currentInput.isEmpty ? '0' : _currentInput;
      }
    });
  }

  void _onDecimalPress() {
    setState(() {
      if (!_currentInput.contains(',')) {
        _currentInput += ',';
        _display = _currentInput;
      }
    });
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Histórico'),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_history[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToIMC() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IMCCalculatorScreen(
          toggleTheme: widget.toggleTheme,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border.all(
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                          width: 3),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calculadora',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            widget.isDarkMode
                                ? Icons.wb_sunny
                                : Icons.nights_stay,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: widget.toggleTheme,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: widget.isDarkMode ? Colors.black : Colors.white,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(20),
                      child: Text(
                        _display,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildButtonRow(['7', '8', '9', '÷']),
                        _buildButtonRow(['4', '5', '6', 'x']),
                        _buildButtonRow(['1', '2', '3', '-']),
                        _buildButtonRow(['C', '0', '=', '+']),
                        _buildButtonRow([',', '⌫', '%']),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _showHistoryDialog,
                    child: Text(
                      'Histórico',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToIMC,
                    child: Text(
                      'IMC Calculator',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (button == 'C') {
                    _onClearPress();
                  } else if (button == '=') {
                    _onCalculatePress();
                  } else if ('+-x÷%'.contains(button)) {
                    _onOperatorPress(button);
                  } else if (button == ',') {
                    _onDecimalPress();
                  } else if (button == '⌫') {
                    _onBackspacePress();
                  } else {
                    _onNumberPress(button);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.isDarkMode ? Colors.blue : Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                child: Text(
                  button,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class IMCCalculatorScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  IMCCalculatorScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _IMCCalculatorScreenState createState() => _IMCCalculatorScreenState();
}

class _IMCCalculatorScreenState extends State<IMCCalculatorScreen> {
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _result = '';
  String _imagePath = ''; // Variável para o caminho da imagem

  void _calculateIMC() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;

    if (weight > 0 && height > 0) {
      double imc = weight / (height * height);
      setState(() {
        String imcResult = imc.toStringAsFixed(2);
        _result = 'IMC: $imcResult';
        _imagePath = ''; // Resetando o caminho da imagem

        if (imc < 18.5) {
          _result +=
              '\nAbaixo do normal\nProcure um médico. Algumas pessoas têm um baixo peso por características do seu organismo e tudo bem. Outras podem estar enfrentando problemas, como a desnutrição. É preciso saber qual é o caso.';
          _imagePath =
              'lib/assets/images/fase1.png.jpg'; // Caminho da imagem quando "abaixo do normal"
        } else if (imc >= 18.5 && imc <= 24.9) {
          _result +=
              '\nNormal\nQue bom que você está com o peso normal! E o melhor jeito de continuar assim é mantendo um estilo de vida ativo e uma alimentação equilibrada.';
        } else if (imc >= 25.0 && imc <= 29.9) {
          _result +=
              '\nSobrepeso\nÉ na verdade, uma pré-obesidade e muitas pessoas nessa faixa já apresentam doenças associadas, como diabetes e hipertensão. Importante rever hábitos e buscar ajuda antes de, por uma série de fatores, entrar na faixa da obesidade pra valer.';
        } else if (imc >= 30.0 && imc <= 34.9) {
          _result +=
              '\nObesidade grau I\nSinal de alerta! Chegou na hora de se cuidar, mesmo que seus exames sejam normais. Vamos dar início a mudanças hoje! Cuide de sua alimentação. Você precisa iniciar um acompanhamento com nutricionista e/ou endocrinologista.';
        } else if (imc >= 35.0 && imc <= 39.9) {
          _result +=
              '\nObesidade grau II\nMesmo que seus exames aparentem estar normais, é hora de se cuidar, iniciando mudanças no estilo de vida com o acompanhamento próximo de profissionais de saúde.';
        } else if (imc >= 40.0) {
          _result +=
              '\nObesidade grau III\nAqui o sinal é vermelho, com forte probabilidade de já existirem doenças muito graves associadas. O tratamento deve ser ainda mais urgente.';
        }
      });
    } else {
      setState(() {
        _result = 'Digite valores válidos!';
        _imagePath = ''; // Limpa a imagem se os valores forem inválidos
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora IMC"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Altura (m)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _calculateIMC,
              child: Text("Calcular IMC"),
            ),
            SizedBox(height: 32),
            Text(
              _result,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
