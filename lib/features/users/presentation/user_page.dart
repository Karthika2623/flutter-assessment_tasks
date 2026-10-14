import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/async_state_view.dart';
import '../data/post_model.dart';
import '../data/user_model.dart';
import 'user_controller.dart';

class UserPage extends GetView<UserController> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1000 ? 3 : width >= 650 ? 2 : 1;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: TextField(onChanged: controller.search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Search users by name')),
      ),
      Expanded(child: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) return const Center(child: CircularProgressIndicator());
        if (controller.errorMessage.value != null && controller.users.isEmpty) {
          return AsyncStateView(message: controller.errorMessage.value!, onRetry: () => controller.loadUsers(force: true));
        }
        final users = controller.filteredUsers;
        if (users.isEmpty) return AsyncStateView(message: 'Try a different name.', isEmpty: true, onRetry: () => controller.search(''));
        return RefreshIndicator(
          onRefresh: () => controller.loadUsers(force: true),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 12, mainAxisSpacing: 12, mainAxisExtent: 176),
            itemCount: users.length,
            itemBuilder: (_, index) => _UserCard(user: users[index]),
          ),
        );
      })),
    ]);
  }
}

class _UserCard extends StatelessWidget {
  final AppUser user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final initials = user.name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).take(2).map((e) => e[0]).join().toUpperCase();
    return Material(
      color: const Color(0xFFFCFFFE), borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Get.to(() => UserDetailPage(user: user)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFEAFBF7), Color(0xFFF1EDFF)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD9EEE9)),
            boxShadow: const [BoxShadow(color: Color(0x120F9F8F), blurRadius: 16, offset: Offset(0, 6))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 23, backgroundColor: const Color(0xFFDDF8F1), child: Text(initials.isEmpty ? '?' : initials, style: const TextStyle(color: Color(0xFF0F9F8F), fontWeight: FontWeight.w800))),
              const SizedBox(width: 12),
              Expanded(child: Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9B91B8)),
            ]),
            const SizedBox(height: 15),
            Row(children: [const Icon(Icons.mail_outline_rounded, size: 16, color: Color(0xFF6F6B86)), const SizedBox(width: 8), Expanded(child: Text(user.email, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6F6B86), fontSize: 12)))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.business_outlined, size: 16, color: Color(0xFF6F6B86)), const SizedBox(width: 8), Expanded(child: Text(user.company, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6F6B86), fontSize: 12)))]),
          ]),
        ),
      ),
    );
  }
}

class UserDetailPage extends StatefulWidget {
  final AppUser user;
  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future<List<UserPost>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = Get.find<UserController>().loadPosts(widget.user.id);
  }

  void _retry() => setState(() => _postsFuture = Get.find<UserController>().loadPosts(widget.user.id));

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text('User profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(padding: EdgeInsets.all(width < 600 ? 18 : 28), children: [
            Card(child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(radius: 30, backgroundColor: const Color(0xFFDDF8F1), child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 24, color: Color(0xFF0F9F8F), fontWeight: FontWeight.w800))),
                const SizedBox(height: 16),
                Text(user.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 18),
                _InfoRow(icon: Icons.mail_outline_rounded, label: 'Email', value: user.email),
                _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: user.phone),
                _InfoRow(icon: Icons.business_outlined, label: 'Company', value: user.company),
              ]),
            )),
            const SizedBox(height: 26),
            Text('Recent posts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            FutureBuilder<List<UserPost>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator()));
                if (snapshot.hasError) return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [const Text('Could not load posts.'), const SizedBox(height: 10), TextButton.icon(onPressed: _retry, icon: const Icon(Icons.refresh), label: const Text('Retry'))])));
                final posts = snapshot.data ?? [];
                if (posts.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('No posts available for this user.')));
                return Column(children: posts.map((post) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(post.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(post.body, style: const TextStyle(color: Color(0xFF6F6B86), height: 1.45)),
                  ]))),
                )).toList());
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 20, color: const Color(0xFF6C4DFF)),
      const SizedBox(width: 12),
      SizedBox(width: 76, child: Text(label, style: const TextStyle(color: Color(0xFF6F6B86)))),
      Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
    ]),
  );
}
