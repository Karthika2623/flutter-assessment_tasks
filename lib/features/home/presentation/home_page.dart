import 'package:flutter/material.dart';
import '../../countries/presentation/country_page.dart';
import '../../users/presentation/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;
    final pages = const [CountryPage(), UserPage()];
    return Scaffold(
      body: SafeArea(
        child: Row(children: [
          if (isWide) _DesktopRail(selectedIndex: _selectedIndex, onSelect: (value) => setState(() => _selectedIndex = value)),
          Expanded(child: Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(width < 600 ? 20 : 28, 18, width < 600 ? 20 : 28, 18),
              child: Row(children: [
                Container(width: 46, height: 46, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6C4DFF), Color(0xFFFF6B8A)]), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.explore_rounded, color: Colors.white, size: 26)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Assessment Tasks', style: TextStyle(fontSize: 11, letterSpacing: 1.7, color: const Color(0xFF6F6B86), fontWeight: FontWeight.w800)),
                  Text(_selectedIndex == 0 ? 'Discover the world' : 'People directory', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF292044))),
                ])),
                if (width >= 500) const _LiveBadge(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: const Color(0xFFE9E3FF), borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  _TabButton(label: 'Countries', icon: Icons.public_rounded, selected: _selectedIndex == 0, onTap: () => setState(() => _selectedIndex = 0)),
                  _TabButton(label: 'Users', icon: Icons.people_alt_rounded, selected: _selectedIndex == 1, onTap: () => setState(() => _selectedIndex = 1)),
                ]),
              ),
            ),
            Expanded(child: IndexedStack(index: _selectedIndex, children: pages)),
            
          ])),
        ]),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.icon, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(child: InkWell(
    borderRadius: BorderRadius.circular(12), onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(color: selected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: selected ? [const BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, 2))] : []),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 18, color: selected ? const Color(0xFF6C4DFF) : const Color(0xFF6F6B86)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: selected ? const Color(0xFF44346D) : const Color(0xFF6F6B86))),
      ]),
    ),
  ));
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: const Color(0xFFDDF8F1), borderRadius: BorderRadius.circular(30)),
    child: const Row(children: [Icon(Icons.circle, size: 7, color: Color(0xFF0F9F8F)), SizedBox(width: 7), Text('API CONNECTED', style: TextStyle(fontSize: 10, letterSpacing: .6, color: Color(0xFF087F70), fontWeight: FontWeight.w900))]),
  );
}

class _DesktopRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const _DesktopRail({required this.selectedIndex, required this.onSelect});
  @override
  Widget build(BuildContext context) => Container(
    width: 88,
    margin: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFF292044), borderRadius: BorderRadius.circular(24)),
    child: Column(children: [
      const SizedBox(height: 24),
      const Icon(Icons.explore_rounded, color: Colors.white, size: 30),
      const SizedBox(height: 40),
      _RailButton(icon: Icons.public_rounded, selected: selectedIndex == 0, onTap: () => onSelect(0)),
      const SizedBox(height: 14),
      _RailButton(icon: Icons.people_alt_rounded, selected: selectedIndex == 1, onTap: () => onSelect(1)),
      const Spacer(),
      const Padding(padding: EdgeInsets.only(bottom: 22), child: Icon(Icons.auto_awesome_rounded, color: Color(0xFFB5A9D8))),
    ]),
  );
}

class _RailButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _RailButton({required this.icon, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onTap,
    style: IconButton.styleFrom(backgroundColor: selected ? const Color(0xFF6C4DFF) : Colors.transparent, foregroundColor: selected ? Colors.white : const Color(0xFFC3B9E0), padding: const EdgeInsets.all(16)),
    icon: Icon(icon),
  );
}
