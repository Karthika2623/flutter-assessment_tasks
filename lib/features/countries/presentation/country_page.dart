import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/async_state_view.dart';
import '../data/country_model.dart';
import 'country_controller.dart';

class CountryPage extends GetView<CountryController> {
  const CountryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1000 ? 3 : width >= 650 ? 2 : 1;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: TextField(
          onChanged: controller.search,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Search countries by name'),
        ),
      ),
      Expanded(child: Obx(() {
        if (controller.isLoading.value && controller.countries.isEmpty) return const Center(child: CircularProgressIndicator());
        if (controller.errorMessage.value != null && controller.countries.isEmpty) {
          return AsyncStateView(message: controller.errorMessage.value!, onRetry: () => controller.loadCountries(force: true));
        }
        final countries = controller.filteredCountries;
        if (countries.isEmpty) return AsyncStateView(message: 'Try another country name.', isEmpty: true, onRetry: () => controller.search(''));
        return RefreshIndicator(
          onRefresh: () => controller.loadCountries(force: true),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns, crossAxisSpacing: 12, mainAxisSpacing: 12,
              mainAxisExtent: 148,
            ),
            itemCount: countries.length,
            itemBuilder: (_, index) => _CountryCard(country: countries[index]),
          ),
        );
      })),
    ]);
  }
}

class _CountryCard extends StatelessWidget {
  final Country country;
  const _CountryCard({required this.country});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFDFBFF),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Get.to(() => CountryDetailPage(country: country)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFF1EDFF), Color(0xFFFFF0F5)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE1D9FF)),
            boxShadow: const [BoxShadow(color: Color(0x126C4DFF), blurRadius: 16, offset: Offset(0, 6))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 44, height: 44, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFFE9E4FF), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.public_rounded, color: Color(0xFF6C4DFF))),
              const Spacer(),
              Text(country.code, style: const TextStyle(color: Color(0xFF6C4DFF), fontWeight: FontWeight.w800, letterSpacing: 1)),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9B91B8)),
            ]),
            const Spacer(),
            Text(country.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            Text(country.capital ?? 'Capital not available', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6F6B86), fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}

class CountryDetailPage extends StatelessWidget {
  final Country country;
  const CountryDetailPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Country details')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 64, height: 64, decoration: BoxDecoration(color: const Color(0xFFE9E4FF), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.public_rounded, color: Color(0xFF6C4DFF), size: 34)),
                const SizedBox(height: 22),
                Text(country.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 22),
                _DetailRow(label: 'Country code', value: country.code),
                _DetailRow(label: 'Capital', value: country.capital ?? 'Not available'),
                _DetailRow(label: 'Continent', value: country.continent),
              ]),
            )),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF6F6B86)))), const SizedBox(width: 16), Flexible(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700))) ]),
  );
}
