<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('status' => false, 'message' => 'Method Not Allowed'));
    exit();
}

// Receive POST values
$user_id = $_POST['user_id'];
$name = addslashes($_POST['name']);
$phone = addslashes($_POST['phone']);
$profileImage = isset($_POST['profile_image']) ? $_POST['profile_image'] : null;

// Validation
if (empty($user_id) || empty($name) || empty($phone)) {
    $response = array('status' => false, 'message' => 'Missing required fields');
    sendJsonResponse($response);
    exit();
}

// Update user table
$sqlupdate = "
UPDATE tbl_users 
SET 
    name = '$name',
    phone = '$phone',
    profile_image = 'profile_" . $user_id . ".jpg'
WHERE user_id = '$user_id'
";

try {
    if ($conn->query($sqlupdate) === TRUE) {
        // Handle profile image if provided
        if (!empty($profileImage)) {
            $imageData = base64_decode($profileImage);
            $folder = "../assets/profiles/";

            if (!file_exists($folder)) {
                mkdir($folder, 0777, true);
            }

            $imagePath = $folder . "profile_" . $user_id . ".jpg";
            file_put_contents($imagePath, $imageData);
        }

        $response = array('status' => true, 'message' => 'Profile updated successfully');
        sendJsonResponse($response);
    } else {
        $response = array('status' => false, 'message' => 'Update failed');
        sendJsonResponse($response);
    }
} catch(Exception $e) {
    $response = array('status' => false, 'message' => $e->getMessage());
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>