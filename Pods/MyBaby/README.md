# MyBaby

While developing iOS apps, we ofter lot's of basic functions.

Feature : -
1. Alert (POP UP).
2. Animation.
3. API call (GET & POST method).
4. Data-Time function.
5. Loader.
6. Location.
7. TextField.
8. String


Requirement : - 
1. iOS 10.0+
2. Xcode 10.2+
3. Swift 4+


Installation : -
CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your PodFile:

pod 'MyBaby',  '~> 1.0.44'

How To Use : -
1. Import MyBaby
2. MyBaby.(Alert,Animation,API,textField,Data-Time,Loader,etc).(just select function you want to implement).

for api responce call  : -  ApiResponceDelegateMB
EXAMPLE : - 
1. Import MyBaby
2. class ABC : UIViewController,ApiResponceDelegateMB{
// class function
}

For location response call : - LocationDelegateMB
EXAMPLE : -
1. Import MyBaby
2. class ABC : UIViewController,LocationDelegateMB{
// class function
}
