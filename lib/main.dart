import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const SarfAmoozApp());

class SarfAmoozApp extends StatelessWidget {
  const SarfAmoozApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صرف‌آموز عربی',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3657A7),
          primary: const Color(0xFF3657A7),
          secondary: const Color(0xFFE58B45),
          surface: const Color(0xFFFFFCF7),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F3FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3657A7),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class AppStats {
  static int exams = 0;
  static int correct = 0;
  static int answered = 0;
  static final List<String> mistakes = [];
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem('آموزش فعل ماضی', '۱۴ صیغه، ضمایر و روش ساخت', Icons.history, () => _go(context, const LessonPage(kind: LessonKind.mazi))),
      _MenuItem('آموزش فعل مضارع', 'حروف مضارعه و ۱۴ صیغه', Icons.autorenew, () => _go(context, const LessonPage(kind: LessonKind.mozare))),
      _MenuItem('آموزش فعل مستقبل', 'ساخت آینده با سَـ و سوف', Icons.upcoming, () => _go(context, const LessonPage(kind: LessonKind.future))),
      _MenuItem('فعل امر و نهی', '۶ صیغه امر و ۶ صیغه نهی', Icons.record_voice_over, () => _go(context, const LessonPage(kind: LessonKind.amr))),
      _MenuItem('تمرین جدول چهارگزینه‌ای', 'تکمیل ضمیر و فعل ماضی یا مضارع', Icons.grid_on, () => _go(context, const TablePracticePage())),
      _MenuItem('تمرین', 'تمرین ضمیر، زمان و تبدیل فعل', Icons.edit_note, () => _go(context, const PracticePage())),
      _MenuItem('آزمون', 'سؤال تصادفی و زمان‌دار', Icons.timer_outlined, () => _go(context, const ExamPage())),
      _MenuItem('صرف فعل دلخواه', 'ورود ریشه سه‌حرفی بدون حرکت', Icons.spellcheck, () => _go(context, const CustomVerbPage())),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F3FA),
        appBar: AppBar(title: const Text('صرف‌آموز عربی'), centerTitle: true, backgroundColor: const Color(0xFF3657A7), foregroundColor: Colors.white,
          actions: [IconButton(tooltip: 'درباره برنامه', onPressed: () => _go(context, const AboutPage()), icon: const Icon(Icons.info_outline))]),
        body: Column(children: [
          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF293F82), Color(0xFF5878C8), Color(0xFF8A6FC0)]), borderRadius: BorderRadius.circular(20)),
              child: const Column(children: [Icon(Icons.menu_book_rounded, color: Colors.white, size: 46), SizedBox(height: 8), Text('آموزش صرف افعال عربی', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text('ویژه پایه‌های هفتم، هشتم و نهم', style: TextStyle(color: Colors.white, fontSize: 15))])),
            const SizedBox(height: 16),
            ...items.map((item) => Card(elevation: 1, margin: const EdgeInsets.only(bottom: 9), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), leading: CircleAvatar(backgroundColor: const Color(0xFFE1F2EF), child: Icon(item.icon, color: const Color(0xFF3657A7))), title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), subtitle: Text(item.subtitle), trailing: const Icon(Icons.chevron_left), onTap: item.onTap))),
          ])),
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10), color: const Color(0xFFECEBFA), child: const Column(children: [Text('HAKnet', style: TextStyle(color: Color(0xFF3657A7), fontSize: 19, fontWeight: FontWeight.bold)), SizedBox(height: 2), Text('نسخه 1.0.0', style: TextStyle(color: Colors.black54, fontSize: 12))]))
        ]),
      ),
    );
  }
  void _go(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

class _MenuItem {
  final String title, subtitle; final IconData icon; final VoidCallback onTap;
  _MenuItem(this.title, this.subtitle, this.icon, this.onTap);
}

enum LessonKind { mazi, mozare, future, amr }

class LessonPage extends StatelessWidget {
  final LessonKind kind;
  const LessonPage({super.key, required this.kind});
  String get title => switch (kind) {
    LessonKind.mazi => 'آموزش فعل ماضی',
    LessonKind.mozare => 'آموزش فعل مضارع',
    LessonKind.future => 'آموزش فعل مستقبل',
    LessonKind.amr => 'آموزش فعل امر و نهی',
  };
  @override
  Widget build(BuildContext context) {
    final mazi = kind == LessonKind.mazi;
    final mozare = kind == LessonKind.mozare;
    final future = kind == LessonKind.future;
    final rows = mazi
        ? VerbExamples.mazi
        : mozare
            ? VerbExamples.mozare
            : future
                ? VerbExamples.future
                : VerbExamples.amr;
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(14), children: [
      _InfoCard(
        title: mazi ? 'فعل ماضی' : mozare ? 'فعل مضارع' : future ? 'فعل مستقبل' : 'امر و نهی',
        text: mazi
            ? 'فعل ماضی بر انجام کار در گذشته دلالت می‌کند. برای نمونه: كَتَبَ یعنی نوشت.'
            : mozare
                ? 'فعل مضارع بر انجام کار در زمان حال دلالت می‌کند. برای نمونه: يَكْتُبُ یعنی می‌نویسد.'
                : future
                    ? 'برای بیان آینده می‌توان «سَـ» را به ابتدای فعل مضارع افزود یا از «سَوْفَ» پیش از فعل مضارع استفاده کرد؛ مانند سَيَكْتُبُ و سَوْفَ يَكْتُبُ.'
                    : 'امر برای درخواست انجام کار و نهی برای درخواست ترک کار به‌کار می‌رود. هرکدام در این آموزش ۶ صیغه مخاطب دارند.',
      ),
      if (mozare || future) const _InfoCard(title: 'حروف مضارعه', text: 'حروف مضارعه عبارت‌اند از: أ، ن، ي، ت. در فعل مستقبل نیز ساخت اصلی فعل، مضارع است و نشانه آینده به آن افزوده می‌شود.'),
      if (mazi) const _InfoCard(title: 'روش ساخت', text: 'در فعل ماضی، شناسه‌ها به پایان بن فعل افزوده می‌شوند. شناسه هر ضمیر را در جدول مشاهده کنید.'),
      if (kind == LessonKind.amr) const _InfoCard(title: 'روش ساخت', text: 'امر و نهی فقط برای شش صیغه مخاطب ساخته می‌شوند. نهی با «لا»ی نهی و فعل مضارع مجزوم ساخته می‌شود.'),
      const SizedBox(height: 8), Text(mazi ? 'جدول ۱۴ صیغه ماضی «كَتَبَ»' : mozare ? 'جدول ۱۴ صیغه مضارع «يَكْتُبُ»' : future ? 'جدول ۱۴ صیغه مستقبل «سَيَكْتُبُ»' : 'جدول امر و نهی فعل «كَتَبَ»', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), _VerbTable(rows: rows),
      const SizedBox(height: 12), const Text('نمونه آموزشی با فعل «كتب». برای فعل‌های دیگر، شکل درست فعل و قواعد آن باید بررسی شود.', style: TextStyle(color: Colors.black54, fontSize: 12)),
    ])));
  }
}

