package com.member.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.amount.biz.AmountBiz;
import com.amount.dto.BankAccountDto;
import com.auction.biz.AuctionBiz;
import com.auction.dto.AuctionDto;
import com.bids.biz.BidsBiz;
import com.bids.dto.BidsDto;
import com.member.biz.MemberBiz;
import com.member.dto.MemberDto;
import com.member.dto.MemberRankDto;
import com.trade.biz.TradeBiz;
import com.trade.dao.TradeDao;
import com.trade.dto.TradeDto;
import com.util.pagingDto;

@Controller
public class MemberController {

	Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	private MemberBiz memberbiz;
	@Autowired

	private AmountBiz amountbiz;
	@Autowired
	private AuctionBiz auctionbiz;
	@Autowired
	private BidsBiz bidsbiz;
	@Autowired
	private TradeBiz tradebiz;
	
	private JavaMailSender mailSender;
	
	//로그인 폼 전환
	@RequestMapping(value="/loginForm", method=RequestMethod.GET)
	public String loginForm() {
		logger.info("LOGIN FORM");
		return "login";
	}
	
	//회원가입 폼 전환
	@RequestMapping(value="/joinForm", method=RequestMethod.GET)
	public String joinForm() {
		logger.info("JOIN FORM");
		return "join";
	}
	
	//회원가입
	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String insert(MemberDto dto) {
		int res = memberbiz.insert(dto);
		
		if(res>0) {
			return "redirect:loginForm";
		}else {
			return "redirect:joinForm";
		}
		
		
	}
	
	//이메일 인증
	@RequestMapping(value = "/mailCheck", method = RequestMethod.GET)
	@ResponseBody
	public String mailCheckGET(String email) throws Exception{
		//화면단에서 넘어온 데이터 확인
		logger.info("이메일 데이터 확인");
		logger.info("이메일 : " + email);
		
		//인증번호 난수 생성
		Random random = new Random();
		int checkNum = random.nextInt(888888)+111111;
		logger.info("인증번호 : " + checkNum);
	
		//이메일 보내기
		String setFrom = "xian931231@gmail.com";
		String toMail = email;
		String title = "회원가입 인중 이메일 입니다.";
		String content = 
				"저희 홈페이지를 방문해주셔서 감사합니다."+"<br><br>"+
				"인증번호는 "+checkNum+"입니다."+
				"<br>"+"해당 인증번호를 인증번호 확인란에 기입하여 주세요.";
	
	
		try {
            
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);
            helper.setText(content,true);
            mailSender.send(message);
            
        }catch(Exception e) {
            e.printStackTrace();
        }
 		
		String num = Integer.toString(checkNum);
	
		return num;
	
	}
	
	
	//로그인
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> login(HttpSession session, @RequestBody MemberDto reqMember) {
		logger.info("LOGIN CONTROLLER");

		MemberDto loginMember = memberbiz.login(reqMember);
		Map<String,Object> data = new HashMap<String, Object>();
		if(loginMember==null) {
			data.put("status_code", HttpStatus.UNAUTHORIZED); // 401
			return data;
		}else {
			session.setAttribute("email", loginMember.getEmail());
			session.setAttribute("nickname", loginMember.getNickname());
			session.setAttribute("level_no", loginMember.getLevel_no());
			data.put("status_code", HttpStatus.OK); // 200
			return data;
		}
	}
	
	//로그아웃
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(HttpSession session) {
		logger.info("LOGOUT");
		session.invalidate();
		return "redirect:main2.do";
	}
	
	//로그인 체크(인터셉터 활용)
	@RequestMapping(value="/loginCheck", method=RequestMethod.GET)
	public String loginCheck(Model model) {
		model.addAttribute("msg","로그인 후 이용해주세요");
		model.addAttribute("url","loginForm");
		return "alert";
	}

