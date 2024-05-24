/*유저 ---------------------------------------- */
CREATE TABLE GGHJ_USER
(
    USER_ID       NUMBER,--PK
    USER_NAME     VARCHAR2(20)  NOT NULL,
    USER_PASSWORD VARCHAR2(255) NOT NULL,
    USER_EMAIL    VARCHAR2(255) NOT NULL UNIQUE,
    USER_NICKNAME VARCHAR2(20)  NOT NULL UNIQUE,
    USER_BIRTH    DATE          NOT NULL,
    USER_STATUS   VARCHAR2(10) DEFAULT '일반',
    user_isadmin  char(1)      default '0',
    CONSTRAINT PK_USER PRIMARY KEY (USER_ID)
);

SELECT  * FROM  GGHJ_USER;


/*카카오 유저 ---------------------------------------- */
CREATE TABLE GGHJ_KAKAO_USER
(
    KAKAO_USER_ID       NUMBER,--PK
    KAKAO_USER_EMAIL    VARCHAR2(255) NOT NULL UNIQUE,
    KAKAO_USER_NICKNAME VARCHAR2(20)  NOT NULL UNIQUE,
    KAKAO_USER_BIRTH    DATE          NOT NULL,
    USER_ID             NUMBER,
    CONSTRAINT PK_KAKAO_USER PRIMARY KEY (KAKAO_USER_ID),
    CONSTRAINT FK_KAKAO_USER_ID FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
);

/*유저 사진 -----------------------------------*/
CREATE TABLE GGHJ_FILE
(
    FILE_ID             NUMBER,--PK
    FILE_PROFILE_NAME   VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    FILE_PROFILE_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    FILE_BACK_NAME      VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    FILE_BACK_SOURCE    VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_ID             NUMBER,--FK
    CONSTRAINT PK_FILE PRIMARY KEY (FILE_ID),
    CONSTRAINT FK_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
);

/*팔로우 ----------------------------------------*/
CREATE TABLE GGHJ_FOLLOW
(
    FOLLOW_ID        NUMBER,--PK
    FOLLOW_TO_USER   NUMBER NOT NULL,-- FK
    FOLLOW_FROM_USER NUMBER NOT NULL,-- FK
    CONSTRAINT PK_FOLLOW PRIMARY KEY (FOLLOW_ID),
    CONSTRAINT FK_FOLLOW_TO FOREIGN KEY (FOLLOW_TO_USER) REFERENCES GGHJ_USER (USER_ID),
    CONSTRAINT FK_FOLLOW_FROM FOREIGN KEY (FOLLOW_FROM_USER) REFERENCES GGHJ_USER (USER_ID)
);

/*일대기(게시판) -----------------------------------*/
CREATE TABLE GGHJ_BOARD
(
    BOARD_ID           NUMBER,--PK
    BOARD_TITLE        VARCHAR2(50)           NOT NULL,
    BOARD_CONTENT VARCHAR2(2000) NOT NULL,
    BOARD_PUBLIC       NUMBER(1)              NOT NULL,--default
    BOARD_CREATED_DATE DATE   DEFAULT SYSDATE NOT NULL,
    BOARD_UPDATED_DATE DATE   DEFAULT SYSDATE,
    BOARD_VIEW_COUNT   NUMBER DEFAULT 0       NOT NULL,--default
    BOARD_LIFE_CYCLE   VARCHAR2(20)            NOT NULL,-- ??
    BOARD_LIKE_COUNT   NUMBER DEFAULT 0       NOT NULL,
    USER_ID            NUMBER,-- FK
    CONSTRAINT PK_BOARD PRIMARY KEY (BOARD_ID),
    CONSTRAINT FK_BOARD_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
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
    CONSTRAINT PK_LIKE_ID PRIMARY KEY (LIKE_ID),
    CONSTRAINT FK_LIKE_BOARD FOREIGN KEY (BOARD_ID) REFERENCES GGHJ_BOARD (BOARD_ID),
    CONSTRAINT FK_LIKE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
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
    CONSTRAINT FK_COMMENTUSER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
);

