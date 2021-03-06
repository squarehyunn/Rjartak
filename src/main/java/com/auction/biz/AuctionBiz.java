package com.auction.biz;

import java.util.List;
import java.util.Map;

import com.auction.dto.AuctionDto;
import com.auction.dto.auction_interestedDto;
import com.util.pagingDto;

public interface AuctionBiz {
	
	//경매 등록
	public int insertProductBiz(AuctionDto auctiondto);
	//경매 리스트
	public List<AuctionDto> selectProductListBiz(int pageNum, int auctionType);
	//경매 리스트 카운트
	public pagingDto productListCountBiz(int pageNum, int auctionType);
	//경매 단일 조회
	public AuctionDto productDetailBiz(int auction_no);
	//경매 종료 리스트 갱신
	public int TimeOutListBiz();
	//경매 종료(단일)
	public int TimeOutBiz(Map<String,Object> data);
	//마감 임박
	public List<AuctionDto> DeadlineProductListBiz(int pageNum);
	//마감 임박 경매 리스트 카운트
	public pagingDto DeadProductListCountBiz(int pageNum);
	//인기 경매
	public List<AuctionDto> PopularProductListBiz(int pageNum);
	//인기 경매 리스트 카운트
	public pagingDto PopularListCountBiz(int pageNum);
	//관심상품 등록
	public int insertInterested(auction_interestedDto dto);
	//관심상품리스트
	public List<AuctionDto> selectInterestedListBiz(int pageNum,String buy_nickname);
	//관심상품리스트카운트
	public pagingDto interestedListCountBiz(int pageNum);
	//관심상품중복체크
	public auction_interestedDto interestedListChk(int auction_no,String nickname);
	//마이페이지에서 구매관리에 쓰이는
	public List<AuctionDto> MyProductListBiz(Map<String,int[]> map);
	
	//마이페이지 판매목록
	public List<AuctionDto> MysaleListBiz(String nickname);
	//마이페이지 판매목록-종료
	public List<AuctionDto> MysalelistEndBiz(String nickname);
	//검색기능
	public List<AuctionDto> searchforBiz(int pageNum, String search, int category);

	//auction삭제
	public int deleteAuctionBiz(int auction_no);
	//관심물품삭제
	public int deleteInterestBiz(int auction_no);
}