// --------------  마이페이지 관련------------------------------- 
	//마이페이지-회원정보조회
	@RequestMapping("/mypage.do")
	public String mypage(Model model,HttpSession session, HttpServletRequest request) {
		session = request.getSession();
		String email = (String)session.getAttribute("email");
		model.addAttribute("dto",memberbiz.selectOne(email));
		return "mypage_personal_information";
	}
	


	//관심상품목록출력
			@RequestMapping("/mypage_interest.do")
			public String interestedlist(HttpSession session, HttpServletRequest request,Model model, @RequestParam("pageNum")int pageNum) {
				session = request.getSession();
				
				String buy_nickname = (String)session.getAttribute("nickname");
				int result = auctionbiz.TimeOutListBiz();
				List<AuctionDto> productList = null;
				if(result>0) {
					productList = auctionbiz.selectInterestedListBiz(pageNum,buy_nickname);
				}
				pagingDto paging = auctionbiz.interestedListCountBiz(pageNum);
				model.addAttribute("paging", paging);
				model.addAttribute("productList", productList);
				
				return "mypage_interest";
			}
			
	
	//활동-계좌관리로 이동
	@RequestMapping("/mypage_bankAcc.do")
	public String mypage_bankAcc() {
		
		return "mypage_bankAccount";
		
	}
	
	//활동-계좌등록기능
	@RequestMapping("/insertBankAcc.do")
	public String insertBank(HttpSession session, HttpServletRequest request, String used_bankname,String bank_account) {
		session = request.getSession();
		String nickname = (String)session.getAttribute("nickname");
				
		System.out.println("used_bankname:"+used_bankname);
		String account_number = amountbiz.getBankNo(used_bankname);
		System.out.println(account_number);
		BankAccountDto bankacc = new BankAccountDto();
		bankacc.setNickname(nickname);
		bankacc.setBank_no(account_number);
		bankacc.setAccount_number(bank_account);
		int res = memberbiz.insertBank(bankacc);
		if(res>0) {
			System.out.println("성공");
		}else {
			System.out.println("실패");
		}
		
		return "mypage_bankAccount";
	}
	
	//활동 -구매관리로이동
	@RequestMapping("/mypage_buy.do")
	public String mypage_buy(Model model,String money,HttpSession session,HttpServletRequest request) {
		session = request.getSession();
		String nickname = (String)session.getAttribute("nickname");
		
		List<BidsDto> list = null;

		if(money.equals("end")) {
			int auction_stat = 3;
			try {
				list = bidsbiz.bidList(nickname,auction_stat);
				int[] Arr = new int[list.size()];
				Map<String,int[]> map = new HashMap<>();
				for(int i=0; i<list.size();i++) {
					Arr[i] = list.get(i).getAuction_no();
				}
				map.put("Auction_no", Arr);
				
				
				List<AuctionDto> productlist = auctionbiz.MyProductListBiz(map);
				model.addAttribute("productlist", productlist);
				
				//낙찰값 가져오기 : 위에서 가져온 auction_no통해서 TRADE에서 LIST가져오기
				List<TradeDto> tradeList = tradebiz.tradeListBiz(map);
				model.addAttribute("tradeList",tradeList);
				
				
				Map<String,Object> Chkmap = new HashMap<>();
					Chkmap.put("auction_no",Arr);
					String[] str = new String[1];
					str[0] = nickname;
	 				Chkmap.put("nickname",str);
				List<TradeDto> chk = tradebiz.tradeListChkBiz(Chkmap);
				model.addAttribute("chk",chk);
			
			} catch (Exception e) {
				System.out.println("[error]list에 값이 없음 ");
				e.printStackTrace();
			}
				
			
			
			return "mypage_buy_end";
		}else if(money.equals("failure")) {
			List<TradeDto> auctionNolist = tradebiz.tradeAuctionNoList_failBiz(nickname);
			//
			int[] Arr = new int[auctionNolist.size()];
			Map<String,int[]> map = new HashMap<>();
			for(int i=0; i<auctionNolist.size();i++) {
				Arr[i] =auctionNolist.get(i).getAuction_no();
			}
			map.put("Auction_no", Arr);
			
			List<AuctionDto> productlist = auctionbiz.MyProductListBiz(map);
			model.addAttribute("productlist", productlist);
			
			//낙찰상태 가져오기 : 위에서 가져온 auction_no통해서 TRADE에서 LIST가져오기
			List<TradeDto> tradeList = tradebiz.tradeListBiz(map);
			model.addAttribute("tradeList",tradeList);
			
			
			return "mypage_buy_failure";
		}else if(money.equals("ing")) {
			//auction_stat과 nicnkname으로 bidList에서 조건에 맞는 auction_no 뽑아서 array에 담는다.
			int auction_stat = 1;
			list = bidsbiz.bidList(nickname,auction_stat);
			int[] Arr = new int[list.size()];
			
			//위에서 가져온 auction_no통해 auction테이블에서 리스트로 쫙뽑아서 map에다가 저장
			Map<String,int[]> map = new HashMap<>();
			for(int i=0; i<list.size();i++) {
				Arr[i] = list.get(i).getAuction_no();
			}
			map.put("Auction_no", Arr);
			
			List<AuctionDto> productlist = auctionbiz.MyProductListBiz(map);
			model.addAttribute("productlist", productlist);
			
			
			return "mypage_buy_ing";
		}else{
			List<TradeDto> auctionNolist = tradebiz.tradeAuctionNoListBiz(nickname);
			if(auctionNolist!=null) {
				int[] Arr = new int[auctionNolist.size()];
				Map<String,int[]> map = new HashMap<>();
				for(int i=0; i<auctionNolist.size();i++) {
					Arr[i] =auctionNolist.get(i).getAuction_no();
				}
				map.put("Auction_no", Arr);
				
				List<AuctionDto> productlist = auctionbiz.MyProductListBiz(map);
				model.addAttribute("productlist", productlist);
				
			}
			
			
			return "mypage_buy_trading";
		}
	}
	
	//활동-판매페이지이동
	@RequestMapping("/mypage_sale.do")
	public String mypage_sale(String sale,Model model,String money,HttpSession session,HttpServletRequest request) {
		session = request.getSession();
		String nickname = (String)session.getAttribute("nickname");
		
		List<BidsDto> list = null;

		if(sale.equals("end")) {
			//auction_stat = 3인 것들 가져오긴
			List<AuctionDto> productlist;
			try {
				productlist = auctionbiz.MysalelistEndBiz(nickname);
				model.addAttribute("productlist", productlist);

			} catch (Exception e) {
				System.out.println("auction_stat=3이고 , nickname이 구매자 해당하는 auction목록이없음");
				e.printStackTrace();
			}
			
			return "mypage_sale_end";
		}else if(sale.equals("failure")) {
			List<TradeDto> auctionNolist = tradebiz.tradeAuctionNoList_failBiz(nickname);
			
			int[] Arr = new int[auctionNolist.size()];
			Map<String,int[]> map = new HashMap<>();
			for(int i=0; i<auctionNolist.size();i++) {
				Arr[i] =auctionNolist.get(i).getAuction_no();
			}
			map.put("Auction_no", Arr);
			
			List<AuctionDto> productlist = auctionbiz.MyProductListBiz(map);
			model.addAttribute("productlist", productlist);
			
			//낙찰상태 가져오기 : 위에서 가져온 auction_no통해서 TRADE에서 LIST가져오기
			List<TradeDto> tradeList = tradebiz.tradeListBiz(map);
			model.addAttribute("tradeList",tradeList);
			
			
			return "mypage_sale_failure";
		}else if(sale.equals("ing")) {
			List<AuctionDto> productlist = auctionbiz.MysaleListBiz(nickname);
			model.addAttribute("productlist", productlist);
			
			
			return "mypage_sale_ing";
		}else{
			List<TradeDto> auctionNolist = tradebiz.SellertradeAuctionNoListBiz(nickname);
			if(auctionNolist!=null) {
				int[] Arr = new int[auctionNolist.size()];
				Map<String,int[]> map = new HashMap<>();
				for(int i=0; i<auctionNolist.size();i++) {
					Arr[i] =auctionNolist.get(i).getAuction_no();
				}
				map.put("Auction_no", Arr);
				
				List<AuctionDto> productlist = auctionbiz.MyProductListBiz(map);
				model.addAttribute("productlist", productlist);
				model.addAttribute("auctionlist",auctionNolist);
			}
			
			return "mypage_sale_trading";
		}
	}
	
	//활동-마이페이지-이머니페이지로 이동
	@RequestMapping("/mypage_emoney.do")
	public String mypage_emoney(Model model,HttpSession session,HttpServletRequest request,String emoney) {
		session = request.getSession();
		String email = (String)session.getAttribute("email");
		MemberDto dto = memberbiz.selectOne(email);
		
		String nickname= (String) session.getAttribute("nickname");
		List<BankAccountDto> AccountNoList = amountbiz.getAccountNo(nickname);

		
		model.addAttribute("dto",dto);
		model.addAttribute("AccountNoList",AccountNoList);
		if(emoney.equals("main")) {
			return "mypage_emoney_main";
		}else if(emoney.equals("charge")) {
			return "mypage_emoney_charge";
		}else {
			return "mypage_emoney_withdrawal";
		}
	}
	
	//활동-이머니 충전
	@RequestMapping(value="/charge.do",method=RequestMethod.GET)
	@ResponseBody
	public int charge_emoney(MemberDto dto) {
		System.out.println("결제금액: "+dto.getAmount()+"email :"+dto.getEmail());		
		int ChargeEmoney = dto.getAmount();//충전금액
		int beforeEmoney = (memberbiz.selectOne(dto.getEmail())).getAmount();//현재보유금액
		int newEmoney = beforeEmoney+ChargeEmoney;//새로운 보유금액 = 현재보유금액 + 충전금액
		dto.setAmount(newEmoney);//새로운 보유금액을 dto에 저장
		
		int res = memberbiz.updateInfo_Emoney(dto);//저장한 금액을 업데이트
		return res;
	}
	
	//활동-등급관리
	@RequestMapping("/mypage_grade.do")
	public String mypage_grade(String grade,HttpServletRequest request,Model model) {
		HttpSession session = request.getSession();
		String email = (String)session.getAttribute("email");
		
		MemberDto dto = memberbiz.selectOne(email);
		
		int rank_no = dto.getRank_no();
		
		MemberRankDto rankDto = memberbiz.rank(rank_no);
		
		String rank = (String)rankDto.getRank_name();
		
		System.out.println(rank);
		
		model.addAttribute("rankDto", rankDto);
		model.addAttribute("dto", dto);
		
		return "mypage_grade";
	}

	

	
	//메시지-받은메시지로 이동
	@RequestMapping("/mypage_msg_receive.do")
	public String msg_receive() {
		return "mypage_message_receive";
	}
	//메시지-보낸메시지로 이동
	@RequestMapping("/mypage_msg_send.do")
	public String msg_send() {
		return "mypage_message_send";
	}
	
	
	//계정-회원정보변경
	@ResponseBody
	@RequestMapping(value="/update_info.do")
	public String update_Info(MemberDto dto,Model model) {
		logger.info("update res");
		int res = memberbiz.updateInfo(dto);
		String resultMsg = "";
		if(res>0) {
			resultMsg = "<script>alert('SUCCESS!');location.href='mypage.do?email="+dto.getEmail()+"'</script>";
		}else {
			resultMsg = "<script>alert('FAIL!');location.href='mypage.do?email="+dto.getEmail()+"'</script>";
		}
		return resultMsg;
	}
	
	@RequestMapping("/message_test.do")
	public String message_test() {

		return "message_test";
	}
	
	//회원탈퇴페이지
		@RequestMapping("/mypage_quit.do")
		public String mypage_quit(Model model, HttpSession session, HttpServletRequest request) {
			session = request.getSession();
			String email = (String)session.getAttribute("email");
			MemberDto dto = memberbiz.selectOne(email);
			model.addAttribute("dto",dto);

			return "mypage_personal_quit";
		}
		//회원정보삭제(탈퇴)
		@ResponseBody
		@RequestMapping(value="/deleteInfo.do",method=RequestMethod.GET)
		public String delete(HttpSession session,HttpServletRequest request) {
			logger.info("delete res");
			session = request.getSession();
			String email = (String)session.getAttribute("email");
			System.out.println("email="+email);
			int res = memberbiz.deleteInfo(email);
			String resultMsg="";
			if(res>0) {
				resultMsg="<script>alert('SUCCESS!');location.href='logout'</script>";
			}else {
				resultMsg="<script>alert('FAIL!');location.href='mypage_quit.do?'</script>";

			}

			return resultMsg;
		}

	
	
	
	
	
	
	
	
	
	
}
