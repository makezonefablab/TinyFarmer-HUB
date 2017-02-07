<%@ page import="java.io.RandomAccessFile" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%
	String logPath = "/home/mediaflow/TinyfarmerMaster/log/";
	String fileName = request.getParameter("log_filename") == null ? "" : request.getParameter("log_filename");

	if ("".equals(fileName.trim()) == false) {
		fileName = logPath + fileName.trim().replaceAll("\\.\\.", "");

		long preEndPoint = request.getParameter("preEndPoint") == null ? 0
				: Long.parseLong(request.getParameter("preEndPoint")
						+ "");

		StringBuilder log = new StringBuilder();
		long startPoint = 0;
		long endPoint = 0;

		RandomAccessFile file = null;

		try {
			file = new RandomAccessFile(fileName, "r");
			endPoint = file.length();

			startPoint = preEndPoint > 0 ? preEndPoint : endPoint < 2000 ? 0 : endPoint - 2000;

			file.seek(startPoint);

			String str;
			while ((str = file.readLine()) != null) {
				log.append(str);
				log.append("\n");
				endPoint = file.getFilePointer();
				file.seek(endPoint);
			}

		} catch (FileNotFoundException fnfe) {
			log.append("File does not exist.");
			fnfe.printStackTrace();
		} catch (Exception e) {
			log.append(e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				file.close();
			} catch (Exception e) {
			}
		}

		out.print("{\"endPoint\":\""
				+ endPoint
				+ "\", \"log\":\""
				+ URLEncoder.encode(
						new String(log.toString()
								.getBytes("ISO-8859-1"), "UTF-8"),
						"UTF-8").replaceAll("\\+", "%20") + "\"}");

	} else {

		List<String> fileList = new ArrayList<String>();
		String line = null;
		BufferedReader br = null;
		Process ps = null;
		try {
			Runtime rt = Runtime.getRuntime();
			ps = rt.exec(new String[] {
					"/bin/sh",
					"-c",
					"find "
							+ logPath
							+ " -maxdepth 1 -type f -exec basename {} \\; | sort" });
			br = new BufferedReader(new InputStreamReader(ps.getInputStream()));

			while ((line = br.readLine()) != null) {
				fileList.add(line);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				br.close();
			} catch (Exception e) {
			}
		}
%>

<!DOCTYPE html>
<html>
	<head>
		<title>Log Viewer</title>
		<!-- <script src="//code.jquery.com/jquery-1.11.2.min.js"></script> -->
		<link href="bootstrap-3.3.0/css/bootstrap.css" rel="stylesheet" />
		<style type="text/css">
/* 			* {
				margin: 0;
				padding: 0;
			}
			#header {
				position: fixed;
				top: 0;
				left: 50px;
				width: 100%;
				height: 15%;
			} */
			#console {
				position: fixed;
				bottom: 0;
				width: 92%;
				height: 80%;
				background-color: black;
				color:white;
				font-size: 12px;
			}
			#runningFlag {
				color: red;
			}
		</style>
		

	</head>
	<body>
	
	<div class="container">
		<table style="width:100%">
			<tr>
				<td style="width:100%">
					<h3 class="text-muted">
						Log Viewer
					</h3>
				</td>
			</tr>
		</table>
			
		<div class="row">
			<div class="col-sm-12">
				<div class="panel panel-primary">
					<div class="panel-body">
						<div class="form-group">
							<table style="width:100%">
								<tr>
									<td style="width:10%">
										<label for="processType">프로세스구분 </label>
									</td>
									<!-- 
									<td style="width:20%">
										<select class="form-control" id="processType" name="processType" required>
											<option value="">선택</option>
											<option value="TinyfarmerHubApp">TinyfarmerHubApp</option>
											<option value="TinyfarmerHubWeb">TinyfarmerHubWeb</option>
											<option value="HC12">HC12</option>
											<option value="RFM69">RFM69</option>
										</select>
									</td>
									<td style="width:2%">
									</td>
									-->
									<td style="width:40%">
										<select class="form-control" id="fileName" name="fileName" required>
										<% for (String file : fileList) {  %>
										<option value="<%=file%>"><%=file%></option>
										<% }   %>
										</select>
									</td>
									<td style="width:2%">
									</td>
									<td style="width:26%">
										<input type="button" id="startTail" class="btn btn-success" value="Tail Start &raquo;" />
										<input type="button" id="stopTail" class="btn btn-warning" value="Tail Stop &raquo;" />
										&nbsp;&nbsp;<span id="runningFlag">Stop</span>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-12">
				<textarea id="console"></textarea>
			</div>
		</div>
	</div>
	
		<script type='text/javascript' src="js/jquery/jquery_1.9.1.min.js"></script>
		<script type='text/javascript' src="bootstrap-3.3.0/js/bootstrap.js"></script>
	
			<script type="text/javascript">
			var endPoint = 0;
			var tailFlag = false;
			var fileName;
			var consoleLog;
			//var grep;
			//var grepV;
			//var pattern;
			//var patternV;
			var runningFlag;
			var match;
			
			$(document).ready(function() {
				consoleLog = $('#console');
				runningFlag = $('#runningFlag');

				function startTail() {
					runningFlag.html('Running');
					fileName = $('#fileName').val();
					//grep = $.trim($('#grep').val());
					//grepV = $.trim($('#grepV').val());
					//pattern = new RegExp('.*'+grep+'.*\\n', 'g');
					//patternV = new RegExp('.*'+grepV+'.*\\n', 'g');
					
					function requestLog() {
						if (tailFlag) {
							$.ajax({
								type : 'POST',
								url : 'logView',
								dataType : 'json',
								data : {
									'log_filename' : fileName,
									'preEndPoint' : endPoint
								},
								success : function(data) {
									endPoint = data.endPoint == false ? 0 : data.endPoint;
									logdata = decodeURIComponent(data.log);
									/*
									if (grep != false) {
										match = logdata.match(pattern);
										logdata = match ? match.join('') : '';
									}
									if (grepV != false) {
										logdata = logdata.replace(patternV, '');
									}
									*/
									consoleLog.val(consoleLog.val() + logdata);
									consoleLog.scrollTop(consoleLog.prop('scrollHeight'));
									setTimeout(requestLog, 1000);
								}
							});
						}
					}
					
					requestLog();
				}
				
				$('#startTail').on('click', function() {
					tailFlag = true; 
					startTail();
				});
				
				$('#stopTail').on('click', function() {
					tailFlag = false;
					runningFlag.html('Stop');
				});
				
				$('#fileName').change(function() {
					tailFlag = false;
					endPoint = 0;
					runningFlag.html('Stop');
					$('#console').val('');
				});
				
				/*
				$('#processType').change(function() {
					
					if($("#processType option:selected").val() == "TinyfarmerHubApp") {
						$("#fileName").html("<option value='1'>Some oranges</option><option value='2'>MoreOranges</option>");
					}
					else if($("#processType option:selected").val() == "TinyfarmerHubWeb") {
						$("#fileName").html("<option value='/home/mediaflow/TinyfarmerHubWeb/logs/action/action.log'>action.log</option>");
					} 
					else if($("#processType option:selected").val() == "HC12") {
						$("#fileName").html("<option value='/home/mediaflow/TinyfarmerMaster/log/HC12_2017_1_18.log'>HC12_2017_1_18.log</option>");
					}
					else if($("#processType option:selected").val() == "RFM69") { 
						$("#fileName").html("<option value='1'>Some oranges2</option>");
					}
					else {
						$("#fileName").html("<option value=''></option>");
					}
				});
				*/
				
			});
		</script>
	
	</body>
</html>
<%
	}
%>