/*대댓글 ------------------------------------------------------------------------*/
CREATE TABLE GGHJ_REPLY
(
    REPLY_ID           NUMBER,--PK
    REPLY_CONTENT      VARCHAR2(255)        NOT NULL,
    REPLY_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    USER_ID            NUMBER,--FK
    COMMENT_ID         NUMBER,--FK
    CONSTRAINT PK_REPLY PRIMARY KEY (REPLY_ID),
    CONSTRAINT FK_REPLY FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID),
    CONSTRAINT FK_REPLY_COMMENT FOREIGN KEY (COMMENT_ID) REFERENCES GGHJ_COMMENT (COMMENT_ID)
);

/*신고 ----------------------------------------------------------*/
CREATE TABLE GGHJ_REPORT
(
    REPORT_ID           NUMBER,--PK
    REPORT_REASON       VARCHAR2(50)         NOT NULL,
    REPORT_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    USER_ID             NUMBER,-- FK
    REPLY_ID            NUMBER,-- FK
    COMMENT_ID          NUMBER,-- FK
    CONSTRAINT PK_REPORT PRIMARY KEY (REPORT_ID),
    CONSTRAINT FK_REPORT_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID),
    CONSTRAINT FK_REPORT_REPLY FOREIGN KEY (REPLY_ID) REFERENCES GGHJ_REPLY (REPLY_ID),
    CONSTRAINT FK_REPORT_COMMENT FOREIGN KEY (COMMENT_ID) REFERENCES GGHJ_COMMENT (COMMENT_ID)
);

/*문의 ------------------------------------------------------*/
CREATE TABLE GGHJ_INQUIRY
(
    INQUIRY_ID            NUMBER,--PK
    INQUIRY_TITLE         VARCHAR2(255)            NOT NULL,
    INQUIRY_CONTENT VARCHAR2(2000) NOT NULL,
    INQUIRY_RESPONSE VARCHAR2(2000),
    INQUIRY_CREATED_DATE DATE           DEFAULT SYSDATE NOT NULL,
    INQUIRY_PUBLIC        NUMBER(1)                NOT NULL,-- DEFAULT
    INQUIRY_BANNER_NAME   VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    INQUIRY_BANNER_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_ID               NUMBER,--FK
    CONSTRAINT PK_INQUIRY PRIMARY KEY (INQUIRY_ID),
    CONSTRAINT FK_INQUIRY_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
);

/*공지 ------------------------------------------------------------*/
CREATE TABLE GGHJ_NOTICE
(
    NOTICE_ID            NUMBER,--PK
    NOTICE_TITLE         VARCHAR2(255)            NOT NULL,
    NOTICE_CONTENT VARCHAR2(2000) NOT NULL,
    NOTICE_CREATED_DATE DATE           DEFAULT SYSDATE NOT NULL,
    NOTICE_BANNER_NAME VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    NOTICE_BANNER_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_ID              NUMBER,
    CONSTRAINT PK_NOTICE PRIMARY KEY (NOTICE_ID),
    CONSTRAINT FK_NOTICE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
);

/*배너 ------------------------------*/
CREATE TABLE GGHJ_MAIN_BANNER
(
    BANNER_ID     NUMBER,--PK
    BANNER_NAME   VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    BANNER_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_ID       NUMBER,--FK
    CONSTRAINT PK_FILE PRIMARY KEY (BANNER_ID),
    CONSTRAINT FK_BANNER_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID)
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
-- 유저 테이블 삭제
DROP TABLE GGHJ_USER CASCADE CONSTRAINTS;
-- 카카오 테이블 삭제
DROP TABLE GGHJ_KAKAO_USER CASCADE CONSTRAINTS;

CREATE SEQUENCE SEQ_AUTHENTIC;

CREATE SEQUENCE SEQ_AUTHORITY;

CREATE SEQUENCE SEQ_USER;

CREATE SEQUENCE SEQ_KAKAO;

CREATE SEQUENCE SEQ_FILE;

CREATE SEQUENCE SEQ_FOLLOW;

CREATE SEQUENCE SEQ_BOARD;

CREATE SEQUENCE SEQ_BOARD_FILE;

CREATE SEQUENCE SEQ_COMMENT;

CREATE SEQUENCE SEQ_REPLY;

CREATE SEQUENCE SEQ_REPORT;

