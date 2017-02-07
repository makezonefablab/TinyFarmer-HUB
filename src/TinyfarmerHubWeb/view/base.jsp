<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.mediaflow.common.utils.LoginUtils" %>
<%@ page import="com.mediaflow.common.utils.Constants" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- <link rel="icon" href="../../favicon.ico"> -->

		<title>Tinyfarmer Hub Configuration</title>

		<!-- Bootstrap core CSS -->
		<link href="bootstrap-3.3.0/css/bootstrap.css" rel="stylesheet" />
		<link href="bootstrap-3.3.0/css/bootstrap-theme.css" rel="stylesheet" />

		<!-- Custom styles for this template -->
		<link href="css/justified-nav.css" rel="stylesheet">
		
		<style type="text/css">
		<!--
			.no-border {border:none;border-right:0px; border-top:0px; boder-left:0px; boder-bottom:0px;}
		//-->
		</style>
		
	</head>

	<body>

		<div class="container">
			
			<table style="width:100%">
				<tr>
					<td style="width:70%">
						<h3 class="text-muted">
							Tinyfarmer Hub
						</h3>
					</td>
					<td style="text-align:right;width:30%">
						<%=LoginUtils.getSessionValue("id")%>&nbsp;&nbsp;&nbsp;
						<input type="button" id="logView" class="btn btn-info" value="로그보기 &raquo;" />
						<input type="button" id="logout" class="btn btn-success" value="Logout &raquo;" />
					</td>
				</tr>
			</table>

			<div class="row">
				<div class="col-sm-12">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<h3 class="panel-title"><b>제품 등록</b> &nbsp;[ 제품번호 - ${macAddress} ]</h3>
						</div>
						<div class="panel-body">
							<div class="form-inline">
								<div id="product_no" style="display:none">
									<input type="button" id="register" class="btn btn-warning" value="Register &raquo;" />
									&nbsp;&nbsp;&nbsp;&nbsp;<label style="font-size:14px;color:red">( ▶ 등록되지 않은 제품입니다. 등록 후 사용하세요. )</label>
								</div>
								<div id="product_yes" style="display:none">
									<label style="font-size:14px;color:blue"> ▶ 등록된 제품입니다. </label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-sm-12">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<h3 class="panel-title"><b>Service 관리</b> &nbsp;[ PROCESS ID - <span id="processId">${processId}</span> ]</h3>
						</div>
						<div class="panel-body">
							<div class="form-inline">
								<input type="button" id="start" class="btn btn-success" value="Start &raquo;" <s:if test="processId neq null && processId neq ''">disabled</s:if> />
								<input type="button" id="stop" class="btn btn-warning" value="Stop &raquo;" <s:if test="processId eq null || processId eq ''">disabled</s:if> />
								<input type="button" id="restart" class="btn btn-primary" value="Restart &raquo;" <s:if test="processId eq null || processId eq ''">disabled</s:if> />
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-4">
					<form>
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title"><b>Cloud Server Information</b></h3>
						</div>
						<div class="panel-body">
							<div class="form-group">
								<label for="serverHost">Host: <span id="desc">클라우드 서버 IP 주소 또는 도메인</span></label>
								<input type="text" class="form-control" id="serverHost" name="serverHost" value="${configurationVO.serverHost}" required>
							</div>
							<div class="form-group">
								<label for="serverSocketPort">Socket Port: <span id="desc">클라우드 서버 소켓 포트 번호</span></label>
								<input type="text" class="form-control" id="serverSocketPort" name="serverSocketPort" value="${configurationVO.serverSocketPort}" required>
							</div>
							<div class="form-group">
								<label for="serverHttpPort">Http Port: <span id="desc">클라우드 서버 웹 포트 번호</span></label>
								<input type="text" class="form-control" id="serverHttpPort" name="serverHttpPort" value="${configurationVO.serverHttpPort}" required>
							</div>
							<p>
								<input type="button" id="save2" class="btn btn-success" value="Save &raquo;" />
								<input type="button" id="cancel2" class="btn btn-warning" value="Cancel &raquo;" />
							</p>
						</div>
					</div>
					</form>
				</div><!-- /.col-sm-4 -->
				<div class="col-sm-4">
					<form>
					<div class="panel panel-warning">
						<div class="panel-heading">
							<h3 class="panel-title"><b>Sensor Node Information</b></h3>
						</div>
						<div class="panel-body">
							<div class="form-group">
								<label for="sensorType">Sensor Node Type: <span id="desc">센서노드 타입</span></label>
								<select class="form-control" id="sensorType" name="sensorType" required>
									<option value="HC12">HC12</option>
									<option value="RFM69">RFM69</option>
								</select>
							</div>
							<div class="form-group">
								<label for="baudrate">Baudrate: <span id="desc">통신속도</span></label>
								<select class="form-control" id="baudrate" name="baudrate" required>
									<option value="9600">9600</option>
									<option value="19200">19200</option>
									<option value="38400">38400</option>
									<option value="57600">57600</option>
									<option value="74880">74880</option>
									<option value="115200">115200</option>
								</select>
							</div>
							<div class="form-group">
								<label for="channel">Channel: <span id="desc">통신채널</span></label>
								<input type="text" class="form-control" id="channel" name="channel" value="${configurationVO.channel}" required>
							</div>
							<div class="form-group">
								<label for="dataDelay">Data Delay: <span id="desc">전송주기(초)</span></label>
								<input type="text" class="form-control" id="dataDelay" name="dataDelay" value="${configurationVO.dataDelay}" required>
							</div>
							<p>
								<input type="button" id="save3" class="btn btn-success" value="Save &raquo;" />
								<input type="button" id="cancel3" class="btn btn-warning" value="Cancel &raquo;" />
								<input type="button" id="sensorRestart" class="btn btn-primary" value="Restart &raquo;" />
								
							</p>
						</div>
					</div>
					</form>
				</div><!-- /.col-sm-4 -->
			</div>

			<hr>
			<!-- Site footer -->
			<footer>
			<p><b>&copy; 2016 Mediaflow, Inc.</b></p>
			</footer>

		</div> <!-- /container -->
		
		<script type='text/javascript' src="js/jquery/jquery_1.9.1.min.js"></script>
		<script type='text/javascript' src="bootstrap-3.3.0/js/bootstrap.js"></script>
		<script type='text/javascript' src="js/bootstrap-waitingfor.js"></script>

		<script>
			$(document).ready(function() {
				
				$('#sensorType option[value=${configurationVO.sensorType}]').prop('selected', true);
				
				$('#baudrate option[value=${configurationVO.baudrate}]').prop('selected', true);
				
				$('#logout').click(function(event) {
					location.href = 'logout';
				});
				
				$('#register').click(function(event) {
					$.getJSON('registerProduct', {
					}, function(data) {
						if(data.code != "0") {
							$('#product_no').show();
							$('#product_yes').hide();
						}
						else {
							$('#product_yes').show();
							$('#product_no').hide();
						}
						alert(data.msg);
					});
				});

				$('#save2').click(function(event) {
					$.getJSON('saveCloudServerInformation', {
						serverHost : $('#serverHost').val(),
						serverSocketPort : $('#serverSocketPort').val(),
						serverHttpPort : $('#serverHttpPort').val()
					}, function(data) {
						alert(data.msg);
					});
				});

				$('#cancel2').click(function(event) {
					$.getJSON('selectCloudServerInformation', {
					}, function(data) {
						$('#serverHost').val(data.serverHost);
						$('#serverSocketPort').val(data.serverSocketPort);
						$('#serverHttpPort').val(data.serverHttpPort);
						alert(data.msg);
					});
				});

				$('#save3').click(function(event) {
					$.getJSON('saveSensorNodeInformation', {
						sensorType : $('#sensorType').val(),
						baudrate : $('#baudrate').val(),
						channel : $('#channel').val(),
						dataDelay : $('#dataDelay').val()
					}, function(data) {
						alert(data.msg);
					});
				});

				$('#cancel3').click(function(event) {
					$.getJSON('selectSensorNodeInformation', {
					}, function(data) {
						$('#sensorType').val(data.sensorType);
						$('#baudrate').val(data.baudrate);
						$('#channel').val(data.channel);
						$('#dataDelay').val(data.dataDelay);
						alert(data.msg);
					});
				});

				$("#start").click(function () {
					$.ajaxSetup({
						global: false,
						type: "POST",
						url: "startService",
						beforeSend: function () {
							waitingDialog.show('Service Starting...');
						}
					});
					$.ajax({
						success: function (data) {
							waitingDialog.hide();
							
							$('[id=start]').attr("disabled",true);
							$('[id=stop]').removeAttr("disabled");
							$('[id=restart]').removeAttr("disabled");

							$('#processId').text(data.processId);
							//$('#serviceStatus').text(data.serviceStatus);
							alert(data.serviceStatus);
						},
						error: function(e) {
							//alert(e.responseText);
							alert(data.msg);
						}
					});
				});

				$("#stop").click(function() {
					$.ajaxSetup({
						global : false,
						type : "POST",
						url : "stopService",
						beforeSend : function() {
							waitingDialog.show('Service Stopping...');
						}
					});
					$.ajax({
						success : function(data) {
							waitingDialog.hide();
		
							$('[id=stop]').attr("disabled", true);
							$('[id=start]').removeAttr("disabled");
							$('[id=restart]').attr("disabled", true);
							
							$('#processId').text(data.processId);
							//$('#serviceStatus').text(data.serviceStatus);
							alert(data.serviceStatus);
						},
						error: function(e) {
							//alert(e.responseText);
							alert(data.msg);
						}
					});
				});

				$("#restart").click(function() {
					$.ajaxSetup({
						global : false,
						type : "POST",
						url : "restartService",
						beforeSend : function() {
							waitingDialog.show('Service Restarting...');
						}
					});
					$.ajax({
						success : function(data) {
							waitingDialog.hide();
		
							$('[id=start]').attr("disabled",true);
							$('[id=stop]').removeAttr("disabled");
							$('[id=restart]').removeAttr("disabled");
							
							$('#processId').text(data.processId);
							//$('#serviceStatus').text(data.serviceStatus);
							alert(data.serviceStatus);
						},
						error: function(e) {
							//alert(e.responseText);
							alert(data.msg);
						}
					});
				});
				
				$("#sensorRestart").click(function() {
					$.ajaxSetup({
						global : false,
						type : "POST",
						url : "sensorRestartService",
						data: {
							sensorType : $('#sensorType').val()
						},
						beforeSend : function() {
							waitingDialog.show('Sensor Restarting...');
						}
					});
					$.ajax({
						success : function(data) {
							waitingDialog.hide();
		
							//$('[id=restart]').attr("disabled", true);
							alert(data.serviceStatus);
						},
						error: function(e) {
							//alert(e.responseText);
							alert(data.msg);
						}
					});
				});
				
				$('#logView').click(function(event) {
					//var sensorType = $('#sensorType').val();
					window.open("logView", "Log Viewer", "width=1024, height=768, scrollbars=auto");
				});
				
			});
			
			$(window).load(function() {
				<%
					if(StringUtils.isBlank(request.getAttribute("productId").toString())) {
				%>
						$('#product_no').show();
						$('#product_yes').hide();
				<%
					}
					else {
				%>
						$('#product_yes').show();
						$('#product_no').hide();
				<%
					}
				%>
			});

		</script>
	</body>
</html>
