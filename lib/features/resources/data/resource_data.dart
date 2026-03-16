import 'package:flutter/material.dart';

class ResourceCategory {
  final String title;
  final IconData icon;
  final List<ResourceLink> links;

  const ResourceCategory({
    required this.title,
    required this.icon,
    required this.links,
  });
}

class ResourceLink {
  final String title;
  final String url;
  final bool isSearch;

  const ResourceLink({
    required this.title,
    required this.url,
    this.isSearch = false,
  });
}

class ResourceData {
  // Direct watch links should stay only when they have been verified recently.
  // Search links are more durable for topics where videos disappear over time.
  static const List<ResourceCategory> categories = [
    ResourceCategory(
      title: 'Core Jain Philosophy',
      icon: Icons.auto_awesome_rounded,
      links: [
        ResourceLink(
            title: 'Three Jewels (Ratnatraya) - Search',
            url:
                'https://www.youtube.com/results?search_query=Three+Jewels+of+Jainism+Ratnatraya',
            isSearch: true),
        ResourceLink(
            title: 'Five Great Vows (Mahavrata) - Search',
            url:
                'https://www.youtube.com/results?search_query=Five+Great+Vows+Mahavrata+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Anuvrata (Small Vows) - Search',
            url:
                'https://www.youtube.com/results?search_query=Anuvrata+Jainism+explained',
            isSearch: true),
      ],
    ),
    ResourceCategory(
      title: 'Ethical Practices',
      icon: Icons.spa_rounded,
      links: [
        ResourceLink(
            title: 'Ahimsa (In Thought, Speech, Action) - Search',
            url:
                'https://www.youtube.com/results?search_query=Ahimsa+thought+speech+action+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Ahimsa - Video',
            url: 'https://www.youtube.com/watch?v=pQrtHOF4V8k'),
        ResourceLink(
            title: 'Satya (Truthfulness) - Search',
            url:
                'https://www.youtube.com/results?search_query=Satya+truthfulness+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Asteya (Non-Stealing) - Search',
            url:
                'https://www.youtube.com/results?search_query=Asteya+non+stealing+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Brahmacharya (Self-Restraint) - Search',
            url:
                'https://www.youtube.com/results?search_query=Brahmacharya+Jainism+explained',
            isSearch: true),
        ResourceLink(
            title: 'Aparigraha (Non-Attachment) - Search',
            url:
                'https://www.youtube.com/results?search_query=Aparigraha+non+attachment+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Aparigraha - Video',
            url: 'https://www.youtube.com/watch?v=6PiQF6p8mV0'),
      ],
    ),
    ResourceCategory(
      title: 'Philosophy & Logic',
      icon: Icons.psychology_rounded,
      links: [
        ResourceLink(
            title: 'Anekantavada (Many-Sided Reality) - Search',
            url:
                'https://www.youtube.com/results?search_query=Anekantavada+Jainism+explained',
            isSearch: true),
        ResourceLink(
            title: 'Syadvada (Conditional Truth) - Search',
            url:
                'https://www.youtube.com/results?search_query=Syadvada+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Nayavada (Viewpoints) - Search',
            url:
                'https://www.youtube.com/results?search_query=Nayavada+Jainism+explained',
            isSearch: true),
      ],
    ),
    ResourceCategory(
      title: 'Karma & Soul Science',
      icon: Icons.change_circle_rounded,
      links: [
        ResourceLink(
            title: 'Nav Tattva (Nine Realities) - Search',
            url:
                'https://www.youtube.com/results?search_query=Nav+Tattva+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Eight Types of Karma - Search',
            url:
                'https://www.youtube.com/results?search_query=Eight+types+of+karma+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Eight Types of Karma - Video',
            url: 'https://www.youtube.com/watch?v=OtMIHUiwaTk'),
        ResourceLink(
            title: 'Leshya (Inner Colorations) - Search',
            url: 'https://www.youtube.com/results?search_query=Leshya+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Samvara (Stoppage of Karma) - Search',
            url: 'https://www.youtube.com/results?search_query=Samvara+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Nirjara (Shedding Karma) - Search',
            url: 'https://www.youtube.com/results?search_query=Nirjara+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Moksha (Liberation) - Search',
            url:
                'https://www.youtube.com/results?search_query=Moksha+in+Jainism+explained',
            isSearch: true),
        ResourceLink(
            title: 'Moksha - Video',
            url: 'https://www.youtube.com/watch?v=lamJiG-2BTM'),
      ],
    ),
    ResourceCategory(
      title: 'Discipline & Practice',
      icon: Icons.self_improvement_rounded,
      links: [
        ResourceLink(
            title: 'Gupti (Three Controls) - Search',
            url:
                'https://www.youtube.com/results?search_query=Gupti+three+controls+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Samiti (Careful Conduct) - Search',
            url: 'https://www.youtube.com/results?search_query=Samiti+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Tapas (Austerity) - Search',
            url:
                'https://www.youtube.com/results?search_query=Tapas+austerity+Jainism',
            isSearch: true),
      ],
    ),
    ResourceCategory(
      title: 'Rituals & Observances',
      icon: Icons.event_rounded,
      links: [
        ResourceLink(
            title: 'Paryushan (Renewal) - Search',
            url:
                'https://www.youtube.com/results?search_query=Paryushan+festival+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Paryushan - Video',
            url: 'https://www.youtube.com/watch?v=78JE5FLf-yU'),
        ResourceLink(
            title: 'Samayik (Equanimity) - Search',
            url:
                'https://www.youtube.com/results?search_query=Samayik+Jainism+explained',
            isSearch: true),
        ResourceLink(
            title: 'Pratikraman (Self-Review) - Search',
            url:
                'https://www.youtube.com/results?search_query=Pratikraman+Jainism',
            isSearch: true),
      ],
    ),
    ResourceCategory(
      title: 'Cosmology & Supreme Beings',
      icon: Icons.public_rounded,
      links: [
        ResourceLink(
            title: 'Jain Cosmology (Loka) - Search',
            url:
                'https://www.youtube.com/results?search_query=Jain+Cosmology+Loka',
            isSearch: true),
        ResourceLink(
            title: 'Jain Cosmology - Video',
            url: 'https://www.youtube.com/watch?v=kqXJCWAF04E'),
        ResourceLink(
            title: 'Pancha Parameshti - Search',
            url:
                'https://www.youtube.com/results?search_query=Pancha+Parameshti+Jainism',
            isSearch: true),
        ResourceLink(
            title: 'Pancha Parameshti - Video',
            url: 'https://www.youtube.com/watch?v=T3fjJR2o9WY'),
      ],
    ),
  ];
}
