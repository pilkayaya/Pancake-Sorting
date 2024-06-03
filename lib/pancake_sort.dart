import 'package:flutter/material.dart';

class PancakeSortPage extends StatefulWidget {
  const PancakeSortPage({super.key});

  @override
  State<PancakeSortPage> createState() => _PancakeSortPageState();
}

class _PancakeSortPageState extends State<PancakeSortPage> {
  TextEditingController _inputController = TextEditingController();
  List<int> _inputNumbers = [];
  List<int> _sortedNumbers = [];
  String _sortingSteps = '';
  bool _showInputBox = true;
  bool _showSteps = false;
  int _expandedPanelIndex = -1;

  void _handleInput() {
    if (_inputController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Data masih kosong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _inputNumbers = _inputController.text
            .split(RegExp(r'[,\s]+'))
            .map((String num) => int.tryParse(num.trim()) ?? 0)
            .toList();

        _showInputBox = false;
        _showSteps = true;
      });
    }
  }

  void pancakeSort(List<int> arr) {
    List<int> sorted = List.from(arr);
    int n = sorted.length;
    for (int i = n - 1; i > 0; i--) {
      int maxIndex = findMaxIndex(sorted, i);

      if (maxIndex != i) {
        flip(sorted, maxIndex);
        flip(sorted, i);
      }
    }
    _sortedNumbers = sorted;
  }

  int findMaxIndex(List<int> arr, int end) {
    int maxIndex = 0;
    for (int i = 1; i <= end; i++) {
      if (arr[i] > arr[maxIndex]) {
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  void flip(List<int> arr, int i) {
      int start = 0;
      while (start < i) {
        int temp = arr[start];
        arr[start] = arr[i];
        arr[i] = temp;
        start++;
        i--;
      }

    _sortingSteps += 'Langkah: ${arr}\n';
  }

  void _pancakeSort() {
    setState(() {
      pancakeSort(_inputNumbers);
      _sortedNumbers = List.from(_sortedNumbers);
    });
  }

  void _clearAll() {
    setState(() {
      _inputController.clear();
      _inputNumbers = [];
      _sortedNumbers = [];
      _sortingSteps = '';
      _showInputBox = true;
      _showSteps = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Pancake Sorting',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo[400]),
      body: Container(
        color: Colors.indigo,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Lebar Container
            padding: EdgeInsets.all(20.0), // Padding untuk Container
            decoration: BoxDecoration(
              color: Colors
                  .white, // Warna latar belakang Container untuk box input
              borderRadius: BorderRadius.circular(10.0), // Border radius
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_showInputBox)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          TextField(
                            controller: _inputController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Input Data',
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _handleInput,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[400],
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Input',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _clearAll(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[400],
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (_showInputBox) SizedBox(height: 20.0),
                  if (_showSteps)
                    Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                'Angka yang Diinput:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.indigo[
                                  50], // Warna latar belakang bubble
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bentuk bubble
                                ),
                                child: Text(
                                  '$_inputNumbers',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: _pancakeSort,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[400],
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Pancake Sorting',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    _expandedPanelIndex =
                                    _expandedPanelIndex == index
                                        ? -1
                                        : index;
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title:
                                        Text('Langkah-langkah Pengurutan:'),
                                      );
                                    },
                                    body: SingleChildScrollView(
                                      child: Text(_sortingSteps),
                                    ),
                                    isExpanded: _expandedPanelIndex == 0,
                                    backgroundColor: Colors.indigo[50],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Container(
                                child: Column(
                                  children: [
                                    Text(
                                      'Hasil Pancake Sorting:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo[
                                        50], // Warna latar belakang bubble
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Bentuk bubble
                                      ),
                                      child: Text(
                                        '$_sortedNumbers',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: _clearAll,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[400],
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Clear All',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
