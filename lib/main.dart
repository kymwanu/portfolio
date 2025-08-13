import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  ThemeMode _mode = ThemeMode.dark; // dark por padrão

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portfólio Flutter',
      themeMode: _mode,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF8E96FF),
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark(useMaterial3: true).textTheme,
        ),
      ),
      home: HomePage(
        onToggleTheme: () => setState(() {
          _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
        isDark: _mode == ThemeMode.dark,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });
  final VoidCallback onToggleTheme;
  final bool isDark;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _aboutKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _experiencesKey = GlobalKey();
  final _contactKey = GlobalKey();

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Portfolio',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          _NavButton(text: 'Sobre', onTap: () => _scrollTo(_aboutKey)),
          _NavButton(text: 'Projetos', onTap: () => _scrollTo(_projectsKey)),
          _NavButton(text: 'Experiências', onTap: () => _scrollTo(_contactKey)),

          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _HeroSection(isMobile: isMobile),
            _Section(
              key: _aboutKey,
              title: 'Sobre mim',
              child: _AboutSection(isMobile: isMobile),
            ),
            _Section(
              key: _projectsKey,
              title: 'Projetos',
              child: _ProjectsGrid(isMobile: isMobile),
            ),
            _Section(
              key: _experiencesKey,
              title: 'Experiências',
              child: _ExperiencesGrid(isMobile: isMobile),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(onPressed: onTap, child: Text(text)),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text('Olá, eu sou', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Kimuano Luis',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: DefaultTextStyle(
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        pause: const Duration(milliseconds: 900),
                        animatedTexts: [
                          TyperAnimatedText('Desenvolvedor Flutter'),
                          TyperAnimatedText('Android • iOS • Web'),
                          TyperAnimatedText('Clean Architecture & GetX/BLoC'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Apaixonado por criar apps performáticos com excelente UX,\n'
                    'integrando Firebase, APIs REST, autenticação e notificações.',
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _LinkButton(
                        label: 'GitHub',
                        icon: Icons.code,
                        url: 'https://github.com/kymwanu',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!isMobile) const SizedBox(width: 32),
            if (!isMobile) const _Avatar(),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/me.jpg',
        width: 260,
        height: 260,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(
          width: 260,
          height: 260,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        SizedBox(
          width: isMobile ? double.infinity : 560,
          child: Text(
            'Sou desenvolvedor Flutter com experiência em Android, iOS e Web.\n'
            'Trabalho com Firebase (Auth, Firestore, Storage, FCM), Nodejs, Javascript e Python.\n'
            'Sou desenvolvedor Flutter com experiência em Android, iOS e Web, Firebase (Auth, Firestore, Storage, FCM), integração de APIs REST e GraphQL, '
            'utilizo padrões como Clean Architecture e gerenciamento de estado com GetX e BLoC.\n'
            'Tenho foco em criar aplicativos performáticos, responsivos e com excelente experiência do usuário.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
        ),
        //if (!isMobile) const _Avatar(),
      ],
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.label,
    required this.icon,
    required this.url,
  });
  final String label;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        // Usa url_launcher
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': '\nangola province picker',

        'description':
            '\nUm pacote publicado no pub.dev com mais e 200 downloads. Seletor de províncias de Angola simples, leve e personalizável para aplicativos Flutter. \n'
            'Ideal para formulários, cadastros e endereços.',
        'url': 'https://github.com/kymwanu/angola_province_picker',
      },
      {
        'title': '\ndemo_project',
        'description':
            '\nEste projeto é um aplicativo Flutter multiplataforma, com foco em navegação por abas, exibição de produtos e categorias, e interface visual customizada. Ele serve como base para diversas aplicações.',
        'url': 'https://github.com/kymwanu/demo_project',
      },
      {
        'title': '\nlive-tracking',
        'description':
            '\nÉ um recurso usado para acompanhar a localização, o status ou o progresso de algo de qualquer meio ou item de forma instantânea e contínua',
        'url': 'https://github.com/kymwanu/live-tracking',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title']!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(project['description']!),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(project['url']!))) {
                      await launchUrl(Uri.parse(project['url']!));
                    }
                  },
                  child: const Text('Ver no GitHub'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExperiencesGrid extends StatelessWidget {
  const _ExperiencesGrid({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> experiences = [
      {
        'title': 'Desenvolvedor Flutter – K SOLID',
        'activities': [
          'Desenvolvi um sistema de reações e animações com sincronização em tempo real afim de aumentar o engajamento',
          'Implementei notificações push usando FCM , desenvolvi um sistema de notificações segmentadas por tópicos e otimizei a entrega de notificações em segundo plano.',
          'Implementei o login com o Google usando o Firebase Auth.',
          'Integração com APIs REST e colaboração com equipes de design e QA.',
        ],
      },
      {
        'title': 'Desenvolvedor Frontend – CODE LOOPS',
        'activities': [
          'Desenvolvi telas com Vue.js 3 (Composition API), demonstrando reatividade, componentização e persistência via localStorage',
          'Melhorar o desempenho do aplicativo, corrigir erros e garantir a qualidade do código com testes, usando o pacote test',
          'Integração com REST API (http/dio) , conectar o aplicativo a serviços do backend.',
          'Implementei filtros (todas/ativas/concluídas) e dark mode, destacando habilidades em UX e state management.',
        ],
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final exp = experiences[index];

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 600 + (index * 200)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 20), // Slide para cima
                child: child,
              ),
            );
          },
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da experiência
                  SizedBox(height: 10),
                  Text(
                    exp['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Lista de atividades
                  ...(exp['activities'] as List<String>).map((activity) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              activity,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
