
import 'package:listynest/models/category_model.dart';

class FilterOptions {
  final String? search;
  final Category? category;
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final String? condition;
  final String? datePosted;

  FilterOptions({
    this.search,
    this.category,
    this.location,
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.datePosted,
  });

  FilterOptions copyWith({
    String? search,
    Category? category,
    bool clearCategory = false,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? condition,
    bool clearCondition = false,
    String? datePosted,
    bool clearDatePosted = false,
  }) {
    return FilterOptions(
      search: search ?? this.search,
      category: clearCategory ? null : category ?? this.category,
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      condition: clearCondition ? null : condition ?? this.condition,
      datePosted: clearDatePosted ? null : datePosted ?? this.datePosted,
    );
  }
}
