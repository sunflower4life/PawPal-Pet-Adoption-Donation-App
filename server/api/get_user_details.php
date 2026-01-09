<?php
header("Access-Control-Allow-Origin: *");

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if (!isset($_GET['user_id'])) {
        $response = array('status' => false, 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }
    
    $user_id = $_GET['user_id'];
    include 'dbconnect.php';
    
    $sqlgetuser = "SELECT * FROM `tbl_users` WHERE `user_id` = '$user_id'";
    $result = $conn->query($sqlgetuser);
    
    if ($result->num_rows > 0) {
        $userdata = array();
        while ($row = $result->fetch_assoc()) {
            $userdata[] = $row;
        }
        $response = array('status' => true, 'message' => 'Success', 'data' => $userdata);
        sendJsonResponse($response);
    } else {
        $response = array('status' => false, 'message' => 'Invalid request', 'data' => null);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => false, 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>