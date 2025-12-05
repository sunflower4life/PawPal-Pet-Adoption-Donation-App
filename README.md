# pawpal

A new Flutter project.
NAME: NURUL NADHIRAH BINTI DZULKEFLI
MATRIC NO. : 301315

1.Setup steps
    -Create a repository to link github with vscode studio.
    -Open XAMPP control panel and start running the Apache and MySQL.
    -Get local ip address by opening command prompt and prompt "ipconfig" in order to get ip address.
    -Copy IPv4 address and paste it in the web to check if the ip address works well or not. If it open the XAMPP interface then it works well. After that, paste in myconfig.dart as base url.
    -Create a database of pawpal_db and table (tbl_users and tbl_pets).
    -Configure php backend by editing databse connection using dbconnect.php with host, user, password, dbname.
    -Create assets folder for uploaded pet images (C:\xampp\htdocs\pawpal\assets\pets)
    -Place backend files into (C:\xampp\htdocs\pawpal\api) for backend php file
    -Test API connection http://10.144.129.233/pawpal/api/submit_pet.php 

2.API explaination
    -submit_pet.php : use to insert new pet services using (POST). Accepts form data and up to 3 Base64 encoded images and save it into /assets/pets.Stores file paths into MySQL in JSON format.Returns success or failed status.
    -get_my_pets.php : use to Retrieve and display pet services for logged-in user using (GET).Fetches user submissions.

3.Sample JSON
    -Successfully sumbitted:{"status":true,"message":"Pet service submitted successfully"}
    -Failed to submit: {"status":true,"message":"Submit pet failed"}