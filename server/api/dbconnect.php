<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pawpal_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    // Don't echo HTML errors - return JSON instead
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Database connection failed: ' . $conn->connect_error));
    exit();
}
?>