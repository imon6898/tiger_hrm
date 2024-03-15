import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        opacityLevel = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        title: const Text(
          'Policy',
          style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: opacityLevel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Policy for Daily Star HRMS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                "This Policy explains the policies regarding the collection, use, disclosure, and transfer of information by Daily Star HRMS (\"the App\"). By accessing the App or otherwise using its services, you consent to the collection, storage, and use of the personal information you provide for the services offered.",
              ),
              SizedBox(height: 16),
              Text(
                "1. Information Supplied by Users:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- When registering or subscribing for any service, basic contact information such as name, sex, age, address, contact number, occupation, interests, and email address may be requested. Subscriptions for other services may require additional information such as credit card details.",
              ),
              SizedBox(height: 16),
              Text(
                "2. Information Automatically Collected/Tracked While Navigation:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- Cookies may be used to assign each visitor a unique identification number and to understand individual interests. Log file information, including IP address, operating system, browser type, and version, may be collected.",
              ),
              SizedBox(height: 16),
              Text(
                "3. Information from Other Sources:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- Information may be obtained from third-party sources and treated in accordance with this policy. This includes demographic and purchase information to provide targeted communications and promotions.",
              ),
              SizedBox(height: 16),
              Text(
                "4. Links to 3rd Party Sites/Ad Servers:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- The App may contain links to other websites or applications governed by their respective privacy policies. Third-party advertising companies may serve ads based on users' visits.",
              ),
              SizedBox(height: 16),
              Text(
                "5. Information Use by the Company:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- User information enables the improvement of services and the provision of a user-friendly experience. Email addresses may be used for marketing purposes with an option to subscribe/unsubscribe.",
              ),
              SizedBox(height: 16),
              Text(
                "6. Information Sharing:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- Information may be shared when required by law or for processing on behalf of the Company. Aggregate statistics may be shared with advertisers to understand audience demographics.",
              ),
              SizedBox(height: 16),
              Text(
                "7. Accessing and Updating Personal Information:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- We make efforts to provide access to and correct personal information upon request. Users can update their information to ensure accuracy, subject to legal requirements or legitimate business purposes.",
              ),
              SizedBox(height: 16),
              Text(
                "8. Information Security:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- We implement appropriate security measures to protect against unauthorized access or alteration of data. However, we cannot guarantee the security of our database or the interception of information transmitted over the Internet.",
              ),
              SizedBox(height: 16),
              Text(
                "9. Updates and Changes:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- We may update this Policy to reflect changes in technology, applicable law, or other factors. Users are advised to review the policy periodically to stay informed about any changes.",
              ),
              SizedBox(height: 16),
              Text(
                "10. Questions and Grievance Redressal:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "- For any complaints, abuse, or concerns regarding the processing of information or breach of this policy, please contact us at webmaster@thedaitystar.net. Please provide specific information about your complaint, including identification of the information involved and your contact details.",
              ),
              SizedBox(height: 16),
              Text(
                "This Policy was last updated on [insert date].",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
