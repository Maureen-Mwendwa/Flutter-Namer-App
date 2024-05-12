import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// The main() function. In its current form, it only tells Flutter to run the app defined in MyApp.
void main() {
  runApp(MyApp());
}

// The MyApp class extends StatelessWidget. Widgets are the elements from which you build every Flutter app. The code in MyApp sets up the whole app. It creates the app-wide state i.e (create: (context) => MyAppState(),) , names the app, defines the visual theme, and sets the "home" widget—the starting point of your app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// The MyAppState class defines the app's...well...state.There are many powerful ways to manage app state in Flutter. One of the easiest to explain is ChangeNotifier, the approach taken by this app. MyAppState defines the data the app needs to function.The state class extends ChangeNotifier, which means that it can notify others about its own changes. For example, if the current word pair changes, some widgets in the app need to know.
//The state is created and provided to the whole app using a ChangeNotifierProvider. This allows any widget in the app to get hold of the state.

class MyAppState extends ChangeNotifier {
  var current = WordPair
      .random(); //contains a single variable with the current random word pair.

  //The getNext() method reassigns current with a new random WordPair. It also calls notifyListeners()(a method of ChangeNotifier)that ensures that anyone watching MyAppState is notified.
//All that remains is to call the getNext method from the button's callback.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

//specified that the list can only ever contain word pairs: <WordPair>[].This helps make the app more robust as Dart refuses to even run the app if you try to add anything other than WordPair to it. In turn, you can use the favorites list knowing that there can never be any unwanted objects (like null) hiding in there.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

//The MyHomePage contains a Row with two children. The first widget is SafeArea, and the second is an Expanded widget. The SafeArea ensures that its child is not obscured by a hardware notch or a status bar. In the app, the widget wraps around NavigationRail to prevent the navigation buttons from being obscured by a mobile status bar, for example.

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //This class extends State, and can therefore manage its own values. (It can change itself.) The underscore (_) at the start of _MyHomePageState makes that class private and is enforced by the compiler.This stateful widget only needs to track one variable: selectedIndex.

  var selectedIndex =
      0; //A selected index of zero selects the first destination, a selected index of one selects the second destination, and so on. For now, it's hard coded to zero.
  @override
  Widget build(BuildContext context) {
    Widget
        page; //The code declares a new variable, page, of the type Widget.Then, a switch statement assigns a screen to page, according to the current value in selectedIndex.
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page =
            //Placeholder(); //Since there's no FavoritesPage yet, use Placeholder; a handy widget that draws a crossed rectangle wherever you place it, marking that part of the UI as unfinished.
            FavoritesPage();
      default:
        throw UnimplementedError(
            'no widget for $selectedIndex'); //the switch statement also makes sure to throw an error if selectedIndex is neither 0 or 1. This helps prevent bugs down the line. If you ever add a new destination to the navigation rail and forget to update this code, the program crashes in development (as opposed to letting you guess why things don't work, or letting you publish a buggy code into production).
    }

