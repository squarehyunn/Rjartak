<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
	function report(){
		//세션 및 디테일 페이지에서 유저 아이디를 얻어오고 넘겨줘야 함, controller로 처리되도록 수정 필요
		window.open("reportForm", "신고", "width=500px, height=500px");
	}
</script>

</head>
<body>
	<h1>테스트</h1>
	<a href="test">홈테스트</a>
	<a href="test2">컨트롤러2 테스트</a>

	<button onclick="report();">신고하기</button>
	

	<a href="main.do">메인테스트</a>
	<a href="main2.do">메인2테스트</a>
	
	
	<a href="admin">헤더테스트</a>
	
	<a href="adminForm">관리자페이지</a>

	<a href="product.do">경매테스트</a>
	
	<a href="productAdd.do">경매등록테스트</a>

	<a href="mypage.do">마이페이지테스트</a>
	
	<a href="list.do">리스트페이지테스트</a>
	
</body>
</html>