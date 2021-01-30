import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderPageViewModel with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  ins() {
    _count += 1;
    notifyListeners();
  }
}

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderPageViewModel(),
      child: _buildPage(),
    );

    // return ChangeNotifierProvider.value(
    //   value: ProviderPageViewModel(),
    //   child: _buildPage(),
    // );
  }

  Scaffold _buildPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('分类'),
      ),
      body: Consumer<ProviderPageViewModel>(
        builder: (context, model, child) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    model.count > 0 ? '${model.count}' : "hi oldbirds!",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => model.ins(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    color: Colors.red,
                    margin: EdgeInsets.only(top: 100),
                    child: Text(
                      '+ 增加',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
