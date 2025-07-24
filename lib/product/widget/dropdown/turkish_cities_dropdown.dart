// import 'package:edumind_intro_app/product/widget/dropdown/core/product_search_dropdown.dart';
// import 'package:edumind_intro_app/product/widget/dropdown/model/suggestion_item.dart';
// import 'package:edumind_intro_app/product/widget/dropdown/model/turkish_city.dart';
// import 'package:flutter/material.dart';

// /// Turkish cities search dropdown widget
// class TurkishCitiesSearchDropdown extends StatelessWidget {
//   /// Creates a Turkish cities search dropdown
//   const TurkishCitiesSearchDropdown({
//     required this.onChanged,
//     super.key,
//     this.value,
//     this.hintText = 'Şehir Seçiniz',
//     this.validator,
//   });

//   /// Callback when city selection changes
//   final ValueChanged<TurkishCity?> onChanged;

//   /// Currently selected city
//   final TurkishCity? value;

//   /// Hint text for the dropdown
//   final String hintText;

//   /// Validator function
//   final String? Function(TurkishCity?)? validator;

//   /// List of all Turkish cities as suggestion items
//   static final List<SuggestionItem<TurkishCity>> cities = [
//     const SuggestionItem(value: TurkishCity(name: 'Adana', id: '1'), label: 'Adana', subtitle: 'Plaka: 01'),
//     const SuggestionItem(value: TurkishCity(name: 'Adıyaman', id: '2'), label: 'Adıyaman', subtitle: 'Plaka: 02'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Afyonkarahisar', id: '3'),
//       label: 'Afyonkarahisar',
//       subtitle: 'Plaka: 03',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Ağrı', id: '4'), label: 'Ağrı', subtitle: 'Plaka: 04'),
//     const SuggestionItem(value: TurkishCity(name: 'Amasya', id: '5'), label: 'Amasya', subtitle: 'Plaka: 05'),
//     const SuggestionItem(value: TurkishCity(name: 'Ankara', id: '6'), label: 'Ankara', subtitle: 'Plaka: 06'),
//     const SuggestionItem(value: TurkishCity(name: 'Antalya', id: '7'), label: 'Antalya', subtitle: 'Plaka: 07'),
//     const SuggestionItem(value: TurkishCity(name: 'Artvin', id: '8'), label: 'Artvin', subtitle: 'Plaka: 08'),
//     const SuggestionItem(value: TurkishCity(name: 'Aydın', id: '9'), label: 'Aydın', subtitle: 'Plaka: 09'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Balıkesir', id: '10'),
//       label: 'Balıkesir',
//       subtitle: 'Plaka: 10',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Bilecik', id: '11'), label: 'Bilecik', subtitle: 'Plaka: 11'),
//     const SuggestionItem(value: TurkishCity(name: 'Bingöl', id: '12'), label: 'Bingöl', subtitle: 'Plaka: 12'),
//     const SuggestionItem(value: TurkishCity(name: 'Bitlis', id: '13'), label: 'Bitlis', subtitle: 'Plaka: 13'),
//     const SuggestionItem(value: TurkishCity(name: 'Bolu', id: '14'), label: 'Bolu', subtitle: 'Plaka: 14'),
//     const SuggestionItem(value: TurkishCity(name: 'Burdur', id: '15'), label: 'Burdur', subtitle: 'Plaka: 15'),
//     const SuggestionItem(value: TurkishCity(name: 'Bursa', id: '16'), label: 'Bursa', subtitle: 'Plaka: 16'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Çanakkale', id: '17'),
//       label: 'Çanakkale',
//       subtitle: 'Plaka: 17',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Çankırı', id: '18'), label: 'Çankırı', subtitle: 'Plaka: 18'),
//     const SuggestionItem(value: TurkishCity(name: 'Çorum', id: '19'), label: 'Çorum', subtitle: 'Plaka: 19'),
//     const SuggestionItem(value: TurkishCity(name: 'Denizli', id: '20'), label: 'Denizli', subtitle: 'Plaka: 20'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Diyarbakır', id: '21'),
//       label: 'Diyarbakır',
//       subtitle: 'Plaka: 21',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Edirne', id: '22'), label: 'Edirne', subtitle: 'Plaka: 22'),
//     const SuggestionItem(value: TurkishCity(name: 'Elazığ', id: '23'), label: 'Elazığ', subtitle: 'Plaka: 23'),
//     const SuggestionItem(value: TurkishCity(name: 'Erzincan', id: '24'), label: 'Erzincan', subtitle: 'Plaka: 24'),
//     const SuggestionItem(value: TurkishCity(name: 'Erzurum', id: '25'), label: 'Erzurum', subtitle: 'Plaka: 25'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Eskişehir', id: '26'),
//       label: 'Eskişehir',
//       subtitle: 'Plaka: 26',
//     ),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Gaziantep', id: '27'),
//       label: 'Gaziantep',
//       subtitle: 'Plaka: 27',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Giresun', id: '28'), label: 'Giresun', subtitle: 'Plaka: 28'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Gümüşhane', id: '29'),
//       label: 'Gümüşhane',
//       subtitle: 'Plaka: 29',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Hakkari', id: '30'), label: 'Hakkari', subtitle: 'Plaka: 30'),
//     const SuggestionItem(value: TurkishCity(name: 'Hatay', id: '31'), label: 'Hatay', subtitle: 'Plaka: 31'),
//     const SuggestionItem(value: TurkishCity(name: 'Isparta', id: '32'), label: 'Isparta', subtitle: 'Plaka: 32'),
//     const SuggestionItem(value: TurkishCity(name: 'Mersin', id: '33'), label: 'Mersin', subtitle: 'Plaka: 33'),
//     const SuggestionItem(value: TurkishCity(name: 'İstanbul', id: '34'), label: 'İstanbul', subtitle: 'Plaka: 34'),
//     const SuggestionItem(value: TurkishCity(name: 'İzmir', id: '35'), label: 'İzmir', subtitle: 'Plaka: 35'),
//     const SuggestionItem(value: TurkishCity(name: 'Kars', id: '36'), label: 'Kars', subtitle: 'Plaka: 36'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Kastamonu', id: '37'),
//       label: 'Kastamonu',
//       subtitle: 'Plaka: 37',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Kayseri', id: '38'), label: 'Kayseri', subtitle: 'Plaka: 38'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Kırklareli', id: '39'),
//       label: 'Kırklareli',
//       subtitle: 'Plaka: 39',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Kırşehir', id: '40'), label: 'Kırşehir', subtitle: 'Plaka: 40'),
//     const SuggestionItem(value: TurkishCity(name: 'Kocaeli', id: '41'), label: 'Kocaeli', subtitle: 'Plaka: 41'),
//     const SuggestionItem(value: TurkishCity(name: 'Konya', id: '42'), label: 'Konya', subtitle: 'Plaka: 42'),
//     const SuggestionItem(value: TurkishCity(name: 'Kütahya', id: '43'), label: 'Kütahya', subtitle: 'Plaka: 43'),
//     const SuggestionItem(value: TurkishCity(name: 'Malatya', id: '44'), label: 'Malatya', subtitle: 'Plaka: 44'),
//     const SuggestionItem(value: TurkishCity(name: 'Manisa', id: '45'), label: 'Manisa', subtitle: 'Plaka: 45'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Kahramanmaraş', id: '46'),
//       label: 'Kahramanmaraş',
//       subtitle: 'Plaka: 46',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Mardin', id: '47'), label: 'Mardin', subtitle: 'Plaka: 47'),
//     const SuggestionItem(value: TurkishCity(name: 'Muğla', id: '48'), label: 'Muğla', subtitle: 'Plaka: 48'),
//     const SuggestionItem(value: TurkishCity(name: 'Muş', id: '49'), label: 'Muş', subtitle: 'Plaka: 49'),
//     const SuggestionItem(value: TurkishCity(name: 'Nevşehir', id: '50'), label: 'Nevşehir', subtitle: 'Plaka: 50'),
//     const SuggestionItem(value: TurkishCity(name: 'Niğde', id: '51'), label: 'Niğde', subtitle: 'Plaka: 51'),
//     const SuggestionItem(value: TurkishCity(name: 'Ordu', id: '52'), label: 'Ordu', subtitle: 'Plaka: 52'),
//     const SuggestionItem(value: TurkishCity(name: 'Rize', id: '53'), label: 'Rize', subtitle: 'Plaka: 53'),
//     const SuggestionItem(value: TurkishCity(name: 'Sakarya', id: '54'), label: 'Sakarya', subtitle: 'Plaka: 54'),
//     const SuggestionItem(value: TurkishCity(name: 'Samsun', id: '55'), label: 'Samsun', subtitle: 'Plaka: 55'),
//     const SuggestionItem(value: TurkishCity(name: 'Siirt', id: '56'), label: 'Siirt', subtitle: 'Plaka: 56'),
//     const SuggestionItem(value: TurkishCity(name: 'Sinop', id: '57'), label: 'Sinop', subtitle: 'Plaka: 57'),
//     const SuggestionItem(value: TurkishCity(name: 'Sivas', id: '58'), label: 'Sivas', subtitle: 'Plaka: 58'),
//     const SuggestionItem(value: TurkishCity(name: 'Tekirdağ', id: '59'), label: 'Tekirdağ', subtitle: 'Plaka: 59'),
//     const SuggestionItem(value: TurkishCity(name: 'Tokat', id: '60'), label: 'Tokat', subtitle: 'Plaka: 60'),
//     const SuggestionItem(value: TurkishCity(name: 'Trabzon', id: '61'), label: 'Trabzon', subtitle: 'Plaka: 61'),
//     const SuggestionItem(value: TurkishCity(name: 'Tunceli', id: '62'), label: 'Tunceli', subtitle: 'Plaka: 62'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Şanlıurfa', id: '63'),
//       label: 'Şanlıurfa',
//       subtitle: 'Plaka: 63',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Uşak', id: '64'), label: 'Uşak', subtitle: 'Plaka: 64'),
//     const SuggestionItem(value: TurkishCity(name: 'Van', id: '65'), label: 'Van', subtitle: 'Plaka: 65'),
//     const SuggestionItem(value: TurkishCity(name: 'Yozgat', id: '66'), label: 'Yozgat', subtitle: 'Plaka: 66'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Zonguldak', id: '67'),
//       label: 'Zonguldak',
//       subtitle: 'Plaka: 67',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Aksaray', id: '68'), label: 'Aksaray', subtitle: 'Plaka: 68'),
//     const SuggestionItem(value: TurkishCity(name: 'Bayburt', id: '69'), label: 'Bayburt', subtitle: 'Plaka: 69'),
//     const SuggestionItem(value: TurkishCity(name: 'Karaman', id: '70'), label: 'Karaman', subtitle: 'Plaka: 70'),
//     const SuggestionItem(
//       value: TurkishCity(name: 'Kırıkkale', id: '71'),
//       label: 'Kırıkkale',
//       subtitle: 'Plaka: 71',
//     ),
//     const SuggestionItem(value: TurkishCity(name: 'Batman', id: '72'), label: 'Batman', subtitle: 'Plaka: 72'),
//     const SuggestionItem(value: TurkishCity(name: 'Şırnak', id: '73'), label: 'Şırnak', subtitle: 'Plaka: 73'),
//     const SuggestionItem(value: TurkishCity(name: 'Bartın', id: '74'), label: 'Bartın', subtitle: 'Plaka: 74'),
//     const SuggestionItem(value: TurkishCity(name: 'Ardahan', id: '75'), label: 'Ardahan', subtitle: 'Plaka: 75'),
//     const SuggestionItem(value: TurkishCity(name: 'Iğdır', id: '76'), label: 'Iğdır', subtitle: 'Plaka: 76'),
//     const SuggestionItem(value: TurkishCity(name: 'Yalova', id: '77'), label: 'Yalova', subtitle: 'Plaka: 77'),
//     const SuggestionItem(value: TurkishCity(name: 'Karabük', id: '78'), label: 'Karabük', subtitle: 'Plaka: 78'),
//     const SuggestionItem(value: TurkishCity(name: 'Kilis', id: '79'), label: 'Kilis', subtitle: 'Plaka: 79'),
//     const SuggestionItem(value: TurkishCity(name: 'Osmaniye', id: '80'), label: 'Osmaniye', subtitle: 'Plaka: 80'),
//     const SuggestionItem(value: TurkishCity(name: 'Düzce', id: '81'), label: 'Düzce', subtitle: 'Plaka: 81'),
//   ];