class VerbExamples {
  static const List<List<String>> mazi = [
    ['ضمیر', 'فعل', 'معنی'], ['هُوَ', 'كَتَبَ', 'او مرد نوشت'], ['هُما', 'كَتَبا', 'آن دو مرد نوشتند'], ['هُمْ', 'كَتَبُوا', 'آن مردان نوشتند'], ['هِيَ', 'كَتَبَتْ', 'او زن نوشت'], ['هُما', 'كَتَبَتا', 'آن دو زن نوشتند'], ['هُنَّ', 'كَتَبْنَ', 'آن زنان نوشتند'], ['أَنْتَ', 'كَتَبْتَ', 'تو مرد نوشتی'], ['أَنْتُما', 'كَتَبْتُما', 'شما دو نفر نوشتید'], ['أَنْتُمْ', 'كَتَبْتُمْ', 'شما مردان نوشتید'], ['أَنْتِ', 'كَتَبْتِ', 'تو زن نوشتی'], ['أَنْتُما', 'كَتَبْتُما', 'شما دو نفر نوشتید'], ['أَنْتُنَّ', 'كَتَبْتُنَّ', 'شما زنان نوشتید'], ['أَنا', 'كَتَبْتُ', 'من نوشتم'], ['نَحْنُ', 'كَتَبْنا', 'ما نوشتیم'],
  ];
  static const List<List<String>> mozare = [
    ['ضمیر', 'فعل', 'معنی'], ['هُوَ', 'يَكْتُبُ', 'او مرد می‌نویسد'], ['هُما', 'يَكْتُبانِ', 'آن دو مرد می‌نویسند'], ['هُمْ', 'يَكْتُبُونَ', 'آن مردان می‌نویسند'], ['هِيَ', 'تَكْتُبُ', 'او زن می‌نویسد'], ['هُما', 'تَكْتُبانِ', 'آن دو زن می‌نویسند'], ['هُنَّ', 'يَكْتُبْنَ', 'آن زنان می‌نویسند'], ['أَنْتَ', 'تَكْتُبُ', 'تو مرد می‌نویسی'], ['أَنْتُما', 'تَكْتُبانِ', 'شما دو نفر می‌نویسید'], ['أَنْتُمْ', 'تَكْتُبُونَ', 'شما مردان می‌نویسید'], ['أَنْتِ', 'تَكْتُبِينَ', 'تو زن می‌نویسی'], ['أَنْتُما', 'تَكْتُبانِ', 'شما دو نفر می‌نویسید'], ['أَنْتُنَّ', 'تَكْتُبْنَ', 'شما زنان می‌نویسید'], ['أَنا', 'أَكْتُبُ', 'من می‌نویسم'], ['نَحْنُ', 'نَكْتُبُ', 'ما می‌نویسیم'],
  ];
  static const List<List<String>> future = [
    ['ضمیر', 'فعل مستقبل', 'معنی'],
    ['هُوَ', 'سَيَكْتُبُ', 'او مرد خواهد نوشت'],
    ['هُما', 'سَيَكْتُبانِ', 'آن دو مرد خواهند نوشت'],
    ['هُمْ', 'سَيَكْتُبُونَ', 'آن مردان خواهند نوشت'],
    ['هِيَ', 'سَتَكْتُبُ', 'او زن خواهد نوشت'],
    ['هُما', 'سَتَكْتُبانِ', 'آن دو زن خواهند نوشت'],
    ['هُنَّ', 'سَيَكْتُبْنَ', 'آن زنان خواهند نوشت'],
    ['أَنْتَ', 'سَتَكْتُبُ', 'تو مرد خواهی نوشت'],
    ['أَنْتُما', 'سَتَكْتُبانِ', 'شما دو نفر خواهید نوشت'],
    ['أَنْتُمْ', 'سَتَكْتُبُونَ', 'شما مردان خواهید نوشت'],
    ['أَنْتِ', 'سَتَكْتُبِينَ', 'تو زن خواهی نوشت'],
    ['أَنْتُما', 'سَتَكْتُبانِ', 'شما دو نفر خواهید نوشت'],
    ['أَنْتُنَّ', 'سَتَكْتُبْنَ', 'شما زنان خواهید نوشت'],
    ['أَنا', 'سَأَكْتُبُ', 'من خواهم نوشت'],
    ['نَحْنُ', 'سَنَكْتُبُ', 'ما خواهیم نوشت'],
  ];
  static const List<List<String>> amr = [
    ['ضمیر مخاطب', 'امر', 'نهی'], ['أَنْتَ', 'اُكْتُبْ', 'لا تَكْتُبْ'], ['أَنْتُما (مذکر)', 'اُكْتُبا', 'لا تَكْتُبا'], ['أَنْتُمْ', 'اُكْتُبُوا', 'لا تَكْتُبُوا'], ['أَنْتِ', 'اُكْتُبِي', 'لا تَكْتُبِي'], ['أَنْتُما (مؤنث)', 'اُكْتُبا', 'لا تَكْتُبَا'], ['أَنْتُنَّ', 'اُكْتُبْنَ', 'لا تَكْتُبْنَ'],
  ];
}