CREATE SEQUENCE SEQ_NOTICE;

CREATE SEQUENCE SEQ_INQUERY;

CREATE SEQUENCE SEQ_LIKE;

-- GGHJ_USER 테이블 더미 데이터 삽입

INSERT INTO GGHJ_USER (USER_ID, USER_NAME, USER_PASSWORD, USER_EMAIL, USER_NICKNAME, USER_BIRTH, USER_STATUS, user_isadmin)
VALUES (1, 'user1', 'password1', 'user1@example.com', 'user1', TO_DATE('1990-01-01', 'YYYY-MM-DD'), '일반', '0');

INSERT INTO GGHJ_USER (USER_ID, USER_NAME, USER_PASSWORD, USER_EMAIL, USER_NICKNAME, USER_BIRTH, USER_STATUS, user_isadmin)
VALUES (2, 'user2', 'password2', 'user2@example.com', 'user2', TO_DATE('1991-02-02', 'YYYY-MM-DD'), '일반', '0');

INSERT INTO GGHJ_USER (USER_ID, USER_NAME, USER_PASSWORD, USER_EMAIL, USER_NICKNAME, USER_BIRTH, USER_STATUS, user_isadmin)
VALUES (3, 'user3', 'password3', 'user3@example.com', 'user3', TO_DATE('1992-03-03', 'YYYY-MM-DD'), '일반', '0');

INSERT INTO GGHJ_USER (USER_ID, USER_NAME, USER_PASSWORD, USER_EMAIL, USER_NICKNAME, USER_BIRTH, USER_STATUS, user_isadmin)
VALUES (4, 'user4', 'password4', 'user4@example.com', 'user4', TO_DATE('1993-04-04', 'YYYY-MM-DD'), '일반', '0');

INSERT INTO GGHJ_USER (USER_ID, USER_NAME, USER_PASSWORD, USER_EMAIL, USER_NICKNAME, USER_BIRTH, USER_STATUS, user_isadmin)
VALUES (5, 'user5', 'password4', 'user5@example.com', 'user5', TO_DATE('1993-04-04', 'YYYY-MM-DD'), '일반', '0');

INSERT INTO GGHJ_USER (USER_ID, USER_NAME, USER_PASSWORD, USER_EMAIL, USER_NICKNAME, USER_BIRTH, USER_STATUS, user_isadmin)
VALUES (6, 'user6', 'password4', 'user6@example.com', 'user6', TO_DATE('1993-04-04', 'YYYY-MM-DD'), '일반', '0');


-- GGHJ_KAKAO_USER 테이블 더미 데이터 삽입
INSERT INTO GGHJ_KAKAO_USER (KAKAO_USER_ID, KAKAO_USER_EMAIL, KAKAO_USER_NICKNAME, KAKAO_USER_BIRTH, USER_ID)
VALUES (1, 'kakao_user1@example.com', 'kakao_user1', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 1);

INSERT INTO GGHJ_KAKAO_USER (KAKAO_USER_ID, KAKAO_USER_EMAIL, KAKAO_USER_NICKNAME, KAKAO_USER_BIRTH, USER_ID)
VALUES (2, 'kakao_user2@example.com', 'kakao_user2', TO_DATE('1991-02-02', 'YYYY-MM-DD'), 2);

INSERT INTO GGHJ_KAKAO_USER (KAKAO_USER_ID, KAKAO_USER_EMAIL, KAKAO_USER_NICKNAME, KAKAO_USER_BIRTH, USER_ID)
VALUES (3, 'kakao_user3@example.com', 'kakao_user3', TO_DATE('1992-03-03', 'YYYY-MM-DD'), 3);

INSERT INTO GGHJ_KAKAO_USER (KAKAO_USER_ID, KAKAO_USER_EMAIL, KAKAO_USER_NICKNAME, KAKAO_USER_BIRTH, USER_ID)
VALUES (4, 'kakao_user4@example.com', 'kakao_user4', TO_DATE('1993-04-04', 'YYYY-MM-DD'), 4);

