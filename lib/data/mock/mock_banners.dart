class PromoBanner {
  final String id;
  final String title;
  final String titleHindi;
  final String subtitle;
  final String tag;
  final String ctaText;
  final String type; // 'emergency', 'offer', 'maintenance'

  const PromoBanner({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.subtitle,
    required this.tag,
    required this.ctaText,
    required this.type,
  });
}

final List<PromoBanner> mockBanners = [
  const PromoBanner(
    id: 'b1',
    title: '24/7 Emergency Electrical Breakdown',
    titleHindi: 'आपातकालीन सेवा (24x7 उपलब्ध)',
    subtitle: 'Short circuit, sparking or sudden blackout? Electrician reaches in 30 mins.',
    tag: 'RAPID RESPONSE',
    ctaText: 'Call Now',
    type: 'emergency',
  ),
  const PromoBanner(
    id: 'b2',
    title: 'New House Wiring Special Package',
    titleHindi: 'नए मकान की वायरिंग पर विशेष छूट',
    subtitle: 'Concealed piping, modular switchboards & free earthing setup by certified electricians.',
    tag: 'BEST VALUE',
    ctaText: 'Get Quote',
    type: 'offer',
  ),
  const PromoBanner(
    id: 'b3',
    title: 'Summer AC Jet Wash & Gas Service',
    titleHindi: 'एसी जेट सर्विस व गैस रीफिल',
    subtitle: 'Boost cooling by 40% & reduce electricity bills with high-pressure deep cleaning.',
    tag: 'SEASONAL',
    ctaText: 'Book AC Service',
    type: 'maintenance',
  ),
];