class _VerbTable extends StatelessWidget {
  final List<List<String>> rows;
  const _VerbTable({required this.rows});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(headingRowColor: WidgetStateProperty.all(const Color(0xFFE1F2EF)), columns: rows.first.map((e) => DataColumn(label: Text(e, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(), rows: rows.skip(1).map((r) => DataRow(cells: r.map((e) => DataCell(Text(e))).toList())).toList()));
}

class _InfoCard extends StatelessWidget {
  final String title, text;
  const _InfoCard({required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Card(color: Colors.white, child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3657A7))), const SizedBox(height: 7), Text(text, style: const TextStyle(height: 1.7))])));
}

class CustomVerbPage extends StatefulWidget {
  const CustomVerbPage({super.key});
  @override
  State<CustomVerbPage> createState() => _CustomVerbPageState();
}

class _CustomVerbPageState extends State<CustomVerbPage> {
  final rootController = TextEditingController();
  final pastController = TextEditingController();
  final presentController = TextEditingController();
  List<List<String>>? rows;
  String message = '';

  static const pronouns = [
    'هُوَ', 'هُما (مذکر)', 'هُمْ', 'هِيَ', 'هُما (مؤنث)', 'هُنَّ',
    'أَنْتَ', 'أَنْتُما (مذکر)', 'أَنْتُمْ', 'أَنْتِ', 'أَنْتُما (مؤنث)',
    'أَنْتُنَّ', 'أَنا', 'نَحْنُ',
  ];

