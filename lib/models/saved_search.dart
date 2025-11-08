import 'package:listynest/models/filter_options.dart';

class SavedSearch {
  final String name;
  final String searchTerm;
  final FilterOptions filterOptions;

  SavedSearch({
    required this.name,
    required this.searchTerm,
    required this.filterOptions,
  });
}
