<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알잘딱 - 화상 채팅 경매 서비스</title>
<link rel="icon" type="image/png" sizes="32x32" href="resources/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="resources/images/favicon-16x16.png">
</head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/mypage/mypage_grade.css">
<body>
 <%@ include file="header.jsp"  %>
    <nav></nav>
    
    <section>
        <h1 style="margin-left: 5px;">마이페이지</h1>
        
       <div id="navi" >
            <div id="navi_text">
            <a href="mypage_interest.do?pageNum=1" style="font-weight:bold">활동</a>
            <a href="mypage_msg_receive.do" >메시지</a>
            <a href="mypage.do">계정</a>
             </div>
        </div>
        
        <div id="grid">
            <div id="left-grid">
                     <a href="mypage_interest.do?pageNum=1">관심상품</a>
                <a href="mypage_buy.do?money=end">구매관리</a>
                <a href="mypage_sale.do?sale=end">판매관리</a>
                <a href="mypage_emoney.do?emoney=main">e머니관리</a>
                <a href="mypage_bankAcc.do">계좌관리</a>
                <a href="mypage_grade.do" style="background-color: lightseagreen;">등급관리</a>
        
        
            </div>    
            <div id="main">
                
                <div id=contents>


                    <div class="content">

                       <h4>회원등급</h4>
                       <div class="grade-content">
                        
                            <img src="image/general.png">
                            <span>${dto.nickname }님의 회원등급은 ${rankDto.rank_name }입니다.</span>
                            <div style="border-left: black solid 1px; ; padding-left: 50px;">
                                <div>거래총액 : ${dto.tx_amount }원</div>

                      
                    </div>


                    <div class="item">
                       
                     </div>

         		</div>
                  
            </div>    
        </div>
    </section>
</body>
</html>