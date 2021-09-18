package com.auction.dao;

import java.util.List;
import java.util.Map;

import com.auction.dto.AuctionDto;
import com.auction.dto.auction_interestedDto;

public interface AuctionDao {
	String NAMESPACE = "auction.";
	
	//경매 등록
	public int InsertProduct(AuctionDto auctiondto);
	
	//경매 리스트
	public List<AuctionDto> selectProductList(int pageNum, int auctionType);
	
	//경매 리스트 카운트
	public int productListCount(int auctionType);
	
	//경매 단일 조회
	public AuctionDto selectProductDetail(int auction_no);
	
	//경매 종료(단일)
	public int auctionTimeOver(int auction_no);

	//경매 종료 갱신(리스트)
	public int auctionTimeOverList();
	//관심상품등록
	public int insertInterested(auction_interestedDto dto);
	//관심상품리스트
	public List<AuctionDto> selectInterestedList(int pageNum,String buy_nickname);
	//관심상품리스트카운트
	public int interestedListCount();
	//관심상품중복체크
	public auction_interestedDto interestedListChk(int auction_no,String nickname);
	//마이페이지의 구매관리에서 쓰이는
	public List<AuctionDto> MyProductList(Map<String,int[]> map);

	
	
}