  String _withoutLastMark(String value, String mark) =>
      value.endsWith(mark) ? value.substring(0, value.length - mark.length) : value;

  void buildTable() {
    final root = rootController.text.trim().replaceAll(' ', '');
    final past = pastController.text.trim();
    final present = presentController.text.trim();
    if (root.isEmpty || past.isEmpty || present.isEmpty) {
      setState(() { message = 'ریشه، ماضی هُوَ و مضارع هُوَ را وارد کنید.'; rows = null; });
      return;
    }
    if (!present.startsWith('يَ') || !past.endsWith('َ') || !present.endsWith('ُ')) {
      setState(() { message = 'نمونه‌ها را با حرکت وارد کنید؛ مانند كَتَبَ و يَكْتُبُ.'; rows = null; });
      return;
    }
    final pastStem = _withoutLastMark(past, 'َ');
    final presentStem = _withoutLastMark(present.substring(2), 'ُ');
    final p = <String>[
      '$past', '${pastStem}َا', '${pastStem}ُوا', '${pastStem}َتْ', '${pastStem}َتا', '${pastStem}ْنَ',
      '${pastStem}ْتَ', '${pastStem}ْتُما', '${pastStem}ْتُمْ', '${pastStem}ْتِ', '${pastStem}ْتُما', '${pastStem}ْتُنَّ', '${pastStem}ْتُ', '${pastStem}ْنا',
    ];
    final b = presentStem;
    final m = <String>[
      'يَ${b}ُ', 'يَ${b}َانِ', 'يَ${b}ُونَ', 'تَ${b}ُ', 'تَ${b}َانِ', 'يَ${b}ْنَ',
      'تَ${b}ُ', 'تَ${b}َانِ', 'تَ${b}ُونَ', 'تَ${b}ِينَ', 'تَ${b}َانِ', 'تَ${b}ْنَ', 'أَ${b}ُ', 'نَ${b}ُ',
    ];
    setState(() {
      rows = [
        ['ضمیر', 'ماضی', 'مضارع'],
        for (var i = 0; i < 14; i++) [pronouns[i], p[i], m[i]],
      ];
      message = 'جدول ساخته شد. برای دقت، شکل ماضی و مضارع هُوَ را با حرکت صحیح وارد کنید.';
    });
  }

