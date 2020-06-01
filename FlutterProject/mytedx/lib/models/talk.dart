class Talk {
  final String title;
  final String details;
  final String mainSpeaker;
  final String url;

  Talk.fromJSON(Map<String, dynamic> jsonMap) : //dal json estraggo i valori e li metto negli attributi del mio oggetto Talk
    title = jsonMap['title'],
    details = jsonMap['details'],
    mainSpeaker = (jsonMap['main_speaker'] == null ? "" : jsonMap['main_speaker']),
    url = jsonMap['url'];
}