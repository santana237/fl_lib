## fl_lib
Bibliothèque commune pour mes projets Flutter.

### Utilisation
1. Tout d'abord, ajoutez dep.
```yaml
dependencies:
fl_lib:
git:
url: https://github.com/santana237/fl_lib/
ref: main
```

2. Définissez `localizationsDelegates`
```dart
MaterialApp(
localizationsDelegates: const [
LibLocalizations.delegate,
...AppLocalizations.localizationsDelegates,
],
supportedLocales: AppLocalizations.supportedLocales,
)
```

3. Mettez à jour la bibliothèque l10n
```dart
void didChangeDependencies() {
super.didChangeDependencies();
context.setLibL10n();
}
```

4. Init `Paths`
```dart
void main() async {
await Paths.init();
runApp(MyApp());
}
```

### Attention
N'oubliez pas d'exécuter `./export_all.dart` après avoir modifié un fichier dans cette bibliothèque.