  @override
  void dispose() {
    rootController.dispose(); pastController.dispose(); presentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('ساخت جدول فعل دلخواه')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const _InfoCard(title: 'ساخت جدول برای فعل دلخواه', text: 'ریشه و دو صورت پایه فعل را وارد کنید: ماضی هُوَ و مضارع هُوَ. برنامه بر اساس این دو صورت، ۱۴ صیغه ماضی و مضارع و جدول مستقبل را می‌سازد. حرکت‌گذاری دو صورت پایه ضروری است.'),
        const SizedBox(height: 12),
        TextField(controller: rootController, textAlign: TextAlign.center, decoration: const InputDecoration(labelText: 'ریشه سه‌حرفی', hintText: 'كتب', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: pastController, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23), decoration: const InputDecoration(labelText: 'ماضی هُوَ با حرکت', hintText: 'كَتَبَ', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: presentController, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23), decoration: const InputDecoration(labelText: 'مضارع هُوَ با حرکت', hintText: 'يَكْتُبُ', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: buildTable, icon: const Icon(Icons.table_chart), label: const Text('ساخت جدول ۱۴ صیغه')),
        if (message.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(message, style: const TextStyle(color: Colors.indigo))),
        if (rows != null) ...[
          const SizedBox(height: 8), const Text('جدول ماضی و مضارع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _VerbTable(rows: rows!),
          const SizedBox(height: 12),
          const Text('مستقبل با افزودن «سَـ» به مضارع ساخته می‌شود:'),
          _VerbTable(rows: [rows![0], ...rows!.skip(1).map((r) => [r[0], r[1], 'سَ${r[2]}'])]),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TablePracticePage(rows: rows))), icon: const Icon(Icons.quiz), label: const Text('تمرین چهارگزینه‌ای با همین فعل')),
        ],
      ]),
    ),
  );
}

