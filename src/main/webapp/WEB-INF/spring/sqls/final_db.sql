--FINAL_ADMIN 계정으로 접속하고 진행

/* DELETE TABLE */
DROP TABLE MEMBER_LEVEL CASCADE CONSTRAINTS;
DROP TABLE MEMBER_RANK CASCADE CONSTRAINTS;
DROP TABLE MEMBER_STATUS CASCADE CONSTRAINTS;
DROP TABLE MEMBER CASCADE CONSTRAINTS;

DROP TABLE BANK_CODE CASCADE CONSTRAINTS;
DROP TABLE ACCOUNT CASCADE CONSTRAINTS;
DROP TABLE WITHDRAWAL CASCADE CONSTRAINTS;

DROP TABLE AUCTION_STATUS CASCADE CONSTRAINTS;
DROP TABLE AUCTION_TYPE CASCADE CONSTRAINTS;
DROP TABLE AUCTION CASCADE CONSTRAINTS;
DROP TABLE BOOKMARK CASCADE CONSTRAINTS;

DROP TABLE BIDS CASCADE CONSTRAINTS;
DROP TABLE TRADE_STATUS CASCADE CONSTRAINTS;

DROP TABLE TRADE CASCADE CONSTRAINTS;
DROP TABLE NOTICE CASCADE CONSTRAINTS;
DROP TABLE REPORT CASCADE CONSTRAINTS;

/* 시퀀스 */
DROP SEQUENCE MEMBER_LEVEL_SEQ;
DROP SEQUENCE MEMBER_RANK_SEQ;
DROP SEQUENCE MEMBER_STATUS_SEQ;
DROP SEQUENCE ACCOUNT_SEQ;
DROP SEQUENCE WITHDRAWAL_SEQ;
DROP SEQUENCE AUCTION_STATUS_SEQ;
DROP SEQUENCE AUCTION_TYPE_SEQ;
DROP SEQUENCE AUCTION_SEQ;
DROP SEQUENCE BOOKMARK_SEQ;
DROP SEQUENCE BIDS_SEQ;
DROP SEQUENCE TRADE_STATUS_SEQ;
DROP SEQUENCE TRADE_SEQ;
DROP SEQUENCE NOTICE_SEQ;
DROP SEQUENCE REPORT_SEQ;

COMMIT;

