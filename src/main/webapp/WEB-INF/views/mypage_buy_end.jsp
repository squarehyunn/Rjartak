<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <!-- 인코딩 처리 -->    
<%
    	request.setCharacterEncoding("UTF-8");
    %>    
<%
    	response.setContentType("text/html; charset=UTF-8");
    %>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알잘딱 - 화상 채팅 경매 서비스</title>
<link rel="icon" type="image/png" sizes="32x32" href="resources/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="resources/images/favicon-16x16.png">
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/mypage/mypage_buy_sale.css">

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
                <a href="mypage_buy.do?money=end"  style="background-color: lightseagreen;">구매관리</a>
                <a href="mypage_sale.do?sale=end">판매관리</a>
                <a href="mypage_emoney.do?emoney=main">e머니관리</a>
                <a href="mypage_bankAcc.do">계좌관리</a>
                <a href="mypage_grade.do">등급관리</a>
        
            </div>    
            <div id="main">
                 
                <div id=contents>
                    <h4>구매관리</h4>
                    <div class="emoney-contentBox">
                            <button onclick="location.href='mypage_buy.do?money=ing'">입찰중인 물품</button>
                            <button onclick="location.href='mypage_buy.do?money=end'">경매종료 물품</button>
                            <button onclick="location.href='mypage_buy.do?money=trading'">구매 물품 거래 진행 중</button>
                            <button onclick="location.href='mypage_buy.do?money=failure'">구매종료/보류</button>

    
                    
                    </div>
						<div class="content">
                    
                        <h4>경매종료목록</h4>
                        <c:choose>
	                    	<c:when test="${empty productlist }">
	                    		<table class="type11">
	                    			<tr>
	                    				<td>입찰내역이 없습니다.</td>
	                    			</tr>
	                    		</table>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<c:forEach var="list1" items="${productlist }" varStatus="status">
                            <table class="type11">
                                <thead>
                                <tr>
                                  <th scope="cols">물품번호</th>
                                  <th scope="cols">이미지</th>
                                  <th scope="cols">물품명</th>
                                  <th scope="cols">낙찰가</th>
                                  <th scope="cols">조회수</th>
                                  <th scope="cols">마감일</th>
                                  <th scope="cols">판매자</th>
                                  <th scope="cols">입찰결과</th>

                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                  <td><a href="productDetail?auction_no=${list1.auction_no}">${list1.auction_no }</a></td>
                                  <td><img src="resources/product/${list1.product_img}"></td>                                  
                                  <td>${list1.auction_title}</td>
                                  <td><!-- 낙찰가 -->${tradeList[status.index].final_bid_price  }</td>
                                  <td>${list1.auction_hits}</td>
                                  <td>${list1.endDateStr}</td>
                                  <td>${list1.nickname}</td>
                              <c:choose>
                                  <c:when test=" ${empty chk[status.index].final_bid_price}">
                                  	<td>유찰</td>
                                  </c:when>
                                  <c:otherwise>
                                  	<td>낙찰</td>
                                  </c:otherwise>
                             </c:choose>     
                                 
                                  

                                </tr>
                              
                                </tbody>
                              </table>
                             </c:forEach>
                            </c:otherwise>
                           </c:choose>
                            
                     </div>
<!--                     <div class="content"> -->
<!--                         <h4>경매종료 목록</h4> -->
<!--                             <table class="type11"> -->
<!--                                 <thead> -->
<!--                                 <tr> -->
<!--                                   <th scope="cols">물품번호</th> -->
<!--                                   <th scope="cols">이미지</th> -->
<!--                                   <th scope="cols">물품명</th> -->
<!--                                   <th scope="cols">낙찰가</th> -->
<!--                                   <th scope="cols">입찰</th> -->
<!--                                   <th scope="cols">조회</th> -->
<!--                                   <th scope="cols">마감일</th> -->
<!--                                   <th scope="cols">판매자</th> -->
<!--                                   <th scope="cols">입찰결과</th> -->

<!--                                 </tr> -->
<!--                                 </thead> -->
<!--                                 <tbody> -->
<!--                                 <tr> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->
<!--                                   <td>내용</td> -->

<!--                                 </tr> -->
                              
<!--                                 </tbody> -->
<!--                               </table> -->
                            
<!--                      </div> -->

                    <div class="item">
                       
                     </div>

         
                  
            </div>    
        </div>
    </section>
</body>
</html>