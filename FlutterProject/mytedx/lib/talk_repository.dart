import 'package:http/http.dart' as http; //importo il package necessario per fare la chiamata
import 'dart:convert'; // package per convertire json in json map
import 'models/talk.dart'; //importo il mio modello dati

Future<List<Talk>> getTalksByTag(String tag, int page) async {
  final String url =
      'https://xl3fc7zadf.execute-api.us-east-1.amazonaws.com/default/Get_Talks_By_Tag'; //url dell'end point per richiamare l'API


  final http.Response response = await http.post(url, //con la chiamata asincrona di node js va a richiamare l'API
    headers: <String, String>{ //definisco gli headers
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{ //definisco il corpo della chiamata
      'tag': tag,
      'page': page,
      'doc_per_page': 6 //numero di elementi per pagina (andrebbe calcolato in base alla dimensione del widget al fine di ottenere l'esperienza utente migliore)
    }),
  );
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    var talks = list.map((model) => Talk.fromJSON(model)).toList(); //vado a richiamare il metodo fromJSON di Talk, che ritorna l'oggetto Talk
    return talks;
  } else {
    throw Exception('Failed to load talks');
  }
      
}