# pawpal

A new Flutter project.
NAME: NURUL NADHIRAH BINTI DZULKEFLI
MATRIC NO. : 301315

PawPal is a full-stack mobile application developed using Flutter, PHP, and MySQL that allows users to browse and adopt pets from a public listing, submit adoption requests, make donations in the form of food, medical support, or money to animals in need, manage their user profile and donation history, and securely process monetary donations through integration with the Billplz payment gateway (sandbox environment), with the Flutter-based frontend communicating with a native PHP backend and a MySQL database hosted on the server at socstudentmusicforlife.com/nad under your chosen hosting provider.

1.Project setup steps
    -PHP 7.4+
    -MySQL 5.7+
    -cURL enabled
    -Billplz Sandbox Account
    -Clone repository
    -Upload PHP files to `/nad/pawpal/api/` on server
    -Create MySQL database `pawpal_db`
    -Import database tables
    -Update `MyConfig.dart` with server URL

2.Features
    -User Register and Login:
    User enters email and password. Validates input (email format, password length). Sends POST request to `login_user.php`. Stores user data in SharedPreferences for session management. Navigates to HomeScreen if successful
    -Public pet listing with search & filter: Implemented in mainpage.dart where it use to retrieve all pets from the API. Search pet by name and filter pet by type (cat,dog,rabbit). Card UI is used to display pet images,name,type, and and category(adoption,donation,help/rescue).
    -Pet details screen:
    Implemented in petdetailsscreen.dart where it use to display all pet informations including images, type, age, gender, health and posted by who.
    -Adoption form:
    Implemenetd in the petdetailsscreen.dart. User click category of adoption in a card and it will required user to enter short motivation to adopt a pet. Once submitted, it will stored in tbl_adoption.
    -Donation form:
    Implemented in mydonationsscreen.dart. There are 3 main option which are (Food, medical,money). Food and money will have the same ui text input where it required user to input a description. Meanwhile money required user to enter amount (RM) to be donated in a text fields. Once click submit donation, user will be redirect to Billplz payment gateway to continue for transaction. Once finished, user will be redirect back to my donation list.
    -User profile management:
    User can view and updated their profile only for photo, name and phone numbers.

3.API explaination
    -dbconnect.php : Database connection
    -login_user.php : User login and authentication (POST)
    -register_user.php : New user registration (POST)
    -donation_callback : Billplz payment callback (GET)
    -donation_payment : Formats phone number to Billplz required format (+60XXXXXXXXX)
    -Creates payment bill via Billplz API (GET)
    -donation_update : Receives callback from Billplz after payment completion (GET)
    -get_my_donations.php : Fetch user donations (GET)
    -submit_pet.php : use to insert new pet services using (POST). Accepts form data and up to 3 Base64 encoded images and save it into /assets/pets.Stores file paths into MySQL in JSON format.Returns success or failed status.
    -get_my_pets.php : use to Retrieve and display pet services for logged-in user using (GET).Fetches user submissions.
    -get_user_details : Fetch logged-in user profile (GET)
    -submit_adoption_request.php : Submit adoption request
    -submit_donation.php : Submit donation
    -update_user_profile.php : Update user profile

3.App flow
    -Splash Screen → Auto-login with SharedPreferences
    -Login/Register → Create account or login
    -Home Screen → View public pet listings
    -Pet Details → See full pet info
    -Adoption/Donation → Submit requests
    -Donation Payment → Process via Billplz
    -My Donations → View donation history
    -Profile → View and edit user info

4.Database 
    - `tbl_users` - User accounts and profiles
    - `tbl_pets` - Pet listings
    - `tbl_adoptions` - Adoption requests
    - `tbl_donations` - Donation records