/* 회원 관련 테이블 */
--회원 레벨
CREATE SEQUENCE MEMBER_LEVEL_SEQ NOCACHE;
CREATE TABLE MEMBER_LEVEL(
    LEVEL_NO NUMBER PRIMARY KEY,
    LEVEL_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO MEMBER_LEVEL VALUES(MEMBER_LEVEL_SEQ.NEXTVAL, '정관리자');
INSERT INTO MEMBER_LEVEL VALUES(MEMBER_LEVEL_SEQ.NEXTVAL, '부관리자');
INSERT INTO MEMBER_LEVEL VALUES(MEMBER_LEVEL_SEQ.NEXTVAL, '회원');

--회원 등급
CREATE SEQUENCE MEMBER_RANK_SEQ NOCACHE;
CREATE TABLE MEMBER_RANK(
    RANK_NO NUMBER PRIMARY KEY,
    RANK_NAME VARCHAR2(30) NOT NULL,
    RATING_AMOUNT NUMBER NOT NULL
);


--회원상태
CREATE SEQUENCE MEMBER_STATUS_SEQ NOCACHE;
CREATE TABLE MEMBER_STATUS(
    STATUS_NO NUMBER PRIMARY KEY,
    STATUS_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO MEMBER_STATUS VALUES(MEMBER_STATUS_SEQ.NEXTVAL,'활동');
INSERT INTO MEMBER_STATUS VALUES(MEMBER_STATUS_SEQ.NEXTVAL,'정지');
INSERT INTO MEMBER_STATUS VALUES(MEMBER_STATUS_SEQ.NEXTVAL,'탈퇴');
--이메일 인증이 있다면, 미승인 상태도 필요


--회원
CREATE TABLE MEMBER(
    EMAIL VARCHAR2(100) PRIMARY KEY,
    NICKNAME VARCHAR2(100) UNIQUE NOT NULL,
    PASSWORD VARCHAR2(100) NOT NULL,
    GENDER VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(100) NOT NULL,
    BIRTH VARCHAR2(100) NOT NULL,
    CREATED_AT DATE NOT NULL,
    UPDATED_AT DATE NOT NULL,
    ADDRESS VARCHAR2(200) NOT NULL,
    ADDRESS_DETAIL VARCHAR2(200) NOT NULL,
    AMOUNT NUMBER NOT NULL,
    TX_AMOUNT NUMBER NOT NULL,
    LEVEL_NO NUMBER NOT NULL,
    STATUS_NO NUMBER NOT NULL,
    RANK_NO NUMBER NOT NULL,
    
    CONSTRAINT M_LEVEL FOREIGN KEY(LEVEL_NO) REFERENCES MEMBER_LEVEL(LEVEL_NO),
    CONSTRAINT M_STATUS FOREIGN KEY(STATUS_NO) REFERENCES MEMBER_STATUS(STATUS_NO),
    CONSTRAINT M_RANK FOREIGN KEY(RANK_NO) REFERENCES MEMBER_RANK(RANK_NO)
);


/* 계좌 및 출금 */

--은행코드
CREATE TABLE BANK_CODE(
    BANK_NO VARCHAR2(50) PRIMARY KEY,
    BANK_NAME VARCHAR2(50) NOT NULL
);
INSERT INTO BANK_CODE VALUES('001', '한국');
INSERT INTO BANK_CODE VALUES('002', '산업');
INSERT INTO BANK_CODE VALUES('003', '기업');
INSERT INTO BANK_CODE VALUES('004', 'KB국민');
INSERT INTO BANK_CODE VALUES('005', '하나');
INSERT INTO BANK_CODE VALUES('007', '수협');
INSERT INTO BANK_CODE VALUES('010', 'NH농협');
INSERT INTO BANK_CODE VALUES('020', '우리');
INSERT INTO BANK_CODE VALUES('021', '신한');
INSERT INTO BANK_CODE VALUES('090', '카카오뱅크');
--엄청 많아서 필요하면 추가해서 사용


--계좌
CREATE SEQUENCE ACCOUNT_SEQ NOCACHE;
CREATE TABLE ACCOUNT(
    ACCOUNT_NO NUMBER PRIMARY KEY,
    NICKNAME VARCHAR2(100) NOT NULL,
    BANK_NO VARCHAR2(50) NOT NULL,
    ACCOUNT_NUMBER NUMBER NOT NULL,
    
    CONSTRAINT ACCOUNT_NICK FOREIGN KEY(NICKNAME) REFERENCES MEMBER(NICKNAME),
    CONSTRAINT ACCOUNT_BANK FOREIGN KEY(BANK_NO) REFERENCES BANK_CODE(BANK_NO)
);

--출금요청
CREATE SEQUENCE WITHDRAWAL_SEQ NOCACHE;
CREATE TABLE WITHDRAWAL(
    WITHDRAWAL_NO NUMBER PRIMARY KEY,
    ACCOUNT_NO NUMBER NOT NULL,
    NICKNAME VARCHAR2(100) NOT NULL,
    AMOUNT NUMBER NOT NULL,
    WITHDRAWAL_STATUS VARCHAR2(30),
    
    CONSTRAINT WITH_ACCOUNT FOREIGN KEY(ACCOUNT_NO) REFERENCES ACCOUNT(ACCOUNT_NO),
    CONSTRAINT WITH_NICK FOREIGN KEY(NICKNAME) REFERENCES MEMBER(NICKNAME)
);

/* 경매 */
--경매상태
CREATE SEQUENCE AUCTION_STATUS_SEQ NOCACHE;
CREATE TABLE AUCTION_STATUS(
    AUCTION_STATUS_NO NUMBER PRIMARY KEY,
    AUCTION_STATUS_NAME VARCHAR2(50) NOT NULL
);
INSERT INTO AUCTION_STATUS VALUES(AUCTION_STATUS_SEQ.NEXTVAL, '진행중');
INSERT INTO AUCTION_STATUS VALUES(AUCTION_STATUS_SEQ.NEXTVAL, '거래중');
INSERT INTO AUCTION_STATUS VALUES(AUCTION_STATUS_SEQ.NEXTVAL, '종료');


--경매종류
CREATE SEQUENCE AUCTION_TYPE_SEQ NOCACHE;
CREATE TABLE AUCTION_TYPE(
    AUCTION_TYPE_NO NUMBER PRIMARY KEY,
    AUCTION_TYPE_NAME VARCHAR2(50) NOT NULL
);
INSERT INTO AUCTION_TYPE VALUES(AUCTION_TYPE_SEQ.NEXTVAL, '일반');
INSERT INTO AUCTION_TYPE VALUES(AUCTION_TYPE_SEQ.NEXTVAL, '블라인드');


--경매
CREATE SEQUENCE AUCTION_SEQ NOCACHE;
CREATE TABLE AUCTION(
    AUCTION_NO NUMBER PRIMARY KEY,
    AUCTION_TYPE_NO NUMBER NOT NULL,
    NICKNAME VARCHAR2(100) NOT NULL,
    AUCTION_STATUS_NO NUMBER NOT NULL,
    PRODUCT_NAME VARCHAR2(200) NOT NULL,
    AUCTION_TITLE VARCHAR2(100) NOT NULL,
    AUCTION_CONTENT VARCHAR2(3000) NOT NULL,
    PRODUCT_PRICE NUMBER NOT NULL,
    BIDDING_UNIT NUMBER NOT NULL,
    AUCTION_TIME DATE NOT NULL,
    CREATED_AT DATE NOT NULL,
    END_DATE DATE,
    ACCOUNT_HITS NUMBER NOT NULL,
    
    CONSTRAINT AUCTION_TY FOREIGN KEY(AUCTION_TYPE_NO) REFERENCES AUCTION_TYPE(AUCTION_TYPE_NO),
    CONSTRAINT AUCTION_ST FOREIGN KEY(AUCTION_STATUS_NO) REFERENCES AUCTION_STATUS(AUCTION_STATUS_NO),
    CONSTRAINT NICKNAME FOREIGN KEY(NICKNAME) REFERENCES MEMBER(NICKNAME)
);

--경매 즐겨찾기
CREATE SEQUENCE BOOKMARK_SEQ NOCACHE;
CREATE TABLE BOOKMARK(
    BOOKMARK_NO NUMBER PRIMARY KEY,
    AUCTION_NO NUMBER NOT NULL,
    NICKNAME VARCHAR2(100) NOT NULL,
    
    CONSTRAINT MARK_AUCTION FOREIGN KEY(AUCTION_NO) REFERENCES AUCTION(AUCTION_NO),
    CONSTRAINT MAKR_NICK FOREIGN KEY(NICKNAME) REFERENCES MEMBER(NICKNAME)  
);

/* 입찰 및 거래 */
--입찰
CREATE SEQUENCE BIDS_SEQ NOCACHE;
CREATE TABLE BIDS(
    BID_NO NUMBER PRIMARY KEY,
    NICKNAME VARCHAR2(100) NOT NULL,
    AUCTION_NO NUMBER NOT NULL,
    AUCTION_STATUS_NO NUMBER NOT NULL,
    BID_PRICE NUMBER NOT NULL,
    
    CONSTRAINT BID_NICK FOREIGN KEY(NICKNAME) REFERENCES MEMBER(NICKNAME),
    CONSTRAINT BID_AU_NO FOREIGN KEY(AUCTION_NO) REFERENCES AUCTION(AUCTION_NO),
    CONSTRAINT BID_AU_ST_NO FOREIGN KEY(AUCTION_STATUS_NO) REFERENCES AUCTION_STATUS(AUCTION_STATUS_NO)
);

--거래상태
CREATE SEQUENCE TRADE_STATUS_SEQ NOCACHE;
CREATE TABLE TRADE_STATUS(
    TRADE_STATUS_NO NUMBER PRIMARY KEY,
    TRADE_STATUS_NAME VARCHAR2(50) NOT NULL
);
INSERT INTO TRADE_STATUS VALUES(TRADE_STATUS_SEQ.NEXTVAL, '진행중');
INSERT INTO TRADE_STATUS VALUES(TRADE_STATUS_SEQ.NEXTVAL, '보류');
INSERT INTO TRADE_STATUS VALUES(TRADE_STATUS_SEQ.NEXTVAL, '종료');

--거래
CREATE SEQUENCE TRADE_SEQ NOCACHE;
CREATE TABLE TRADE(
    TRADE_NO NUMBER PRIMARY KEY,
    TRADE_STATUS_NO NUMBER NOT NULL,
    BID_NO NUMBER NOT NULL,
    AUCTION_NO NUMBER NOT NULL,
    BIDDER_NICKNAME VARCHAR2(100) NOT NULL,
    SELLER VARCHAR2(100) NOT NULL,
    FINAL_BID_PRICE NUMBER NOT NULL,
    
    CONSTRAINT T_ST_NO FOREIGN KEY(TRADE_STATUS_NO) REFERENCES TRADE_STATUS(TRADE_STATUS_NO),
    CONSTRAINT T_B_NO FOREIGN KEY(BID_NO) REFERENCES BIDS(BID_NO),
    CONSTRAINT T_AUC_NO FOREIGN KEY(AUCTION_NO) REFERENCES AUCTION(AUCTION_NO)
);

/* 게시판 */
--공지사항
CREATE SEQUENCE NOTICE_SEQ NOCACHE;
CREATE TABLE NOTICE(
    NOTICE_NO NUMBER PRIMARY KEY,
    NICKNAME VARCHAR2(100) NOT NULL,
    NOTICE_TITLE VARCHAR2(200) NOT NULL,
    NOTICE_CONTENT VARCHAR2(3000) NOT NULL,
    CREATED_AT DATE NOT NULL,
    UPDATED_AT DATE NOT NULL,
    
    CONSTRAINT NO_NICK FOREIGN KEY(NICKNAME) REFERENCES MEMBER(NICKNAME)
);
--신고
CREATE SEQUENCE REPORT_SEQ NOCACHE;
CREATE TABLE REPORT(
    REPORT_NO NUMBER PRIMARY KEY,
    NICKNAME VARCHAR2(100) NOT NULL,
    TARGET_NICKNAME VARCHAR2(100) NOT NULL,
    REPORT_TYPE VARCHAR2(1000) NOT NULL,
    
    CONSTRAINT RE_NICK FOREIGN KEY(NICKNAME) REFERENCES MEMBER(NICKNAME),
    CONSTRAINT RE_TAR_NICK FOREIGN KEY(TARGET_NICKNAME) REFERENCES MEMBER(NICKNAME)
);

COMMIT;

-- 8/31 수정
ALTER TABLE MEMBER RENAME COLUMN AMMOUNT TO AMOUNT;
COMMIT;

-- 9/1 수정
ALTER TABLE REPORT ADD REPORT_CONTENT VARCHAR2(1000) NOT NULL;
ALTER TABLE REPORT ADD CREATED_AT DATE NOT NULL;
ALTER TABLE REPORT ADD UPDATED_AT DATE NOT NULL;
ALTER TABLE REPORT ADD REPORT_TITLE VARCHAR2(100) NOT NULL;

ALTER TABLE WITHDRAWAL ADD CREATED_AT DATE NOT NULL;
ALTER TABLE WITHDRAWAL ADD UPDATED_AT DATE NOT NULL;





ALTER TABLE MEMBER ADD PHONE VARCHAR2(100) NOT NULL;

COMMIT;


-- 9/2 추가(쪽지table)
DROP TABLE MESSAGE;
CREATE TABLE MESSAGE(
    MESSAGE_ID NUMBER PRIMARY KEY,
    MESSAGE_SENDER VARCHAR2(45) DEFAULT NULL,
    MESSAGE_RECEIVER VARCHAR2(45) DEFAULT NULL,
    MESSAGE_CONTENT VARCHAR2(500) DEFAULT NULL,
    MESSAGE_SENDTIME DATE DEFAULT SYSDATE,
    CHATROOM_CHATROOM_ID NUMBER DEFAULT NULL,
    MESSAGE_READTIME DATE,
    USER_USER_ID VARCHAR2(45) DEFAULT NULL,
    TUTOR_USER_USER_ID VARCHAR2(45) DEFAULT NULL,
    CLASS_CLASS_ID NUMBER DEFAULT NULL

);


--9/6 수정
ALTER TABLE AUCTION DROP COLUMN AUCTION_TIME;
ALTER TABLE AUCTION RENAME COLUMN ACCOUNT_HITS TO AUCTION_HITS;
ALTER TABLE AUCTION ADD PRODUCT_IMG VARCHAR2(300) NOT NULL;


COMMIT;

--9/7 수정
ALTER TABLE AUCTION ADD CURRENT_PRICE NUMBER NOT NULL;


--9/13 수정
ALTER TABLE BIDS ADD BIDDING_TIME DATE NOT NULL;
ALTER TABLE BIDS DROP COLUMN AUCTION_STATUS_NO;
COMMIT;

--9/11 수정
ALTER TABLE MEMBER ADD ADDRESS_DETAIL2 VARCHAR(300) NOT NULL;

--9/14 수정
ALTER TABLE AUCTION ADD HIGH_BIDDER VARCHAR(100);
COMMIT;

--9/14수정
CREATE TABLE INTERESTED_AUCTIONS(
    INTERESTED_AUCTION_NO NUMBER PRIMARY KEY,
    SELL_NICKNAME VARCHAR2(100) NOT NULL,
    BUY_NICKNAME VARCHAR2(100) NOT NULL
);
COMMIT;
