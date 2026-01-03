<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('status' => 'failed', 'message' => 'Method Not Allowed'));
    exit();
}

// Receive POST values
$userid = $_POST['user_id'];
$petname = addslashes($_POST['pet_name']);
$petgender = $_POST['pet_gender'];
$petage = $_POST['pet_age'];
$pethealth = $_POST['pet_health'];
$pettype = $_POST['pet_type'];
$category = $_POST['category'];
$description = addslashes($_POST['description']);
$lat = $_POST['lat'];
$lng = $_POST['lng'];

//handle multiple image
$image1 = isset($_POST['image1']) ? base64_decode($_POST['image1']) : null;
$image2 = isset($_POST['image2']) ? base64_decode($_POST['image2']) : null;
$image3 = isset($_POST['image3']) ? base64_decode($_POST['image3']) : null;

if (!$image1) {
    $response = array('status' => false, 'message' => 'At least one image is required');
    sendJsonResponse($response);
    exit();
}

// Insert new pet record
$sqlinsert = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_gender`, `pet_age`, `pet_health`,`pet_type`, `category`, `description`, `lat`, `lng`) 
VALUES ('$userid','$petname','$petgender','$petage','$pethealth','$pettype','$category','$description','$lat','$lng')";

try {
    if ($conn->query($sqlinsert) === TRUE) {

        $last_id = $conn->insert_id;
        $folder = "../assets/pets/";

        if (!file_exists($folder)) {
            mkdir($folder, 0777, true);
        }

        $paths = [];

        // Save image 1 (required)
        $path1 = $folder . "pet_" . $last_id . "_1.png";
        file_put_contents($path1, $image1);
        $paths[] = "assets/pets/pet_" . $last_id . "_1.png";

        // Save image 2 (optional)
        if ($image2) {
            $path2 = $folder . "pet_" . $last_id . "_2.png";
            file_put_contents($path2, $image2);
            $paths[] = "assets/pets/pet_" . $last_id . "_2.png";
        }

        // Save image 3 (optional)
        if ($image3) {
            $path3 = $folder . "pet_" . $last_id . "_3.png";
            file_put_contents($path3, $image3);
            $paths[] = "assets/pets/pet_" . $last_id . "_3.png";
        }

        // convert image paths as JSON
        $jsonimages = json_encode($paths);
        $updateQuery = "UPDATE `tbl_pets` SET `image_paths`='$jsonimages' WHERE pet_id='$last_id'";
        $conn->query($updateQuery);

        $response = array('status' => true, 'message' => 'Pet service submitted successfully');
        sendJsonResponse($response);

    } else {
        $response = array('status' => false, 'message' => 'Submit pet failed');
        sendJsonResponse($response);
    }
} catch(Exception $e) {
    $response = array('status' => false, 'message' => $e->getMessage());
    sendJsonResponse($response);
}

// function to send json response 	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>