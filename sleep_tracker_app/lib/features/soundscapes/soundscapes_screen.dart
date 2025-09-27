import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';

class SoundscapesScreen extends StatefulWidget {
  const SoundscapesScreen({Key? key}) : super(key: key);

  @override
  State<SoundscapesScreen> createState() => _SoundscapesScreenState();
}

class _SoundscapesScreenState extends State<SoundscapesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int selectedTabIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> recommended = [
    {
      'title': 'Mountain Serenity',
      'duration': '15 min',
      'rating': 4.8,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAZb8TCu9JQHwPpFpgiHfnYjng9Y2FI0YFEAQ7ur-xBKaWfYspFnvGgdyt9NgkwiJLveqH1dpibbhiEqaKKEHakXpVMb3WZFoPd7ZLszvMDG4GwvrCblWF-y_0SfQuHy1ESRmrBb942INYUk_KjmUKPomNKDaVjA2kYFWN9V5KAEj8rs8FneSLS0fi_vKSl09f6jduxW2yXLfKRFb7uItQ8_ex0e7yf9yHTTejdhZ5gO6NMvYyi286N_TBr_EmX9799tVxQCnQ70brR',
    },
    {
      'title': 'Forest Whispers',
      'duration': '20 min',
      'rating': 4.7,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASFlg45BeDZao7uxhTQoPPF2MFLvTvXPDL0nR0d23k1oOSxo5aWbuWrw63DyFsLHnfRr4midh1rgULWnzsQBglXPmQ1OjSpayacKbTqMaeYn4iu9sQ4-J68_nuzb239qkuUZ3r09lhBc728wqtH2PS6lj-kR1IcouCUeCrbexWVGMqK3xyAYFwkTUC8xtkY3zb2NNGJZUkmflnS-j0kiGTuIwsklQI-k1AOSQmJScp5oa9PSo0G0JvtBZz1lbNurKMyrbfhg0NkyQf',
    },
    {
      'title': 'Ocean Lullaby',
      'duration': '25 min',
      'rating': 4.9,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDRu1hBzH82Gs13ADsVsSrTelNq_W5Dncq8JTbRhVjVUzicJCyqTIztq9Fz-TEfxmidOvEJ7QogH0OMZqW9wUGsufLu7DNp6v-pDx8fTHhPgAauI91B2odxdcIdbKJUK62EDMIBqlHW84jCc2DDCAzAymdbRFf6bNI6Gdkk91Ct_-_KX8kpI1QAqog1ISLp7OCWZAcwynFBhcx-Np1Vo1BloUVvVPo3SGaM-R8w4Xr2D7vcdkHQPDPGZX3QeyZsLvEj3bufD03Z6evl',
    },
  ];

  final List<Map<String, dynamic>> meditations = [
    {
      'title': 'Body Scan',
      'duration': '12 min',
      'description': 'Deep relaxation technique',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKTmJ8bzKvGH5EWjvl3aBqFhUC61VFkGh6o5ZQrBq_qV-WDrxcRy8ScGxf53znC7gORISFRKJAXNviEQFxoH8mBj6_NYGMf_coGk4l2VKqwdh_gzf69Bx1-hQM0Gn0rdNHWZqJa7ep2F5IGN5RgBigxzKVbcmfefikKr5BWjDILevr37HLYs_iaZuCx8PdSem9qkvoVQzRuCQDA0O-zNgDUNqpfvXgh0KTPCYhSNXiuXmSQxEFvkP4ROSujMvZJnw8RAG9PUjN4Kxw',
    },
    {
      'title': 'Breathing',
      'duration': '8 min',
      'description': 'Mindful breathing practice',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAqaNHsEnh4MEwPQsjVZqQFFuFoQJWt8tfAZfOgyG7U7SXGLYtLmj4pIixSG_4TT9hv5MUUUVy3YJQ2AJYe1HD31gRDrE9QYDf5U2EgMEFu5bwtsqWNxaO3sAaLa48e76aL1_WZiCtm6DrLP96qmg1QZ0JUIbl3JOfZSgZL0LLzawp3L1IdQEeONQ5-sHehDqm1WDTOLldbrGbfFtq_s1pqnPQPVkKcbEZxJ4wNSe46e-8LciDeXrcqkh1f23IiNDfyWxeiwk0C-m9l',
    },
    {
      'title': 'Mindfulness',
      'duration': '15 min',
      'description': 'Present moment awareness',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuADBpnKsqc55E2sjDUQ5ZTcfg7kJosvruoPCPsEbh9q9qiRJr2BbmpeXScyEgqXLBJXf5FiQqHMne6Kh3L7JSirxsbUkCvmqvFg5CmzqUSwvrZ_X0-Ivv1L5RYD60m7Qiuv_TQ0EAEUvENJlXqqpMptS1zCcP8VpM5Ix4QfPAn07ddlXUk9H7xjVSdymd5uoiHgPMhGX0RuyUjMWEA8RJoct6Jhmt5NM3jHI79BiA96gRG3yUGPv9N7Xezgj4AJ67rELmmj56ucyzOK',
    },
    {
      'title': 'Sleep Stories',
      'duration': '30 min',
      'description': 'Bedtime narratives',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBteku_LV27bL6s3XKildg-OIWL9BnKlZaGmgDY6EHMV60FRwximeD1QWM1kaebSwI9S-HZeEvm9n44VWUbMGTMJHszF1UAyf_0ZzKBb2w_ux75D4Quj273ApjbwtJG7vkrJ-cl6UzoMl5o7_gNbKDCMJwjOn9UKGZrN3_spLqd29fjnvIPmE9Nz77HgPiP2BPy4MHAqqf7AkOcPjEc4o0HNILq9C62zebYGcjhTq1Sgbg8188PlOj7sWWeZq205SgDAQcfzdq0lp47',
    },
  ];

  final List<Map<String, dynamic>> favorites = [
    {
      'title': 'Night Sky',
      'duration': '30 min',
      'rating': 4.9,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBteku_LV27bL6s3XKildg-OIWL9BnKlZaGmgDY6EHMV60FRwximeD1QWM1kaebSwI9S-HZeEvm9n44VWUbMGTMJHszF1UAyf_0ZzKBb2w_ux75D4Quj273ApjbwtJG7vkrJ-cl6UzoMl5o7_gNbKDCMJwjOn9UKGZrN3_spLqd29fjnvIPmE9Nz77HgPiP2BPy4MHAqqf7AkOcPjEc4o0HNILq9C62zebYGcjhTq1Sgbg8188PlOj7sWWeZq205SgDAQcfzdq0lp47',
    },
    {
      'title': 'Gentle Rain',
      'duration': '18 min',
      'rating': 4.6,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDQ2MtI89wikalIzmlBIXyNHusavJsYlOHCvGslltVsY6cCwR0UioBFM7NsdlxJ42oG7vdzwFNYOz5nP4TCKbBzGJMfS70_ABu56hoS9ZXKG0ypffDejuCUW5J69TTZWxtzWN6pbiuHGfRANAhdRORqYGwuQ8DULdNn5EWYYWtNs-T1xUlxD_MhPwOqyUpyTpDPdEJXbm8wYKeKYh9xim1vTz1zRMSMlZiFgcIURj5c6KDu-PQqXEmeiae5fI2Il3tMoh4b9O2d_Z5L',
    },
    {
      'title': 'Cosmic Journey',
      'duration': '22 min',
      'rating': 4.8,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAZb8TCu9JQHwPpFpgiHfnYjng9Y2FI0YFEAQ7ur-xBKaWfYspFnvGgdyt9NgkwiJLveqH1dpibbhiEqaKKEHakXpVMb3WZFoPd7ZLszvMDG4GwvrCblWF-y_0SfQuHy1ESRmrBb942INYUk_KjmUKPomNKDaVjA2kYFWN9V5KAEj8rs8FneSLS0fi_vKSl09f6jduxW2yXLfKRFb7uItQ8_ex0e7yf9yHTTejdhZ5gO6NMvYyi286N_TBr_EmX9799tVxQCnQ70brR',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111121),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Soundscapes',
              showBackButton: false,
              showSearch: true,
              searchController: _searchController,
              searchHint: 'Search for sounds, meditations...',
              animated: false,
            ),
            _buildTabBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _buildRecommendedSection(),
                    const SizedBox(height: 12),
                    _buildMeditationsSection(),
                    const SizedBox(height: 12),
                    _buildFavoritesSection(),
                    const SizedBox(height: 80), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      {'name': 'Meditations', 'count': 25},
      {'name': 'ASMR', 'count': 18},
      {'name': 'Nature', 'count': 32},
      {'name': 'Binaural', 'count': 12},
      {'name': 'Stories', 'count': 15}
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = index == selectedTabIndex;

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => selectedTabIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey[300],
                      ),
                      child: Text(tab['name'] as String),
                    ),
                    const SizedBox(width: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey[400],
                        ),
                        child: Text('${tab['count']}'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recommended',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showAllRecommended();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommended.length,
              itemBuilder: (context, index) {
                final item = recommended[index];
                return _buildSoundCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundCard(Map<String, dynamic> item, int index) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.mediumImpact();
            // Play sound functionality
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 5,
                child: Hero(
                  tag: 'sound_${item['title']}_$index',
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            item['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Icon(Icons.music_note,
                                    color: Colors.grey, size: 40),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 11,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 3),
                          Text(
                            item['duration'],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.star,
                            size: 11,
                            color: Colors.amber[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item['rating']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Meditations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showAllMeditations();
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3.5,
            ),
            itemCount: meditations.length,
            itemBuilder: (context, index) {
              final item = meditations[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1a1a2e),
                      const Color(0xFF16213e).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Container(
                        width: 50,
                        height: double.infinity,
                        child: Image.network(
                          item['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(Icons.self_improvement,
                                  color: Colors.grey, size: 20),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                item['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item['duration'],
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Favorites',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showAllFavorites();
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[800],
                                      child: const Icon(Icons.music_note,
                                          color: Colors.grey, size: 40),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 11,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    item['duration'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.star,
                                    size: 11,
                                    color: Colors.amber[600],
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${item['rating']}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAllRecommended() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AllRecommendedSheet(),
    );
  }

  void _showAllMeditations() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AllMeditationsSheet(),
    );
  }

  void _showAllFavorites() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AllFavoritesSheet(),
    );
  }
}

// Recommended Tracks Bottom Sheet
class AllRecommendedSheet extends StatelessWidget {
  const AllRecommendedSheet({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> recommendedTracks = const [
    {
      'title': 'Ocean Waves',
      'duration': '25 min',
      'rating': 4.9,
      'category': 'Nature',
      'icon': Icons.waves,
    },
    {
      'title': 'Forest Rain',
      'duration': '45 min',
      'rating': 4.8,
      'category': 'Nature',
      'icon': Icons.forest,
    },
    {
      'title': 'Mountain Stream',
      'duration': '30 min',
      'rating': 4.7,
      'category': 'Nature',
      'icon': Icons.water,
    },
    {
      'title': 'Night Sky',
      'duration': '35 min',
      'rating': 4.8,
      'category': 'Ambient',
      'icon': Icons.nights_stay,
    },
    {
      'title': 'Gentle Breeze',
      'duration': '40 min',
      'rating': 4.9,
      'category': 'Nature',
      'icon': Icons.air,
    },
    {
      'title': 'Deep Cave',
      'duration': '20 min',
      'rating': 4.6,
      'category': 'Ambient',
      'icon': Icons.terrain,
    },
    {
      'title': 'Crackling Fire',
      'duration': '50 min',
      'rating': 4.5,
      'category': 'Cozy',
      'icon': Icons.local_fire_department,
    },
    {
      'title': 'Thunderstorm',
      'duration': '60 min',
      'rating': 4.7,
      'category': 'Nature',
      'icon': Icons.thunderstorm,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F23),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'All Recommended',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.7),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: recommendedTracks.length,
              itemBuilder: (context, index) {
                final track = recommendedTracks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Track Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryBlue.withOpacity(0.3),
                              AppTheme.sleepRem.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          track['icon'] as IconData,
                          color: AppTheme.primaryBlue,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Track Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              track['category'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  track['duration'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  track['rating'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Play Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Playing ${track['title']}...'),
                              backgroundColor: AppTheme.primaryBlue,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Meditations Bottom Sheet
class AllMeditationsSheet extends StatelessWidget {
  const AllMeditationsSheet({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> meditationTracks = const [
    {
      'title': 'Breathing Exercise',
      'duration': '5 min',
      'difficulty': 'Beginner',
      'icon': Icons.air,
    },
    {
      'title': 'Body Scan',
      'duration': '15 min',
      'difficulty': 'Intermediate',
      'icon': Icons.self_improvement,
    },
    {
      'title': 'Mindful Moments',
      'duration': '10 min',
      'difficulty': 'Beginner',
      'icon': Icons.psychology,
    },
    {
      'title': 'Deep Focus',
      'duration': '20 min',
      'difficulty': 'Advanced',
      'icon': Icons.center_focus_strong,
    },
    {
      'title': 'Loving Kindness',
      'duration': '12 min',
      'difficulty': 'Intermediate',
      'icon': Icons.favorite,
    },
    {
      'title': 'Sleep Preparation',
      'duration': '8 min',
      'difficulty': 'Beginner',
      'icon': Icons.bedtime,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F23),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Quick Meditations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.7),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: meditationTracks.length,
              itemBuilder: (context, index) {
                final meditation = meditationTracks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Meditation Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.sleepRem.withOpacity(0.3),
                              AppTheme.primaryBlue.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          meditation['icon'] as IconData,
                          color: AppTheme.sleepRem,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Meditation Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meditation['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meditation['difficulty'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  size: 16,
                                  color: Color(0xFF7B68EE),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  meditation['duration'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Start Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Starting ${meditation['title']}...'),
                              backgroundColor: AppTheme.sleepRem,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.sleepRem,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Favorites Bottom Sheet
class AllFavoritesSheet extends StatelessWidget {
  const AllFavoritesSheet({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> favoriteTracks = const [
    {
      'title': 'Ocean Lullaby',
      'duration': '25 min',
      'category': 'Nature',
      'playCount': 47,
      'icon': Icons.waves,
    },
    {
      'title': 'Forest Dreams',
      'duration': '45 min',
      'category': 'Nature',
      'playCount': 32,
      'icon': Icons.forest,
    },
    {
      'title': 'Peaceful Mind',
      'duration': '15 min',
      'category': 'Meditation',
      'playCount': 28,
      'icon': Icons.self_improvement,
    },
    {
      'title': 'Cozy Fireplace',
      'duration': '60 min',
      'category': 'Cozy',
      'playCount': 41,
      'icon': Icons.local_fire_department,
    },
    {
      'title': 'Mountain Breeze',
      'duration': '30 min',
      'category': 'Nature',
      'playCount': 35,
      'icon': Icons.air,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F23),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your Favorites',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.7),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: favoriteTracks.length,
              itemBuilder: (context, index) {
                final favorite = favoriteTracks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Favorite Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.withOpacity(0.3),
                              Colors.orange.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                favorite['icon'] as IconData,
                                color: Colors.amber,
                                size: 30,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Favorite Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              favorite['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              favorite['category'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  favorite['duration'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.play_circle,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${favorite['playCount']} plays',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Play Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Playing ${favorite['title']}...'),
                              backgroundColor: Colors.amber,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
