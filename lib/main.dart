import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './Widgets/new_transactions.dart';
import './Widgets/Transactions_list.dart';
import './widgets/chart.dart';
import './models/transactions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          // errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),     
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),),
      Transaction(id: 't1',title: 'New Shoes',amount: 69,date: DateTime.now(),),
    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16,date: DateTime.now(),)
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, int txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  } 
  bool _showChart = true;

  List<Widget> itsPort (MediaQueryData mediaQue , AppBar appBar , Widget  xList){
    return[
    Container(
                    height: (mediaQue.size.height -
                            appBar.preferredSize.height -
                            mediaQue.padding.top) *
                        0.3,
                    child: Chart(_recentTransactions)), xList ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQue = MediaQuery.of(context);
    final isLandscape =mediaQue.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS ? CupertinoNavigationBar(
      middle: Text('Expense Tracker'),
      trailing: Row(mainAxisSize: MainAxisSize.min,
        children: <Widget>[
       GestureDetector(child: Icon(CupertinoIcons.add),onTap:() => _startAddNewTransaction(context),)
      ],),
    ): AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    final xList = Container(
                    height: (mediaQue.size.height -
                            appBar.preferredSize.height -
                            mediaQue.padding.top) *
                        0.7,
                    child:
                        TransactionList(_userTransactions, _deleteTransaction));

    final xBody = SafeArea(child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            if(isLandscape ) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart' ,style: Theme.of(context).textTheme.title,),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
            if (!isLandscape) ...itsPort(mediaQue, appBar , xList),
          

            if (isLandscape) _showChart
                ? Container(
                    height: (mediaQue.size.height -
                            appBar.preferredSize.height -
                           mediaQue.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : xList,
          ],
        ),
      )); 
    return Platform.isIOS ? CupertinoPageScaffold(child: xBody, navigationBar: appBar,): Scaffold(
      appBar: appBar,
      body: xBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS? Container(): FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}        