class PracticePage extends StatefulWidget { const PracticePage({super.key}); @override State<PracticePage> createState() => _PracticePageState(); }
class _PracticePageState extends State<PracticePage> {
  int index = 0, score = 0; String? selected;
  final questions = const [
    _Question('كَتَبَ مربوط به کدام زمان است؟', ['ماضی', 'مضارع', 'امر'], 'ماضی'),
    _Question('معنی «يَكْتُبُ» چیست؟', ['نوشت', 'می‌نویسد', 'بنویس'], 'می‌نویسد'),
    _Question('«اُكْتُبْ» چه نوع فعلی است؟', ['ماضی', 'نهی', 'امر'], 'امر'),
    _Question('«لا تَكْتُبْ» چه معنایی دارد؟', ['بنویس', 'نمی‌نویسد', 'ننویس'], 'ننویس'),
  ];
  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تمرین')),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('سؤال ${index + 1} از ${questions.length}  |  امتیاز: $score'),
              const SizedBox(height: 20),
              Text(
                q.text,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...q.options.map(
                (o) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton(
                    onPressed: selected == null
                        ? () => setState(() {
                              selected = o;
                              if (o == q.answer) {
                                score++;
                              } else {
                                AppStats.mistakes.add(q.text);
                              }
                              AppStats.answered++;
                            })
                        : null,
                    child: Text(o),
                  ),
                ),
              ),
              if (selected != null)
                Text(
                  selected == q.answer
                      ? 'آفرین! پاسخ درست است.'
                      : 'پاسخ درست: ${q.answer}',
                  style: TextStyle(
                    color: selected == q.answer ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),
              FilledButton(
                onPressed: selected == null
                    ? null
                    : () {
                        if (index == questions.length - 1) {
                          AppStats.correct += score;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultPage(
                                score: score,
                                total: questions.length,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            index++;
                            selected = null;
                          });
                        }
                      },
                child: Text(
                  index == questions.length - 1 ? 'پایان تمرین' : 'سؤال بعدی',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TablePracticePage extends StatefulWidget {
  final List<List<String>>? rows;
  const TablePracticePage({super.key, this.rows});

  @override
  State<TablePracticePage> createState() => _TablePracticePageState();
}

class _TablePracticePageState extends State<TablePracticePage> {
  final _random = math.Random();
  bool _mazi = true;
  int _index = 0;
  int _score = 0;
  bool _missingPronoun = true;
  String? _selected;
  late List<String> _options;

  List<List<String>> get _rows {
    if (widget.rows != null) return [widget.rows!.first, ...widget.rows!.skip(1).map((r) => [r[0], _mazi ? r[1] : r[2]])];
    return _mazi ? VerbExamples.mazi : VerbExamples.mozare;
  }

  @override
  void initState() {
    super.initState();
    _prepareQuestion();
  }

  void _prepareQuestion() {
    _missingPronoun = _random.nextBool();
    final column = _missingPronoun ? 0 : 1;
    final correct = _rows[_index + 1][column];
    final pool = _rows.skip(1).map((row) => row[column]).toSet().toList()
      ..remove(correct)
      ..shuffle(_random);
    _options = [correct, ...pool.take(3)]..shuffle(_random);
    _selected = null;
  }

  void _changeTense(bool mazi) {
    setState(() {
      _mazi = mazi;
      _index = 0;
      _score = 0;
      _prepareQuestion();
    });
  }

  void _next() {
    if (_selected == null) return;
    if (_selected == (_rows[_index + 1][_missingPronoun ? 0 : 1])) {
      _score++;
    } else {
      AppStats.mistakes.add(
        _missingPronoun
            ? 'ضمیر فعل ${_rows[_index + 1][1]}'
            : 'فعل ${_mazi ? 'ماضی' : 'مضارع'} برای ضمیر ${_rows[_index + 1][0]}',
      );
    }
    AppStats.answered++;

    if (_index == 13) {
      AppStats.correct += _score;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(score: _score, total: 14),
        ),
      );
    } else {
      setState(() {
        _index++;
        _prepareQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final row = _rows[_index + 1];
    final prompt = _missingPronoun
        ? 'ضمیر مناسب این فعل کدام است؟'
        : 'فعل مناسب این ضمیر کدام است؟';
    final clue = _missingPronoun ? row[1] : row[0];
    final correct = row[_missingPronoun ? 0 : 1];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تمرین چهارگزینه‌ای جدول')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('ماضی')),
                ButtonSegment(value: false, label: Text('مضارع')),
              ],
              selected: {_mazi},
              onSelectionChanged: (value) => _changeTense(value.first),
            ),
            const SizedBox(height: 18),
            LinearProgressIndicator(
              value: (_index + 1) / 14,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF5878C8),
              backgroundColor: const Color(0xFFE4E1F0),
            ),
            const SizedBox(height: 10),
            Text(
              'ردیف ${_index + 1} از ۱۴     امتیاز: $_score',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      prompt,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _missingPronoun ? 'ضمیر: ؟' : 'فعل: ؟',
                      style: const TextStyle(color: Colors.deepOrange, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      clue,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3657A7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _missingPronoun ? 'فعل ${_mazi ? 'ماضی' : 'مضارع'}' : 'ضمیر',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            ..._options.map((option) {
              final isSelected = _selected == option;
              final isCorrect = option == correct;
              Color? tileColor;
              if (_selected != null && isSelected) {
                tileColor = isCorrect ? const Color(0xFFDDF3E4) : const Color(0xFFFFE2E2);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: tileColor,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    side: BorderSide(
                      color: isSelected ? (isCorrect ? Colors.green : Colors.red) : const Color(0xFFB8C3E2),
                      width: 1.4,
                    ),
                  ),
                  onPressed: _selected == null ? () => setState(() => _selected = option) : null,
                  child: Text(option, style: const TextStyle(fontSize: 20)),
                ),
              );
            }),
            if (_selected != null) ...[
              const SizedBox(height: 8),
              Text(
                _selected == correct ? 'آفرین! پاسخ درست است.' : 'پاسخ درست: $correct',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _selected == correct ? Colors.green.shade800 : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _next,
                child: Text(_index == 13 ? 'پایان تمرین' : 'ردیف بعدی'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Question { final String text; final List<String> options; final String answer; const _Question(this.text, this.options, this.answer); }

class ExamPage extends StatefulWidget { const ExamPage({super.key}); @override State<ExamPage> createState() => _ExamPageState(); }
class _ExamPageState extends State<ExamPage> {
  int seconds = 60, index = 0, score = 0; String? selected; Timer? timer;
  final questions = const [_Question('«ذَهَبَ» چه زمانی است؟', ['ماضی', 'مضارع', 'امر'], 'ماضی'), _Question('«تَكْتُبِينَ» برای کدام ضمیر است؟', ['أَنْتَ', 'أَنْتِ', 'هِيَ'], 'أَنْتِ'), _Question('امر فعل كتب برای «أَنْتَ» چیست؟', ['كَتَبَ', 'اُكْتُبْ', 'يَكْتُبُ'], 'اُكْتُبْ'), _Question('«نَكْتُبُ» برای کدام ضمیر است؟', ['أَنا', 'نَحْنُ', 'هُمْ'], 'نَحْنُ')];
  @override void initState() { super.initState(); timer = Timer.periodic(const Duration(seconds: 1), (t) { if (!mounted) return; if (seconds <= 1) { t.cancel(); finish(); } else { setState(() => seconds--); } }); }
  void finish() { timer?.cancel(); AppStats.exams++; AppStats.correct += score; AppStats.answered += index + (selected == null ? 0 : 1); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultPage(score: score, total: questions.length))); }
  @override void dispose() { timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('آزمون زمان‌دار'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text('$seconds ثانیه'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('سؤال ${index + 1} از ${questions.length}'),
              const SizedBox(height: 20),
              Text(
                q.text,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...q.options.map(
                (o) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton(
                    onPressed: selected == null
                        ? () => setState(() {
                              selected = o;
                              if (o == q.answer) {
                                score++;
                              } else {
                                AppStats.mistakes.add(q.text);
                              }
                            })
                        : null,
                    child: Text(o),
                  ),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: selected == null
                    ? null
                    : () {
                        if (index == questions.length - 1) {
                          finish();
                        } else {
                          setState(() {
                            index++;
                            selected = null;
                          });
                        }
                      },
                child: Text(
                  index == questions.length - 1 ? 'ثبت نتیجه' : 'بعدی',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget { final int score, total; const ResultPage({super.key, required this.score, required this.total});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('نتیجه')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 70, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                'امتیاز شما: $score از $total',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text('بازگشت به صفحه اصلی'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportPage extends StatelessWidget { const ReportPage({super.key});
  @override Widget build(BuildContext context) { final percent = AppStats.answered == 0 ? 0 : (AppStats.correct * 100 / AppStats.answered).round(); return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('کارنامه')), body: ListView(padding: const EdgeInsets.all(16), children: [Card(child: ListTile(title: const Text('درصد پاسخ‌های صحیح'), trailing: Text('$percent٪', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)))), Card(child: ListTile(title: const Text('تعداد آزمون‌ها'), trailing: Text('${AppStats.exams}'))), Card(child: ListTile(title: const Text('تعداد پاسخ‌ها'), trailing: Text('${AppStats.answered}'))), const SizedBox(height: 12), const Text('اشتباهات ثبت‌شده', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), if (AppStats.mistakes.isEmpty) const Padding(padding: EdgeInsets.all(12), child: Text('هنوز اشتباهی ثبت نشده است.')) else ...AppStats.mistakes.map((m) => ListTile(leading: const Icon(Icons.error_outline, color: Colors.red), title: Text(m)))]))); }
}

class AboutPage extends StatelessWidget { const AboutPage({super.key});
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('درباره برنامه')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.menu_book, size: 76, color: Color(0xFF3657A7)), const SizedBox(height: 18), const Text('صرف‌آموز عربی', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)), const SizedBox(height: 20), const Text('HAKnet', style: TextStyle(fontSize: 27, color: Color(0xFF3657A7), fontWeight: FontWeight.bold)), const SizedBox(height: 12), const Text('سازنده: عبدالهی خسروشاهی', style: TextStyle(fontSize: 18)), const SizedBox(height: 12), const Text('نسخه 1.0.0'), const SizedBox(height: 18), const Text('ویژه آموزش صرف افعال عربی پایه‌های هفتم تا نهم', textAlign: TextAlign.center)])))));
}