    return LayoutBuilder(builder: (context, constraints) {
      //Modify the callback parameter list from (context) to (context, constraints).LayoutBuilder's builder callback is called every time the constraints change. This happens when, for example: The user resizes the app's window, the user rotates their phone from portrait mode to landscape mode, or back, Some widget next to MyHomePage grows in size, making MyHomePage's constraints smaller. Now the code can decide whether to show the label by querying the current constraints.
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                //can change the extended: false line in NavigationRail to true. This shows the labels next to the icons. NavigationRail doesn't automatically show labels when there's enough space because it can't know what is enough space in every context. It's up to you, the developer, to make that call.The widget to use, in this case, is LayoutBuilder. It lets you change your widget tree depending on how much available space you have.
                //extended: false,
                extended: constraints.maxWidth >=
                    600, //Now, the app responds to its environment, such as screen size, orientation, and platform! In other words, it's responsive!.
                destinations: [
                  //list of NavigationRailDestinations
                  NavigationRailDestination(
                    icon: Icon(Icons.house_outlined),
                    selectedIcon: Icon(Icons.house),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_border),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  //callback, called each time a nav item is selected. The navigation rail defines what happens when the user selects one of the destinations with onDestinationSelected. Right now, the app merely outputs the requested index value with print().
                  //print('selected: $value');
                  // ↓ Replace print with this.
                  setState(() {
                    selectedIndex = value;
                  }); //When the onDestinationSelected callback is called, instead of merely printing the new value to console, you assign it to selectedIndex inside a setState() call. This call is similar to the notifyListeners() method used previously—it makes sure that the UI updates.
                },
                minWidth: 100, //minimum width for the navigation rail.
                labelType: NavigationRailLabelType
                    .none, //enable and style the labels for the navigation items.
                selectedLabelTextStyle: TextStyle(color: Colors.lightBlue[500]),
                unselectedLabelTextStyle: TextStyle(color: Colors.grey[500]),
                elevation: 20,
                useIndicator:
                    true, //adding a rounded highlight behind a selected label icon.
                backgroundColor:
                    Colors.grey[200], //background color of the navigation rail.
                indicatorColor: Colors.cyan[
                    50], //modifying the rounded highlight color using indicatorColor.
              ),
            ),
            Expanded(
              //Expanded widgets are extremely useful in rows and columns—they let you express layouts where some children take only as much space as they need (SafeArea, in this case) and other widgets should take as much of the remaining room as possible (Expanded, in this case). One way to think about Expanded widgets is that they are "greedy". If you want to get a better feel of the role of this widget, try wrapping the SafeArea widget with another Expanded. You'll notice that the two Expanded widgets split all the available horizontal space between themselves, even though the navigation rail only really needed a little slice on the left.
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                //child: GeneratorPage(),
                child:
                    page, //This enables the app to switch between our GeneratorPage and the placeholder that will soon become the Favorites page.
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Every widget defines a build() method that's automatically called every time the widget's circumstances change so that the widget is always up to date. Every build method must return a widget or (more typically) a nested tree of widgets.
    var appState = context.watch<
        MyAppState>(); //MyHomePage tracks changes to the app's current state using the watch method.
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        //Column is one of the most basic layout widgets in Flutter. It takes any number of children and puts them in a column from top to bottom. By default, the column visually places its children at the top.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('A random idea:'),
          //// Text(appState.current.asLowerCase),
          //This Text widget takes appState, and accesses the only member of that class, current (which is a WordPair).To change it into something more complex, it's a good idea to extract this line into a separate widget. Having separate widgets for separate logical parts of your UI is an important way of managing complexity in Flutter.Flutter provides a refactoring helper for extracting widgets but before you use it, make sure that the line being extracted only accesses what it needs. Right now, the line accesses appState, but really only needs to know what the current word pair is. For that reason, rewrite the MyHomePage widget as follows: var pair = appState.current; Text(pair.asLowerCase),

          ////Text(pair.asLowerCase),
          //The Text widget no longer refers to the whole appState. Now, call up the Refactor menu. In the Refactor menu, select Extract Widget. Assign a name, such as BigCard, and click Enter. This automatically creates a new class, BigCard, at the end of the current file.

          BigCard(pair: pair),
          SizedBox(
              height:
                  20), //The SizedBox widget just takes space and doesn't render anything by itself. It's commonly used to create visual "gaps".
          Row(
            mainAxisSize: MainAxisSize
                .min, //mainAxisSize tells Row not to take all available horizontal space unlike mainAxisAlignment.
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  //print('button pressed!'); //This print statement can be used to check whether the button is working. Whereby, when it is pressed, you can see the output on the console button pressed. But we don't want to see the output in the console. We want the case that when we press the button we are able to see the next generated random word. Therefore, we need to have a function called getNext() and then in order for the function to work, we call the getNext() method here.
                  appState.getNext(); // ← This instead of print().
                },
                child: Text('Next'),
              ),
            ],
          ),
        ], //This particular comma doesn't need to be here, because children is the last (and also only) member of this particular Column parameter list. Yet it is generally a good idea to use trailing commas: they make adding more members trivial, and they also serve as a hint for Dart's auto-formatter to put a newline there.
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(
        context); //First, the code requests the app's current theme with Theme.of(context).

//By using theme.textTheme, you access the app's font theme. This class includes members such as bodyMedium (for standard text of medium size), caption (for captions of images), or headlineLarge (for large headlines).The displayMedium property is a large style meant for display text. The documentation for displayMedium says that "display styles are reserved for short, important text"—exactly our use case.Calling copyWith() on displayMedium returns a copy of the text style with the changes you define. In this case, you're only changing the text's color.To get the new color, you once again access the app's theme. The color scheme's onPrimary property defines a color that is a good fit for use on the app's primary color.

//The theme's displayMedium property could theoretically be null. Dart, the programming language in which you're writing this app, is null-safe, so it won't let you call methods of objects that are potentially null. In this case, though, you can use the ! operator ("bang operator") to assure Dart you know what you're doing. (displayMedium is definitely not null in this case.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.surface,
      backgroundColor: Colors.pink,
    );

    return Card(
      color: theme.colorScheme
          .primary, //the code defines the card's color to be the same as the theme's colorScheme property. The color scheme contains many colors, and primary is the most prominent, defining color of the app.
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase,
            style: style,
            semanticsLabel:
                "${pair.first} ${pair.second}"), //screen readers might have problems pronouncing some generated word pairs.A simple solution is to replace pair.asLowerCase with "${pair.first} ${pair.second}". The latter uses string interpolation to create a string (such as "cheap head") from the two words contained in pair. Using two separate words instead of a compound word makes sure that screen readers identify them appropriately, and provides a better experience to visually impaired users.However, you might want to keep the visual simplicity of pair.asLowerCase. Use Text's semanticsLabel property to override the visual content of the text widget with a semantic content that is more appropriate for screen readers.You can also use semanticsLabel: pair.asPascalCase e.g. NeatBeach.
      ),
    );
  }
}

// ...

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<MyAppState>(); //get the current state of the app.

    if (appState.favorites.isEmpty) {
      //If the list of favorites is empty, it shows a centered message: No favorites yet Otherwise, it shows a (scrollable) list.
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState
            .favorites) //The code then iterates through all the favorites, and constructs a ListTile widget for each one.
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
