/*유저 ---------------------------------------- */
CREATE TABLE GGHJ_USER
(
    USER_ID       NUMBER,--PK
    USER_NAME     VARCHAR2(20)  NOT NULL,
    USER_PASSWORD VARCHAR2(255) NOT NULL,
    USER_EMAIL    VARCHAR2(255) NOT NULL UNIQUE,
    USER_NICKNAME VARCHAR2(20)  NOT NULL UNIQUE,
    USER_BIRTH    DATE          NOT NULL,
/*    user_isadmin  char(1)      default '0',*/
    CONSTRAINT PK_USER PRIMARY KEY (USER_ID)
);
-- 유저 소개글 추가해야됨 


/*카카오 유저 ---------------------------------------- */
CREATE TABLE GGHJ_KAKAO
(
    KAKAO_ID       NUMBER,--PK
    KAKAO_EMAIL    VARCHAR2(255) NOT NULL UNIQUE,
    KAKAO_NICKNAME VARCHAR2(20)  UNIQUE,
    KAKAO_BIRTH    DATE          NOT NULL,
    CONSTRAINT PK_KAKAO_USER PRIMARY KEY (KAKAO_ID)
);

/*통합회원 --------------------------------------------*/
CREATE TABLE GGHJ_UNI(
      UNI_ID NUMBER, 
    UNI_STATUS VARCHAR2(20) DEFAULT '일반' NOT NULL,
    UNI_ABOUT VARCHAR2(255), 
    USER_ID NUMBER, 
    KAKAO_ID NUMBER, 
    CONSTRAINT PK_UNI PRIMARY KEY (UNI_ID),
    CONSTRAINT FK_UNI_USER FOREIGN KEY(USER_ID) REFERENCES GGHJ_USER(USER_ID),
    CONSTRAINT FK_UNI_KAKAO FOREIGN KEY(KAKAO_ID) REFERENCES GGHJ_KAKAO(KAKAO_ID), 
    CONSTRAINT CHECK_UNI_STATUS CHECK (UNI_STATUS IN ('일반', '정지', '탈퇴'))
);

-- 정지회원 댓글, 글 작성 불가 


/*유저 사진 -----------------------------------*/
CREATE TABLE GGHJ_FILE
(
    FILE_ID             NUMBER,--PK
    FILE_PROFILE_NAME   VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    FILE_PROFILE_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    FILE_BACK_NAME      VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    FILE_BACK_SOURCE    VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_ID              NUMBER,--FK
    CONSTRAINT PK_FILE PRIMARY KEY (FILE_ID),
    CONSTRAINT FK_FILE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);

/*팔로우 ----------------------------------------*/
CREATE TABLE GGHJ_FOLLOW
(
    FOLLOW_ID        NUMBER,--PK
    FOLLOW_TO_USER   NUMBER NOT NULL,-- FK
    FOLLOW_FROM_USER NUMBER NOT NULL,-- FK
    FOLLOW_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_FOLLOW PRIMARY KEY (FOLLOW_ID),
    CONSTRAINT FK_FOLLOW_TO FOREIGN KEY (FOLLOW_TO_USER) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT FK_FOLLOW_FROM FOREIGN KEY (FOLLOW_FROM_USER) REFERENCES GGHJ_UNI (UNI_ID)
);


/*일대기(게시판) -----------------------------------*/
CREATE TABLE GGHJ_BOARD
(
    BOARD_ID           NUMBER,--PK
    BOARD_TITLE        VARCHAR2(50)           NOT NULL,
    BOARD_CONTENT       VARCHAR2(2000)         NOT NULL,
    BOARD_PUBLIC       VARCHAR2(20)  DEFAULT 'O'  NOT NULL,--DEFAULT, CHECK
    BOARD_CREATED_DATE DATE   DEFAULT SYSDATE NOT NULL,
    BOARD_UPDATED_DATE DATE   DEFAULT SYSDATE,
    BOARD_VIEW_COUNT   NUMBER DEFAULT 0       NOT NULL, --default
    BOARD_LIFE_CYCLE   VARCHAR2(20) DEFAULT '청소년기' NOT NULL,--DEFAULT 청소년기, CHECK
    BOARD_LIKE_COUNT   NUMBER DEFAULT 0       NOT NULL,
    BOARD_YEAR         NUMBER,
    USER_ID            NUMBER,-- FK
    CONSTRAINT PK_BOARD PRIMARY KEY (BOARD_ID),
    CONSTRAINT FK_BOARD_UNI FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT CHECK_LIFE_CYCLE CHECK (BOARD_LIFE_CYCLE IN('유년기','아동기','청소년기','청년','중년','노년','전성기')),
    CONSTRAINT CHECK_BOARD_PUBLIC CHECK(BOARD_PUBLIC IN('O', 'X'))

);

