import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Black Adam',
    'Iron Man III'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        onPressed: () { 
          query = ''; // AQUI NO HACE FALTA setState({})
        }, 
        icon: Icon(Icons.clear)
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(
          context,
          null
        );
      }, 
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if(query.isEmpty) { return Container(); }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
/*             children: peliculas.map((peli)... // CONVERTO TO --|*/
            children: (peliculas as List).map((peli) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(peli.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(peli.title as String),
                  subtitle: Text(peli.originalTitle as String),
                  onTap: () {
                    close(context, null);
                    peli.uniqueId = '' as String;
                    Navigator.pushNamed(
                      context,
                      'detalle',
                      arguments: peli
                    );
                  },
                );
              }
            ).toList(),
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }


  // BUILD SUGGESTIONS con info estatica
  /* Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    final listaSugerida = (query.isEmpty) ? peliculasRecientes : peliculas.where(
      (el) => el.toLowerCase().startsWith(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: peliculasRecientes.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(peliculasRecientes[index]),
          onTap: () {
            seleccion = listaSugerida[index];
            showResults(context);
          },
        );

      }
    );
  } */

}