//   /// Gets the selected item based on the current value
//   SuggestionItem<TurkishCity>? get selectedItem {
//     if (value == null) return null;
//     return cities.firstWhere(
//       (item) => item.value == value,
//       orElse: () => SuggestionItem(value: value!, label: value!.name),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ProductSearchDropdown<TurkishCity>(
//       prefixIcon: const Icon(Icons.location_city, color: Colors.black45),
//       items: cities,
//       value: selectedItem,
//       onChanged: (suggestionItem) {
//         onChanged(suggestionItem?.value);
//       },
//       hintText: hintText,
//       validator: (suggestionItem) {
//         return validator?.call(suggestionItem?.value);
//       },
//     );
//   }
// }

import 'package:edumind_intro_app/product/widget/dropdown/model/turkish_city.dart';
import 'package:flutter/material.dart';

/// Turkish Cities Dropdown - No Keyboard Version
class TurkishCitiesDropdownNoKeyboard extends StatelessWidget {
  const TurkishCitiesDropdownNoKeyboard({
    required this.onChanged,
    super.key,
    this.value,
    this.hintText = 'Şehir Seçiniz',
  });

  final ValueChanged<TurkishCity?> onChanged;
  final TurkishCity? value;
  final String hintText;

  static final List<TurkishCity> _cities = [
    const TurkishCity(name: 'Adana', id: '1'),
    const TurkishCity(name: 'Adıyaman', id: '2'),
    const TurkishCity(name: 'Afyonkarahisar', id: '3'),
    const TurkishCity(name: 'Ağrı', id: '4'),
    const TurkishCity(name: 'Amasya', id: '5'),
    const TurkishCity(name: 'Ankara', id: '6'),
    const TurkishCity(name: 'Antalya', id: '7'),
    const TurkishCity(name: 'Artvin', id: '8'),
    const TurkishCity(name: 'Aydın', id: '9'),
    const TurkishCity(name: 'Balıkesir', id: '10'),
    const TurkishCity(name: 'Bilecik', id: '11'),
    const TurkishCity(name: 'Bingöl', id: '12'),
    const TurkishCity(name: 'Bitlis', id: '13'),
    const TurkishCity(name: 'Bolu', id: '14'),
    const TurkishCity(name: 'Burdur', id: '15'),
    const TurkishCity(name: 'Bursa', id: '16'),
    const TurkishCity(name: 'Çanakkale', id: '17'),
    const TurkishCity(name: 'Çankırı', id: '18'),
    const TurkishCity(name: 'Çorum', id: '19'),
    const TurkishCity(name: 'Denizli', id: '20'),
    const TurkishCity(name: 'Diyarbakır', id: '21'),
    const TurkishCity(name: 'Edirne', id: '22'),
    const TurkishCity(name: 'Elazığ', id: '23'),
    const TurkishCity(name: 'Erzincan', id: '24'),
    const TurkishCity(name: 'Erzurum', id: '25'),
    const TurkishCity(name: 'Eskişehir', id: '26'),
    const TurkishCity(name: 'Gaziantep', id: '27'),
    const TurkishCity(name: 'Giresun', id: '28'),
    const TurkishCity(name: 'Gümüşhane', id: '29'),
    const TurkishCity(name: 'Hakkari', id: '30'),
    const TurkishCity(name: 'Hatay', id: '31'),
    const TurkishCity(name: 'Isparta', id: '32'),
    const TurkishCity(name: 'Mersin', id: '33'),
    const TurkishCity(name: 'İstanbul', id: '34'),
    const TurkishCity(name: 'İzmir', id: '35'),
    const TurkishCity(name: 'Kars', id: '36'),
    const TurkishCity(name: 'Kastamonu', id: '37'),
    const TurkishCity(name: 'Kayseri', id: '38'),
    const TurkishCity(name: 'Kırklareli', id: '39'),
    const TurkishCity(name: 'Kırşehir', id: '40'),
    const TurkishCity(name: 'Kocaeli', id: '41'),
    const TurkishCity(name: 'Konya', id: '42'),
    const TurkishCity(name: 'Kütahya', id: '43'),
    const TurkishCity(name: 'Malatya', id: '44'),
    const TurkishCity(name: 'Manisa', id: '45'),
    const TurkishCity(name: 'Kahramanmaraş', id: '46'),
    const TurkishCity(name: 'Mardin', id: '47'),
    const TurkishCity(name: 'Muğla', id: '48'),
    const TurkishCity(name: 'Muş', id: '49'),
    const TurkishCity(name: 'Nevşehir', id: '50'),
    const TurkishCity(name: 'Niğde', id: '51'),
    const TurkishCity(name: 'Ordu', id: '52'),
    const TurkishCity(name: 'Rize', id: '53'),
    const TurkishCity(name: 'Sakarya', id: '54'),
    const TurkishCity(name: 'Samsun', id: '55'),
    const TurkishCity(name: 'Siirt', id: '56'),
    const TurkishCity(name: 'Sinop', id: '57'),
    const TurkishCity(name: 'Sivas', id: '58'),
    const TurkishCity(name: 'Tekirdağ', id: '59'),
    const TurkishCity(name: 'Tokat', id: '60'),
    const TurkishCity(name: 'Trabzon', id: '61'),
    const TurkishCity(name: 'Tunceli', id: '62'),
    const TurkishCity(name: 'Şanlıurfa', id: '63'),
    const TurkishCity(name: 'Uşak', id: '64'),
    const TurkishCity(name: 'Van', id: '65'),
    const TurkishCity(name: 'Yozgat', id: '66'),
    const TurkishCity(name: 'Zonguldak', id: '67'),
    const TurkishCity(name: 'Aksaray', id: '68'),
    const TurkishCity(name: 'Bayburt', id: '69'),
    const TurkishCity(name: 'Karaman', id: '70'),
    const TurkishCity(name: 'Kırıkkale', id: '71'),
    const TurkishCity(name: 'Batman', id: '72'),
    const TurkishCity(name: 'Şırnak', id: '73'),
    const TurkishCity(name: 'Bartın', id: '74'),
    const TurkishCity(name: 'Ardahan', id: '75'),
    const TurkishCity(name: 'Iğdır', id: '76'),
    const TurkishCity(name: 'Yalova', id: '77'),
    const TurkishCity(name: 'Karabük', id: '78'),
    const TurkishCity(name: 'Kilis', id: '79'),
    const TurkishCity(name: 'Osmaniye', id: '80'),
    const TurkishCity(name: 'Düzce', id: '81'),
  ];

  void _showCitySelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Şehir Seçiniz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black38,
                ),
              ),

              // Cities list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _cities.length,
                  itemBuilder: (context, index) {
                    final city = _cities[index];
                    final isSelected = value?.id == city.id;

                    return ListTile(
                      title: Text(
                        city.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                        ),
                      ),
                      subtitle: Text('Plaka: ${index + 1}'),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                      onTap: () {
                        onChanged(city);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCitySelectionModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_city, color: Colors.black45),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value?.name ?? hintText,
                style: TextStyle(
                  fontSize: 16,
                  color: value != null ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
