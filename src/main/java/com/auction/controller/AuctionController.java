package com.auction.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.auction.biz.AuctionBiz;
import com.auction.dto.AuctionDto;
import com.util.UtilFileUpload;

@Controller
public class AuctionController {
	
	Logger logger = LoggerFactory.getLogger(AuctionController.class);
	
	@Autowired
	private UtilFileUpload utilFileUpload;
	@Autowired
	private AuctionBiz auctionbiz;
	
	
	//경매 디테일
	@RequestMapping("/productDetail")
	public String product(Model model, @RequestParam("auction_no")int auction_no) {
		logger.info("[PRODUCT DETAIL]");
		
		AuctionDto productDetail = auctionbiz.productDetailBiz(auction_no);
		model.addAttribute("productDetail", productDetail);
		return "product";
	}
	
	//경매 리스트
	@RequestMapping("/productlist")
	public String list(HttpServletRequest request,Model model, @RequestParam("pageNum")int pageNum, @RequestParam("type")int auctionType) {
		
		int result = auctionbiz.TimeOutListBiz();
		List<AuctionDto> productList = null;
		if(result>0) {
			productList = auctionbiz.selectProductListBiz(pageNum, auctionType);
		}
		model.addAttribute("productList", productList);
		
		return "productList";
	}
	
	//경매 등록 폼
	@RequestMapping(value = "/productAddForm.log", method = RequestMethod.GET)
	public String productAddForm() {
		logger.info("[PRODUCT FORM CONTROLLER]");
		return "productAdd";
	}
	
	//경매 등록
	@RequestMapping(value = "/productAdd.log", method = RequestMethod.POST)
	public String productAdd(Model model, MultipartHttpServletRequest request, 
			@RequestParam("uploadImg")MultipartFile uploadFile,
			@RequestParam("title")String title, @RequestParam("productName")String productName,
			@RequestParam("content")String content, @RequestParam("productPrice")int productPrice,
			@RequestParam("biddingUnit")int biddingUnit, @RequestParam("auctionType")int auctionType,
			@RequestParam("endDate")String endDate, @RequestParam("endTime")String endTime
			) {
		logger.info("[PRODUCT ADD CONTROLLER]");
		//닉네임
		String nickname = (String)request.getSession().getAttribute("nickname");
		//날짜 계산
		String dateTime = endDate + " " + endTime + ":00";
		//파일업로드
		String fileName = utilFileUpload.fileUpload(request, uploadFile, "resources/product");
		//상품 dto
		AuctionDto auction = new AuctionDto();
		auction.setAuction_title(title);
		auction.setProduct_name(productName);
		auction.setAuction_content(content);
		auction.setProduct_price(productPrice);
		auction.setBidding_unit(biddingUnit);
		auction.setAuction_type_no(auctionType);
		//닉네임, 날짜 계산, 파일 이름
		auction.setNickname(nickname);
		auction.setEndDateStr(dateTime);
		auction.setProduct_img(fileName);
		
		System.out.println("content: " + content);
		
		int result = auctionbiz.insertProductBiz(auction);
		
		
		model.addAttribute("pageNum",1);
		model.addAttribute("type",auctionType);
		if(result>0) {
			model.addAttribute("msg","경매가 등록되었습니다");
			model.addAttribute("url", "productlist");
			return "auctionAlert";
		}else {
			model.addAttribute("msg","경매 등록에 실패했습니다");
			model.addAttribute("url", "productAddForm.log");
			return "auctionAlert";
		}
		
	}
	
	//경매 종료 컨트롤러
	@RequestMapping(value="/timeOut", method= RequestMethod.POST)
	public @ResponseBody Map<String, Object> timeOut(@RequestBody Map<String,Object> auctionData){
		
		System.out.println("실행");
		int result = auctionbiz.TimeOutBiz(auctionData);
		
		Map<String,Object> data = new HashMap<String, Object>();
		if(result>0) {	
			data.put("status", HttpStatus.OK);
			return data;
		}else {
			data.put("status", HttpStatus.BAD_REQUEST);
			return data;
		}
		
	}
	
	
	@RequestMapping("/streaming")
	public String streaming() {
		return "streaming";
	}
	
	
	
}
