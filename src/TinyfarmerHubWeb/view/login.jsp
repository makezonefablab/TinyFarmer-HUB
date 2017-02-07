<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">

		<!-- <link rel="icon" href="../../favicon.ico"> -->

		<title>Tinyfarmer Hub Login</title>

		<!-- Bootstrap core CSS -->
		<link href="bootstrap-3.3.0/css/bootstrap.min.css" rel="stylesheet">

		<!-- Custom styles for this template -->
		<link href="css/login.css" rel="stylesheet">

	</head>

	<body>
		<div class="container">
	
			<form class="form-login" method="post" action="login">
				<h2 class="form-login-heading">Tinyfarmer Hub Login</h2>
				<br>
				<label for="id" class="sr-only">Email address</label>
				<!-- <input type="email" id="id" name="id" class="form-control" placeholder="Email address" value="tinyfarmer@mediaflow.kr" required autofocus> -->
				<input type="text" id="id" name="id" class="form-control" placeholder="Id" value="" required autofocus>
				<span>${fieldErrors.errorId}</span>
				<br>
				<label for="password" class="sr-only">Password</label>
				<input type="password" id="password" name="password" class="form-control" placeholder="Password" value="" required>
				<span>${fieldErrors.errorPassword}</span>
				<br>
				<span>${errMsg}</span>
				<button class="btn btn-primary btn-block" type="submit">Login</button>
				<div class="login-msg">※ 클라우드 서버의 아이디와 비밀번호로 로그인 하세요.</div>
			</form>
	
		</div> <!-- /container -->
	</body>
</html>