import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

/// This function is the root Entry point for any Flutter App
void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
          primaryColor: Colors.white
      ),
      home: RandomWords(),
    );
  }
}

/**
 * In DART.. Private modified doesn't exist.
 * Any Variable or Function name starting with "_" in front
 * is private in it's Package.
 *
 * Yes, no class level privacy here but rather package level.
 */
class RandomWords extends StatefulWidget {
  /// Equivalent to private fun createState(): RandomWordsState()
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[]; //A List like ArrayList<Type>, MutableList<Type>
  final _saved = <WordPair>{}; //A Set which is a collection, like HashMap<K, V>
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final tiles = _saved.map(
                  (WordPair pair){
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
          );
          final divider = ListTile.divideTiles(
              context: context,
              tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divider),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions(){
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          if(i.isOdd) return Divider();

          final index = i ~/ 2;
          if(index >= _suggestions.length){
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  //same as private class buildRow(pair: WordPair): Widget()
  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite: Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}