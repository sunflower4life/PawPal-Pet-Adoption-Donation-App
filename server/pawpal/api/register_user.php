<?php
    header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}
	if(!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['phone'])) {
		http_response_code(400);
		echo json_encode(array('error' => 'Bad Request'));
		exit();
	}
	$name = $_POST['name'];
	$email = $_POST['email'];
	$password = $_POST['password'];
	$hashedpassword = sha1($password);
	$phone = $_POST['phone'];

	// Check if email already exists
	$sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
	$result = $conn->query($sqlcheckmail);
	if ($result->num_rows > 0){
		$response = array('success' => false, 'message' => 'Email already registered');
		sendJsonResponse($response);
		exit();
	}

	// Insert new user into database
	$sqlregister = "INSERT INTO `tbl_users`(`name`, `email`, `password`, `phone`) VALUES ('$name','$email','$hashedpassword','$phone')";
	try{
		if ($conn->query($sqlregister) === TRUE) {
			$response = array('success' => true, 'message' => 'Registration successful');
			sendJsonResponse($response);
		} else {
			$response = array('success' => false, 'message' => 'Register failed: ' . $conn->error);
			sendJsonResponse($response);
		}

	}catch(Exception $e){
		$response = array('success' => 'failed', 'message' => 'ERROR occured: ' .$e->getMessage());
		sendJsonResponse($response);
	}

	//function to send json response
function sendJsonResponse($sendArray) {
	header('Content-Type: application/json');
	echo json_encode($sendArray);
}
?>
