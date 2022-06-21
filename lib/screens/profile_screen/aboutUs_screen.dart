import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/widgets/bigTexT.dart';
import 'package:success_airline/widgets/smallText.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: SmallText(
          text: 'About us',
          size: 22,
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        width: 100.w,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BigText(
              text: 'About Us',
              color: kprimaryColor,
            ),
            SizedBox(
              height: 2.h,
            ),
            SmallText(
                height: 1.5,
                textAlign: TextAlign.justify,
                color: Colors.black,
                text:
                    '''Success Airlines App is an educational tool for parents that teaches children many of the things they should be taught at school but are not. A resource, we support busy parents by introducing their children to success and we guide them on the right path by providing kids with invaluable life lessons. 
        
        We introduce your children to the mindset of success. Initially, we teach kids about careers, showing them some of the jobs that are available in the world, industry by industry.  As we grow as an app, we will provide interviews with successful people so that our children can learn from the best. 
        
        Also we have a section on life skills.  As we adults navigated to maturity, there were many things we have experienced that we’re not taught in school.  On Success Airlines, we will support parents in your goal to give your child an edge in a competitive world. We allow parents to create their kid’s curriculum so we can help you make your child be the best he or she can be.''')
          ]),
        ),
      ),
    );
  }
}