-- GGHJ_FILE 테이블 더미 데이터 삽입
INSERT INTO GGHJ_FILE (FILE_ID, FILE_PROFILE_NAME, FILE_PROFILE_SOURCE, FILE_BACK_NAME, FILE_BACK_SOURCE, USER_ID)
VALUES (1, '프로필 사진 1', '/images/profile1.jpg', '배경 사진 1', '/images/back1.jpg', 1);

INSERT INTO GGHJ_FILE (FILE_ID, FILE_PROFILE_NAME, FILE_PROFILE_SOURCE, FILE_BACK_NAME, FILE_BACK_SOURCE, USER_ID)
VALUES (2, '프로필 사진 2', '/images/profile2.jpg', '배경 사진 2', '/images/back2.jpg', 2);

INSERT INTO GGHJ_FILE (FILE_ID, FILE_PROFILE_NAME, FILE_PROFILE_SOURCE, FILE_BACK_NAME, FILE_BACK_SOURCE, USER_ID)
VALUES (3, '프로필 사진 3', '/images/profile3.jpg', '배경 사진 3', '/images/back3.jpg', 3);

INSERT INTO GGHJ_FILE (FILE_ID, FILE_PROFILE_NAME, FILE_PROFILE_SOURCE, FILE_BACK_NAME, FILE_BACK_SOURCE, USER_ID)
VALUES (4, '프로필 사진 4', '/images/profile4.jpg', '배경 사진 4', '/images/back4.jpg', 4);


-- GGHJ_FOLLOW 테이블 더미 데이터 삽입
INSERT INTO GGHJ_FOLLOW (FOLLOW_ID, FOLLOW_TO_USER, FOLLOW_FROM_USER)
VALUES (1, 2, 1);

INSERT INTO GGHJ_FOLLOW (FOLLOW_ID, FOLLOW_TO_USER, FOLLOW_FROM_USER)
VALUES (2, 3, 1);

INSERT INTO GGHJ_FOLLOW (FOLLOW_ID, FOLLOW_TO_USER, FOLLOW_FROM_USER)
VALUES (3, 4, 2);

INSERT INTO GGHJ_FOLLOW (FOLLOW_ID, FOLLOW_TO_USER, FOLLOW_FROM_USER)
VALUES (4, 1, 3);

