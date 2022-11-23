# Codinng Exercise

This is an ios mobile app which fetch the information of ACCORNYMS and get FULLFORM of it along with other details of Frequence and Used Since.

This App is designed for iPhone users and supports all iPhone iPod devices with all portrait and landscape device orienntation. 

# Source Code
---------------------------------------
Source code is publically available on GitHub. User / Developer can download it and also can clone from below url. 

GitHub Project URL: https://github.com/VijayPatel9010/Coding-Exercise.git

# Environments
----------------------------------------
To run application you're required Xcode version 13.2.1 and above. 
To run app in iPhone device, you're required to change bundle identifieres and other signing certificates and profile.  

# App Features
----------------------------------------
The app has following features. 
 - App Launch - Splash screen
 - App Search screen - Enter Acronym in search bar to get full form and other details.
 - App Details screenh - Display more details such as Vars, Frequencies and Used Since.
 - App is tested on multiple device to support autolayout with both landsacp and portrait orientation. 
 - MVVM Architecture has used to provide mode code modularity. 
 - Testcases are added - Due to time constrin unable to add testcases for MOC Data / API call features.

# More Improvement
-------------------------------------------------
The product can be improve more considering following things. 
- Security : Connceting over HTTPS rather HTTP. Can have other features like API Token to enhance security.
- Reusability : Network component can be generalized to framewok to utilize in more apps. 
- Theming : App is currently on Blck & White theme, we can use Compnay Brand Theme. 
- Dynamic Row Height - Currently Label on tableview consider max 2 line. we can make it dynamic height to support any number of line auto adjusted. 
- Addinng more Test case (Mock response)
- Adding Swift Lint to make code optimization
- Multi Langauge support.

# Know Issues
-------------------------------------------------
The product has following known issues.
- Search Bar : On Successful fetching the list, removes the text entered - severity : Minor 
- On first time Launch, App shows no data found. - it should be appear once search is performed. - severity : Minor 
- App icon is missing  - severity : Minor 

