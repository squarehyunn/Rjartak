<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/mypage/mypage_buy_sale.css">
<body>
  <header>header</header>
    <nav></nav>
    
    <section>
        <h1 style="margin-left: 5px;">마이페이지</h1>
        
        <div id="navi" name="navi">
            <div id="navi_text">
            <a href="#">활동</a>
            <a href="#">메시지</a>
            <a href="#">계정</a>
             </div>
        </div>
        
        <div id="grid">
            <div id="left-grid">
                <a href="#">관심상품</a>
                <a href="#">구매관리</a>
                <a href="#">판매관리</a>
                <a href="#">e머니관리</a>
                <a href="#">계좌관리</a>
                <a href="#">등급관리</a>
            </div>    
            <div id="main">
                 
                <div id=contents>
                    <h4>구매관리</h4>
                    <div class="emoney-contentBox">
                        
                        <button>진행중인 물품</button>
                        <button>판매종료 물품</button>
                        <button>판매물품 거래 진행 중</button>
                        <button>구매거부/반품/미입금</button>
                

    
                    
                    </div>

                    <div class="content">
                        <h4>구매거부/반품/미입금 목록</h4>
                            <table class="type11">
                                <thead>
                                <tr>
                                  <th scope="cols">물품번호</th>
                                  <th scope="cols">이미지</th>
                                  <th scope="cols">물품명</th>
                                  <th scope="cols">금액정보</th>
                                  <th scope="cols">구매자</th>
                                  <th scope="cols">현재상태</th>
                                  <th scope="cols">처리현황</th>
                                  <th scope="cols">날짜정보</th>
                                  <th scope="cols">관리</th>

                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                  <td>내용</td>
                                  <td>내용</td>
                                  <td>내용</td>
                                  <td>내용</td>
                                  <td>내용</td>
                                  <td>내용</td>
                                  <td>내용</td>
                                  <td>내용</td>
                                  <td>내용</td>

                                </tr>
                              
                                </tbody>
                              </table>
                            
                     </div>

                    <div class="item">
                       
                     </div>

         
                 </div>
            </div>    
        </div>
    </section>
</body>
</html>