/*일대기 파일 ------------------------------------------------------------*/
CREATE TABLE GGHJ_BOARD_FILE
(
    BOARD_FILE_ID          NUMBER,--PK
    BOARD_FILE_NAME        VARCHAR2(255) DEFAULT '' NOT NULL,-- DEFAULT : 사진 경로
    BOARD_FILE_SOURCE_NAME VARCHAR2(255) DEFAULT '' NOT NULL,-- DEFAULT : 사진 경로
    BOARD_ID               NUMBER,--FK
    CONSTRAINT PK_BOARD_FILE PRIMARY KEY (BOARD_FILE_ID),
    CONSTRAINT FK_BOARD_ID FOREIGN KEY (BOARD_ID) REFERENCES GGHJ_BOARD (BOARD_ID)
);

/*좋아요 -------------------------------------------------------------------*/
CREATE TABLE GGHJ_LIKE
(
    LIKE_ID  NUMBER,--PK
    BOARD_ID NUMBER,--FK
    USER_ID  NUMBER,--FK
    LIKE_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_LIKE_ID PRIMARY KEY (LIKE_ID),
    CONSTRAINT FK_LIKE_BOARD FOREIGN KEY (BOARD_ID) REFERENCES GGHJ_BOARD (BOARD_ID),
    CONSTRAINT FK_LIKE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI(UNI_ID)
);


/*댓글 ----------------------------------------------------------------------*/
CREATE TABLE GGHJ_COMMENT
(
    COMMENT_ID           NUMBER,--PK
    COMMENT_CONTENT      VARCHAR2(255)        NOT NULL,
    COMMENT_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    BOARD_ID             NUMBER,--FK
    USER_ID              NUMBER,--FK
    CONSTRAINT PK_COMMENT PRIMARY KEY (COMMENT_ID),
    CONSTRAINT FK_COMMENTBOARD FOREIGN KEY (BOARD_ID) REFERENCES GGHJ_BOARD (BOARD_ID),
    CONSTRAINT FK_COMMENTUSER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);

/*대댓글 ------------------------------------------------------------------------*/
CREATE TABLE GGHJ_REPLY
(
    REPLY_ID           NUMBER,--PK
    REPLY_CONTENT      VARCHAR2(255)        NOT NULL,
    REPLY_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    COMMENT_ID         NUMBER,--FK
    CONSTRAINT PK_REPLY PRIMARY KEY (REPLY_ID),
    CONSTRAINT FK_REPLY_COMMENT FOREIGN KEY (COMMENT_ID) REFERENCES GGHJ_COMMENT (COMMENT_ID)
);

/*신고 ----------------------------------------------------------*/
CREATE TABLE GGHJ_REPORT
(
    REPORT_ID           NUMBER,--PK
    REPORT_REASON       VARCHAR2(50)         NOT NULL,
    REPORT_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    REPORT_COUNT       NUMBER DEFAULT 0 NOT NULL,
    USER_ID             NUMBER,-- FK
    REPLY_ID            NUMBER,-- FK
    COMMENT_ID          NUMBER,-- FK
    CONSTRAINT PK_REPORT PRIMARY KEY (REPORT_ID),
    CONSTRAINT FK_REPORT_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID),
    CONSTRAINT FK_REPORT_REPLY FOREIGN KEY (REPLY_ID) REFERENCES GGHJ_REPLY (REPLY_ID),
    CONSTRAINT FK_REPORT_COMMENT FOREIGN KEY (COMMENT_ID) REFERENCES GGHJ_COMMENT (COMMENT_ID)
);
ALTER TABLE GGHJ_REPORT ADD CONSTRAINT UK_REPORT_USER_COMMENT UNIQUE (USER_ID, COMMENT_ID);

/*문의 ------------------------------------------------------*/
CREATE TABLE GGHJ_INQUIRY
(
    INQUIRY_ID            NUMBER,--PK
    INQUIRY_TITLE         VARCHAR2(255)            NOT NULL,
    INQUIRY_CONTENT VARCHAR2(2000) NOT NULL,
    INQUIRY_RESPONSE VARCHAR2(2000),
    INQUIRY_CREATED_DATE DATE           DEFAULT SYSDATE NOT NULL,
    INQUIRY_PUBLIC        VARCHAR2(20)  DEFAULT 'O' NOT NULL,-- DEFAULT
    USER_ID               NUMBER,--FK
    CONSTRAINT PK_INQUIRY PRIMARY KEY (INQUIRY_ID),
    CONSTRAINT FK_INQUIRY_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT CHECK_INQUIRY_PUBLIC CHECK(INQUIRY_PUBLIC IN('O', 'X'))
);

