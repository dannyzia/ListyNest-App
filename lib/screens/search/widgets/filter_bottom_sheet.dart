
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listynest/models/category.dart';
import 'package:listynest/providers/category_provider.dart';
import 'package:listynest/providers/location_provider.dart';
import 'package:listynest/providers/search_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  RangeValues _currentRangeValues = const RangeValues(0, 10000);
  String? _selectedCondition;
  String? _selectedDatePosted;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<LocationProvider>(context, listen: false).fetchCountries();
      final searchProvider = Provider.of<SearchProvider>(context, listen: false);
      final filterOptions = searchProvider.filterOptions;
      
      if(filterOptions.minPrice != null && filterOptions.maxPrice != null){
        _currentRangeValues = RangeValues(filterOptions.minPrice!, filterOptions.maxPrice!);
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            const Text('Category'),
            const SizedBox(height: 8.0),
            if (categoryProvider.state == CategoryState.loading)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<Category>(
                initialValue: searchProvider.filterOptions.category,
                onChanged: (Category? newValue) {
                  final newOptions = searchProvider.filterOptions.copyWith(
                    category: newValue,
                  );
                  searchProvider.setFilterOptions(newOptions);
                  setState(() {});
                },
                items: categoryProvider.categories.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            const SizedBox(height: 16.0),
            const Text('Location'),
            const SizedBox(height: 8.0),
            if (locationProvider.isLoading && locationProvider.countries.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCountry,
                    hint: const Text('Select Country'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue;
                        _selectedState = null;
                        _selectedCity = null;
                      });
                      if (newValue != null) {
                        locationProvider.fetchStates(newValue);
                      }
                    },
                    items: locationProvider.countries.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedCountry != null)
                    DropdownButtonFormField<String>(
                      initialValue: _selectedState,
                      hint: const Text('Select State'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedState = newValue;
                          _selectedCity = null;
                        });
                        if (newValue != null && _selectedCountry != null) {
                          locationProvider.fetchCities(_selectedCountry!, newValue);
                        }
                      },
                      items: locationProvider.states.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 8),
                  if (_selectedState != null)
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCity,
                      hint: const Text('Select City'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCity = newValue;
                        });
                        if (newValue != null) {
                           final newOptions = searchProvider.filterOptions.copyWith(
                            location: '$newValue, $_selectedState, $_selectedCountry',
                          );
                          searchProvider.setFilterOptions(newOptions);
                        }
                      },
                      items: locationProvider.cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                    ),
                ],
              ),
            const SizedBox(height: 16.0),
            const Text('Price Range'),
            const SizedBox(height: 8.0),
            RangeSlider(
              values: _currentRangeValues,
              min: 0,
              max: 10000,
              divisions: 100,
              labels: RangeLabels(
                _currentRangeValues.start.round().toString(),
                _currentRangeValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
                final newOptions = searchProvider.filterOptions.copyWith(
                  minPrice: values.start,
                  maxPrice: values.end,
                );
                searchProvider.setFilterOptions(newOptions);
              },
            ),
            const SizedBox(height: 16.0),
             const Text('Condition'),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              initialValue: _selectedCondition,
              hint: const Text('Select Condition'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCondition = newValue;
                });
                final newOptions = searchProvider.filterOptions.copyWith(
                  condition: newValue,
                );
                searchProvider.setFilterOptions(newOptions);
              },
              items: ['New', 'Used'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const Text('Date Posted'),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              initialValue: _selectedDatePosted,
              hint: const Text('Select Date Posted'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDatePosted = newValue;
                });
                final newOptions = searchProvider.filterOptions.copyWith(
                  datePosted: newValue,
                );
                searchProvider.setFilterOptions(newOptions);
              },
              items: ['Today', 'This week', 'This month'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    final newOptions = searchProvider.filterOptions.copyWith(
                      category: null,
                      location: '',
                      minPrice: 0.0,
                      maxPrice: 10000.0,
                      condition: null,
                      datePosted: null,
                    );
                    searchProvider.setFilterOptions(newOptions);
                    searchProvider.searchAds();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    searchProvider.searchAds();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