-- GGHJ_BOARD 테이블 더미 데이터 삽입
INSERT INTO GGHJ_BOARD (BOARD_ID, BOARD_TITLE, BOARD_CONTENT, BOARD_PUBLIC, BOARD_CREATED_DATE, BOARD_UPDATED_DATE, BOARD_VIEW_COUNT, BOARD_LIFE_CYCLE, BOARD_LIKE_COUNT, USER_ID)
VALUES (1, '첫 번째 게시물', '이 게시물은 첫 번째 게시물입니다.', 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'), 100, '일반', 10, 1);

INSERT INTO GGHJ_BOARD (BOARD_ID, BOARD_TITLE, BOARD_CONTENT, BOARD_PUBLIC, BOARD_CREATED_DATE, BOARD_UPDATED_DATE, BOARD_VIEW_COUNT, BOARD_LIFE_CYCLE, BOARD_LIKE_COUNT, USER_ID)
VALUES (2, '두 번째 게시물', '이 게시물은 두 번째 게시물입니다.', 1, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-06-02', 'YYYY-MM-DD'), 120, '일반', 8, 2);

INSERT INTO GGHJ_BOARD (BOARD_ID, BOARD_TITLE, BOARD_CONTENT, BOARD_PUBLIC, BOARD_CREATED_DATE, BOARD_UPDATED_DATE, BOARD_VIEW_COUNT, BOARD_LIFE_CYCLE, BOARD_LIKE_COUNT, USER_ID)
VALUES (3, '세 번째 게시물', '이 게시물은 세 번째 게시물입니다.', 1, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-06-03', 'YYYY-MM-DD'), 80, '일반', 15, 3);

INSERT INTO GGHJ_BOARD (BOARD_ID, BOARD_TITLE, BOARD_CONTENT, BOARD_PUBLIC, BOARD_CREATED_DATE, BOARD_UPDATED_DATE, BOARD_VIEW_COUNT, BOARD_LIFE_CYCLE, BOARD_LIKE_COUNT, USER_ID)
VALUES (4, '네 번째 게시물', '이 게시물은 네 번째 게시물입니다.', 1, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-06-04', 'YYYY-MM-DD'), 90, '일반', 12, 4);



-- GGHJ_BOARD_FILE 테이블에 더미 데이터 삽입
INSERT INTO GGHJ_BOARD_FILE (BOARD_FILE_ID, BOARD_FILE_NAME, BOARD_FILE_SOURCE_NAME, BOARD_ID)
VALUES (1, '이미지1.jpg', '소스1.jpg', 1);

INSERT INTO GGHJ_BOARD_FILE (BOARD_FILE_ID, BOARD_FILE_NAME, BOARD_FILE_SOURCE_NAME, BOARD_ID)
VALUES (2, '이미지2.jpg', '소스2.jpg', 2);

INSERT INTO GGHJ_BOARD_FILE (BOARD_FILE_ID, BOARD_FILE_NAME, BOARD_FILE_SOURCE_NAME, BOARD_ID)
VALUES (3, '이미지3.jpg', '소스3.jpg', 3);

INSERT INTO GGHJ_BOARD_FILE (BOARD_FILE_ID, BOARD_FILE_NAME, BOARD_FILE_SOURCE_NAME, BOARD_ID)
VALUES (4, '이미지4.jpg', '소스4.jpg', 1);

INSERT INTO GGHJ_BOARD_FILE (BOARD_FILE_ID, BOARD_FILE_NAME, BOARD_FILE_SOURCE_NAME, BOARD_ID)
VALUES (5, '이미지5.jpg', '소스5.jpg', 2);

INSERT INTO GGHJ_BOARD_FILE (BOARD_FILE_ID, BOARD_FILE_NAME, BOARD_FILE_SOURCE_NAME, BOARD_ID)
VALUES (6, '이미지6.jpg', '소스6.jpg', 3);


-- Like 더미 데이터 삽입
INSERT INTO GGHJ_LIKE (LIKE_ID, BOARD_ID, USER_ID)
VALUES
(1, 101, 201),
(2, 102, 202),
(3, 103, 203),
(4, 104, 204),
(5, 105, 205);

-- Comment 더미 데이터 삽입
INSERT INTO GGHJ_COMMENT (COMMENT_ID, COMMENT_CONTENT, COMMENT_CREATED_DATE, BOARD_ID, USER_ID)
VALUES
(1, 'Great post!', SYSDATE, 101, 201),
(2, 'Interesting topic.', SYSDATE, 101, 202),
(3, 'I agree with you.', SYSDATE, 102, 203),
(4, 'Well written.', SYSDATE, 103, 204),
(5, 'Thanks for sharing!', SYSDATE, 104, 205);

-- GGHJ_COMMENT 테이블 더미 데이터 삽입
INSERT INTO GGHJ_COMMENT (COMMENT_ID, COMMENT_CONTENT, COMMENT_CREATED_DATE, BOARD_ID, USER_ID)
VALUES (1, '이 게시물 정말 유익하네요.', TO_DATE('2024-05-23', 'YYYY-MM-DD'), 1, 1);

INSERT INTO GGHJ_COMMENT (COMMENT_ID, COMMENT_CONTENT, COMMENT_CREATED_DATE, BOARD_ID, USER_ID)
VALUES (2, '고맙습니다!', TO_DATE('2024-05-23', 'YYYY-MM-DD'), 1, 2);

INSERT INTO GGHJ_COMMENT (COMMENT_ID, COMMENT_CONTENT, COMMENT_CREATED_DATE, BOARD_ID, USER_ID)
VALUES (3, '추가 질문이 있습니다.', TO_DATE('2024-05-24', 'YYYY-MM-DD'), 1, 3);

INSERT INTO GGHJ_COMMENT (COMMENT_ID, COMMENT_CONTENT, COMMENT_CREATED_DATE, BOARD_ID, USER_ID)
VALUES (4, '답변 부탁드립니다.', TO_DATE('2024-05-25', 'YYYY-MM-DD'), 2, 4);


-- GGHJ_REPLY 테이블 더미 데이터 삽입
INSERT INTO GGHJ_REPLY (REPLY_ID, REPLY_CONTENT, REPLY_CREATED_DATE, USER_ID, COMMENT_ID)
VALUES (1, '감사합니다!', TO_DATE('2024-05-25', 'YYYY-MM-DD'), 1, 1);

INSERT INTO GGHJ_REPLY (REPLY_ID, REPLY_CONTENT, REPLY_CREATED_DATE, USER_ID, COMMENT_ID)
VALUES (2, '도와드릴 수 있어요.', TO_DATE('2024-05-26', 'YYYY-MM-DD'), 2, 1);

INSERT INTO GGHJ_REPLY (REPLY_ID, REPLY_CONTENT, REPLY_CREATED_DATE, USER_ID, COMMENT_ID)
VALUES (3, '빠른 답변 감사합니다!', TO_DATE('2024-05-27', 'YYYY-MM-DD'), 3, 2);

INSERT INTO GGHJ_REPLY (REPLY_ID, REPLY_CONTENT, REPLY_CREATED_DATE, USER_ID, COMMENT_ID)
VALUES (4, '추가 질문이 있으신가요?', TO_DATE('2024-05-28', 'YYYY-MM-DD'), 4, 3);


-- GGHJ_REPORT 테이블 더미 데이터 삽입
INSERT INTO GGHJ_REPORT (REPORT_ID, REPORT_REASON, REPORT_CREATED_DATE, USER_ID, REPLY_ID, COMMENT_ID)
VALUES (1, '부적절한 언어 사용', TO_DATE('2024-05-26', 'YYYY-MM-DD'), 1, NULL, 2);

INSERT INTO GGHJ_REPORT (REPORT_ID, REPORT_REASON, REPORT_CREATED_DATE, USER_ID, REPLY_ID, COMMENT_ID)
VALUES (2, '광고성 댓글', TO_DATE('2024-05-27', 'YYYY-MM-DD'), 2, NULL, 3);

INSERT INTO GGHJ_REPORT (REPORT_ID, REPORT_REASON, REPORT_CREATED_DATE, USER_ID, REPLY_ID, COMMENT_ID)
VALUES (3, '스팸', TO_DATE('2024-05-28', 'YYYY-MM-DD'), 3, 1, NULL);

INSERT INTO GGHJ_REPORT (REPORT_ID, REPORT_REASON, REPORT_CREATED_DATE, USER_ID, REPLY_ID, COMMENT_ID)
VALUES (4, '욕설', TO_DATE('2024-05-29', 'YYYY-MM-DD'), 4, NULL, 4);


-- GGHJ_INQUIRY 테이블 더미 데이터 삽입
INSERT INTO GGHJ_INQUIRY (INQUIRY_ID, INQUIRY_TITLE, INQUIRY_CONTENT, INQUIRY_RESPONSE, INQUIRY_CREATED_DATE, INQUIRY_PUBLIC, INQUIRY_BANNER_NAME, INQUIRY_BANNER_SOURCE, USER_ID)
VALUES (1, '서비스 이용 관련 문의', '서비스 이용 중 궁금한 사항이 있어 문의드립니다.', NULL, TO_DATE('2024-05-30', 'YYYY-MM-DD'), 1, '배너1', '/images/banner1.jpg', 1);

INSERT INTO GGHJ_INQUIRY (INQUIRY_ID, INQUIRY_TITLE, INQUIRY_CONTENT, INQUIRY_RESPONSE, INQUIRY_CREATED_DATE, INQUIRY_PUBLIC, INQUIRY_BANNER_NAME, INQUIRY_BANNER_SOURCE, USER_ID)
VALUES (2, '결제 오류 문의', '결제 시 오류가 발생하여 문의드립니다.', '결제 오류에 대한 조치가 완료되었습니다.', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 1, '배너2', '/images/banner2.jpg', 2);

INSERT INTO GGHJ_INQUIRY (INQUIRY_ID, INQUIRY_TITLE, INQUIRY_CONTENT, INQUIRY_RESPONSE, INQUIRY_CREATED_DATE, INQUIRY_PUBLIC, INQUIRY_BANNER_NAME, INQUIRY_BANNER_SOURCE, USER_ID)
VALUES (3, '회원정보 변경 문의', '회원정보를 변경하려는데 어떻게 해야 하나요?', '회원정보 변경에 대한 안내가 이메일로 발송되었습니다.', TO_DATE('2024-06-03', 'YYYY-MM-DD'), 1, '배너3', '/images/banner3.jpg', 3);

INSERT INTO GGHJ_INQUIRY (INQUIRY_ID, INQUIRY_TITLE, INQUIRY_CONTENT, INQUIRY_RESPONSE, INQUIRY_CREATED_DATE, INQUIRY_PUBLIC, INQUIRY_BANNER_NAME, INQUIRY_BANNER_SOURCE, USER_ID)
VALUES (4, '기능 추가 건의', '서비스에 편리한 기능이 있으면 좋겠습니다.', NULL, TO_DATE('2024-06-05', 'YYYY-MM-DD'), 1, '배너4', '/images/banner4.jpg', 4);


-- GGHJ_NOTICE 테이블 더미 데이터 삽입
INSERT INTO GGHJ_NOTICE (NOTICE_ID, NOTICE_TITLE, NOTICE_CONTENT, NOTICE_CREATED_DATE, NOTICE_BANNER_NAME, NOTICE_BANNER_SOURCE, USER_ID)
VALUES (1, '서비스 업데이트 공지', '서비스가 업데이트되었습니다. 새로운 기능과 개선사항을 확인하세요.', TO_DATE('2024-06-10', 'YYYY-MM-DD'), '배너1', '/images/banner1.jpg', 1);

INSERT INTO GGHJ_NOTICE (NOTICE_ID, NOTICE_TITLE, NOTICE_CONTENT, NOTICE_CREATED_DATE, NOTICE_BANNER_NAME, NOTICE_BANNER_SOURCE, USER_ID)
VALUES (2, '이용약관 변경 안내', '이용약관이 변경되었습니다. 변경된 내용을 확인해주세요.', TO_DATE('2024-06-12', 'YYYY-MM-DD'), '배너2', '/images/banner2.jpg', 2);

INSERT INTO GGHJ_NOTICE (NOTICE_ID, NOTICE_TITLE, NOTICE_CONTENT, NOTICE_CREATED_DATE, NOTICE_BANNER_NAME, NOTICE_BANNER_SOURCE, USER_ID)
VALUES (3, '이벤트 안내', '서비스 이용고객 대상으로 이벤트를 진행합니다. 자세한 내용은 이벤트 페이지에서 확인하세요.', TO_DATE('2024-06-15', 'YYYY-MM-DD'), '배너3', '/images/banner3.jpg', 3);

INSERT INTO GGHJ_NOTICE (NOTICE_ID, NOTICE_TITLE, NOTICE_CONTENT, NOTICE_CREATED_DATE, NOTICE_BANNER_NAME, NOTICE_BANNER_SOURCE, USER_ID)
VALUES (4, '긴급 공지', '긴급한 사항이 있어서 공지드립니다. 서비스 이용에 참고하시기 바랍니다.', TO_DATE('2024-06-18', 'YYYY-MM-DD'), '배너4', '/images/banner4.jpg', 4);



-- GGHJ_MAIN_BANNER 테이블 더미 데이터 삽입
INSERT INTO GGHJ_MAIN_BANNER (BANNER_ID, BANNER_NAME, BANNER_SOURCE, USER_ID)
VALUES (1, '메인 배너 1', '/images/main_banner1.jpg', 1);

INSERT INTO GGHJ_MAIN_BANNER (BANNER_ID, BANNER_NAME, BANNER_SOURCE, USER_ID)
VALUES (2, '메인 배너 2', '/images/main_banner2.jpg', 2);

INSERT INTO GGHJ_MAIN_BANNER (BANNER_ID, BANNER_NAME, BANNER_SOURCE, USER_ID)
VALUES (3, '메인 배너 3', '/images/main_banner3.jpg', 3);

INSERT INTO GGHJ_MAIN_BANNER (BANNER_ID, BANNER_NAME, BANNER_SOURCE, USER_ID)
VALUES (4, '메인 배너 4', '/images/main_banner4.jpg', 4);

SELECT *
FROM GGHJ_BOARD 
WHERE USER_ID = 1;

