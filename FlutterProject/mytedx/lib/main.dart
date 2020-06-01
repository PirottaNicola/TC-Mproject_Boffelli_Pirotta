import 'package:flutter/material.dart';
import 'talk_repository.dart';
import 'models/talk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTEDx',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'MyTEDx'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Talk>> _talks; //la parola chiave Future indica che quel widget verrà popolato in seguito
  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  void _getTalksByTag() async { //metodo asincrono
    setState(() { //refresha la pagina
      _talks = getTalksByTag(_controller.text, page); //_talks riceverà il testo e il numero di pagine al quale sono arrivato. 
    });
  }

  @override
  Widget build(BuildContext context) { //build è il metodo che costruisce l'interfaccia grafica
    return MaterialApp(
      title: 'My TedX App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My TEDx App'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_talks == null)
              ? Column( //se _talks==null ritorna questo widget
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration:
                          InputDecoration(hintText: 'Enter your favorite talk'),
                    ),
                    RaisedButton(
                      child: Text('Search by tag'),
                      onPressed: () {
                        page = 1;
                        _getTalksByTag();
                      },
                    ),
                  ],
                )
              : FutureBuilder<List<Talk>>(  //se _talks non è null, ritorna questo widget
                  future: _talks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scaffold( //container ad alto livello
                          appBar: AppBar( //con una app bar
                            title: Text("#" + _controller.text), //contenente il tag cercato
                          ),
                          body: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ListTile(
                                    subtitle:
                                        Text(snapshot.data[index].mainSpeaker),
                                    title: Text(snapshot.data[index].title)),
                                onTap: () => Scaffold.of(context).showSnackBar(//quando clicco su un elemento mi mostra i dettagli
                                    SnackBar(content: Text(snapshot.data[index].details))),
                              );
                            },
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: FloatingActionButton(
                            child: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              if (snapshot.data.length >= 6) {
                                page = page + 1;
                                _getTalksByTag();
                              }
                            },
                          ),
                          bottomNavigationBar: BottomAppBar(
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.home),
                                  onPressed: () {
                                    setState(() {//fa scattare un redraw ma prima azzera la lista, riportandomi nella condizione iniziale
                                      _talks = null;
                                      page = 1;
                                      _controller.text = "";
                                    });
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}