/*공지 ------------------------------------------------------------*/
CREATE TABLE GGHJ_NOTICE
(
    NOTICE_ID            NUMBER,--PK
    NOTICE_TITLE         VARCHAR2(255)            NOT NULL,
    NOTICE_CONTENT VARCHAR2(2000) NOT NULL,
    NOTICE_CREATED_DATE DATE           DEFAULT SYSDATE NOT NULL,
    USER_ID              NUMBER, -- 관리자때문에 있는듯
    CONSTRAINT PK_NOTICE PRIMARY KEY (NOTICE_ID),
    CONSTRAINT FK_NOTICE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);

/*배너 ------------------------------*/
CREATE TABLE GGHJ_MAIN_BANNER
(
    BANNER_ID     NUMBER,--PK
    BANNER_NAME   VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    BANNER_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_ID       NUMBER,--FK
    CONSTRAINT PK_BANNER PRIMARY KEY (BANNER_ID),
    CONSTRAINT FK_BANNER_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);

--CREATE TABLE GGHJ_AUTHORITY (
--   AUTHORITY_ID NUMBER PRIMARY KEY,
--   AUTHORITY_NICKNAME VARCHAR(20) NOT NULL UNIQUE
--);

--CREATE TABLE GGHJ_authorization (
--   AUTHENTIC_ID NUMBER PRIMARY KEY,
--   USER_ID NUMBER,
--   AUTHORITY_ID NUMBER,
--   CONSTRAINT FK_AUTHENTIC_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER(USER_ID),
--   CONSTRAINT FK_AUTHORITY_ID FOREIGN KEY (AUTHORITY_ID) REFERENCES GGHJ_AUTHORITY(AUTHORITY_ID)
--);

--권한있는 사람 테이블 삭제
-- DROP TABLE GGHJ_AUTHORITY CASCADE CONSTRAINTS;

--권한 부여테이블 삭제
-- DROP TABLE GGHJ_authorization CASCADE CONSTRAINTS;

/*CREATE TABLE GGHJ_ALARM(
   ALARM_ID NUMBER, --PK
   USER_ID NUMBER, --FK
   REPORT_ID NUMBER, --FK
);*/
-- 배너 테이블 삭제
DROP TABLE GGHJ_MAIN_BANNER CASCADE CONSTRAINTS;
-- 공지 테이블 삭제
DROP TABLE GGHJ_NOTICE CASCADE CONSTRAINTS;
-- 문의 테이블 삭제
DROP TABLE GGHJ_INQUIRY CASCADE CONSTRAINTS;
-- 신고 테이블 삭제
DROP TABLE GGHJ_REPORT CASCADE CONSTRAINTS;
-- 대댓글 테이블 삭제
DROP TABLE GGHJ_REPLY CASCADE CONSTRAINTS;
-- 댓글 테이블 삭제
DROP TABLE GGHJ_COMMENT CASCADE CONSTRAINTS;
-- 좋아요 테이블 삭제
DROP TABLE GGHJ_LIKE CASCADE CONSTRAINTS;
-- 게시판 파일 테이블 삭제
DROP TABLE GGHJ_BOARD_FILE CASCADE CONSTRAINTS;
-- 게시판 테이블 삭제
DROP TABLE GGHJ_BOARD CASCADE CONSTRAINTS;
-- 팔로우 테이블 삭제
DROP TABLE GGHJ_FOLLOW CASCADE CONSTRAINTS;
-- 유저 사진 테이블 삭제
DROP TABLE GGHJ_FILE CASCADE CONSTRAINTS;
-- 유니(통합) 테이블 삭제
DROP TABLE GGHJ_UNI CASCADE CONSTRAINTS;
-- 유저 테이블 삭제
DROP TABLE GGHJ_USER CASCADE CONSTRAINTS;
-- 카카오 테이블 삭제
DROP TABLE GGHJ_KAKAO CASCADE CONSTRAINTS;

CREATE SEQUENCE SEQ_AUTHENTIC;

CREATE SEQUENCE SEQ_AUTHORITY;

CREATE SEQUENCE SEQ_USER;

CREATE SEQUENCE SEQ_KAKAO;

CREATE SEQUENCE SEQ_UNI;

CREATE SEQUENCE SEQ_FILE;

CREATE SEQUENCE SEQ_FOLLOW;

CREATE SEQUENCE SEQ_BOARD;

CREATE SEQUENCE SEQ_BOARD_FILE;

CREATE SEQUENCE SEQ_COMMENT;

CREATE SEQUENCE SEQ_REPLY;

CREATE SEQUENCE SEQ_REPORT;

CREATE SEQUENCE SEQ_NOTICE;

CREATE SEQUENCE SEQ_INQUIRY;

CREATE SEQUENCE SEQ_LIKE;
