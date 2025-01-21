import 'package:CarMate/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() => runApp(CarMateApp());

class CarMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.data == true) {
          return IntroPages();
        } else {
          return CarServiceLoginApp();
        }
      },
    );
  }

  Future<bool> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');
    return isFirstLaunch == null || isFirstLaunch;
  }
}

class IntroPages extends StatefulWidget {
  @override
  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final PageController _controller = PageController();
  int _currentPage = 0;

 final List<Map<String, String>> _pages = [
    {
      "image": "images/logo.png",
      "title": "Welcome to CarMate",
      "description":
          "CarMate is your go-to app for easy car repairs. Access a range of services to fix your car quickly and efficiently.",
    },
    {
      "image": "../images/w3.png",
      "title": "Buy Tools",
      "description":
          "Purchase high-quality car tools and get them delivered to your doorstep for all your repair needs.",
    },
    {
      "image": "../images/w2.png",
      "title": "Find Nearby Services",
      "description":
          "Locate nearby workshops and gas stations on the map for quick and easy service wherever you are.",
    },
    {
      "image": "../images/logo2.png",
      "title": "Chat and Posts",
      "description":
          "Join the CarMate community to chat, share tips, and stay updated with the latest car maintenance posts.",
    },
  ];


  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _completeIntro();
    }
  }

  void _skipIntro() {
    _completeIntro();
  }

  Future<void> _completeIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CarServiceLoginApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildAnimatedPage(
                context,
                index,
                _pages[index]['image']!,
                _pages[index]['title']!,
                _pages[index]['description']!,
              );
            },
          ),
          _buildPageIndicator(),
          Positioned(
            top: 40,
            right: 20,
            child: AnimatedOpacity(
              opacity: _currentPage < _pages.length - 1 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: _skipIntro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 89, 169, 239),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildAnimatedPage(BuildContext context, int index, String imagePath,
      String title, String description) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page! - index;
          value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
        }

        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 255, 255)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedPositioned(
                    left:
                        index == 0 ? -MediaQuery.of(context).size.width / 2 : 0,
                    duration: Duration(milliseconds: index == 0 ? 700 : 1000),
                    curve: Curves.easeOut,
                    child: Image.asset(imagePath, height: 250 * value),
                  ),
                  SizedBox(height: 20),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 32 * value,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 89, 169, 239),
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText(title),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20 * value,
                        color: const Color.fromARGB(255, 89, 169, 239),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 226, 235, 246), const Color.fromARGB(255, 202, 211, 224)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage < _pages.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 89, 169, 239),
                onPressed: _nextPage,
                child: Icon(Icons.arrow_forward, size: 28, color: Colors.white),
              ),
            ),
          Spacer(),
          if (_currentPage == _pages.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 89, 169, 239),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _completeIntro,
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: 10,
            width: _currentPage == index ? 20 : 10,
            decoration: BoxDecoration(
              color: _currentPage == index ? const Color.fromARGB(255, 89, 169, 239) : const Color.fromARGB(255, 27, 134, 221),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
