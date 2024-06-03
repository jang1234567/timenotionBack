import * as reply from "./module.js";
let page = 1;
let hasNext = true;
/* boardId
 <input type="hidden" id="boardId" th:value="${boards.boardId}"> 이런식으로 아무데나 갖다놔야함 */
let boardId = document.querySelector('#boardId').value;

// ♡♡ 댓글 목록 감싸는 div
let $replyListWrap = document.querySelector('.wrapper-reply');
/* 1. 댓글 목록 클릭, 댓글 상태 바꾸기 -----------------
*  추후 작성 -- -- --     */

/* 2. 댓글 등록 ----------------------------------------*/
{
    //  댓글 작성 완료 버튼 //
    let $btnWriteReply = document.querySelector('.box-btn-reply-btn');
    /* 2-1. */
    $btnWriteReply?.addEventListener('click', function (){
        /* 1 ) 입력할 댓글 내용 가져옴 */
        // 입력한 댓글 내용(컨텐츠) //
        let content = document.querySelector('#comment-content').value;
        if(!content){alert("댓글 입력"); return;}
        // ♡♡  댓글 아이디, 컨텐츠 정보 담는 변수 선언
        /* 여기 이름이 내 DTO의 필드명이랑 일치해야함 */
        let replyInfo = { boardId: boardId, commentContent: content }; // content 변수를 사용하여 수정

        /* 2 ) 댓글 등록 함수 호출
            댓 입력창 초기화 / 페이지 초기화 / 댓 리스트 뿌려줌
            function getList2(boardId, page, callback)호출 -> boardId, page 넣어줌
            - 특정 게시물의 댓글목록을 page 단위로 가져옴
            - 서버에 Get 요청 -> JSON형식으로 파싱
            - 파싱된 데이터를 콜백함수에 전달  */
        reply.register(replyInfo, () => {
            document.querySelector('#comment-content').value = '';
            page = 1;
            reply.getList2(boardId, page, function (data){
                hasNext = data.hasNext;
                displayComment(data.contentList);
            });
        });
    });

    /*2-2. 댓글 목록을 페이지 단위로 가져와서 화면에 출력
            서버에 get 요청을 보내고, 응답 페이지를 콜백 함수로 처리하여 댓글 표시 */
    reply.getList2(boardId, page, function (data){
        hasNext = data.hasNext;
        console.log("뿅!★");
        console.log(data.contentList);
        displayComment(data.contentList);
    });

    /*2-3. 스크롤 이벤트를 감지하여 페이지 끝에 도달하면 다음 페이지 댓글 가져옴
    *       새로운 댓글 목록을 기존 목록에 추가 */
    window.addEventListener('scroll', function (){
        if(!hasNext)return;
        // ♡♡  documentElement 객체에서 3개의 프로퍼티를 동시에 가져온다.
        let {scrollTop, scrollHeight, clientHeight} = document.documentElement;/*
        console.log("scrollTop(스크롤 상단의 현재 위치) : ", scrollTop);
        console.log("scrollHeight(전체 문서의 높이) : ", scrollHeight);
        console.log("clientHeight(클라이언트[웹브라우저]의 화면 높이) : ", clientHeight);*/
        if(clientHeight + scrollTop >= scrollHeight - 5){
            console.log("바닥~~!!");
            page++;
            /* 여기 찾아봐야함 ☆☆☆☆☆☆ */
            reply.getList2(boardId, page, function (data){
                hasNext = data.hasNext;
                appendReply(data.contentList);
            });
        }
    });

} // 2.close

/* 3. 기존 댓글 지우고 새로운 댓글 목록 씌우는 함수
   innserHTML : 기존 내용 유지 x, 새롭게 덮어 씌임 */
function displayComment(commentList){
    let $commentWrap = document.querySelector('.wrapper-reply');
    let tags = '';
    commentList.forEach(r => {
        tags +=  `
    <div class="wrapper-main-reply">
                            
                            <div class="box-main-reply-top">
                                <a href="#" class="reply-top-left">
                                    <div class="box-profile"><img src="./../../img/main/봉준호 (8).jpg" alt=""></div>
                                    <div><span class="nickname">송아성</span></div>
                                    <div class="tag">일기주인</div> 
                                </a>
                                <div class="reply-top-right">
                                    <div class="delete-btn"><button onclick="del();">삭제</button></div>
                                    <div class="date">2024.11.19</div>
                                    <div class="dotdotdot">...</div>
                                    <div class="box-mini-report">
                                        <button class="mini-button">신고하기</button>
                                    </div>
                                </div>
                            </div>
                            <div class="box-main-reply-bottom">
                                <div class="reply-content">
                                    <p>${r.commentContent}</p>
                                </div>
                            </div>
                            
                            <div class="wrapper-re-comment">
                         
                                <div class="box-re-comment">
                                 
                                    <button class="reply-btn" onclick="toggleReplyInput(this)">답글쓰기</button>
                                 
                                    <div class="box-re-comment-btn" style="display: none;">
                                        <textarea class="re-textarea" placeholder="댓글을 남겨보세요"></textarea>
                                        <button class="re-submit-btn" onclick="submitReply(this)">완료</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr>
        `;
    }); // 댓글목록 순회
    $commentWrap.innerHTML = tags;
} // 3.close

/* 4. 기존 댓글목록 유지하고 새로운 댓글 추가하는 함수
   insertAdjacentHTML : 새로운 html 내용을 기존 내용 뒤에 삽입 */
function appendReply(commentList){
    let $commentWrap = document.querySelector('.wrapper-reply');
    let tags = '';

    commentList.forEach(r => {
        tags += `
        <div class="wrapper-main-reply">
                            <!-- 프로필사진 이름 태그 -- 삭제 날짜 ... -->
                            <div class="box-main-reply-top">
                                <a href="#" class="reply-top-left">
                                    <div class="box-profile"><img src="./../../img/main/봉준호 (8).jpg" alt=""></div>
                                    <div><span class="nickname">송아성</span></div>
                                    <div class="tag">일기주인</div> <-- th:if로 만약 게시글 작성자 id랑 댓 작성자 아이디랑 같으면 none해야함 
                                </a>
                                <div class="reply-top-right">
                                    <div class="delete-btn"><button onclick="del();">삭제</button></div>
                                    <div class="date">2024.11.19</div>
                                    <div class="dotdotdot">...</div>
                                    <div class="box-mini-report">
                                        <button class="mini-button">신고하기</button>
                                    </div>
                                </div>
                            </div>
                            <div class="box-main-reply-bottom">
                                <div class="reply-content">
                                    <p>댓글 내용</p>
                                </div>
                            </div>
                            <!-- [대댓글 입력 '답글쓰기' 버튼 ] ---------------> 
                            <div class="wrapper-re-comment"> <-- th:if로 만약 게시글 작성자 id랑 댓 작성자 아이디랑 같으면 none해야함 
                                <!-- 기존 댓글 내용 -->
                                <div class="box-re-comment">
                                    <!-- 대댓글 버튼 -->
                                    <button class="reply-btn" onclick="toggleReplyInput(this)">답글쓰기</button>
                                    <!-- 대댓글 입력 필드 (초기에는 숨겨짐) -->
                                    <div class="box-re-comment-btn" style="display: none;">
                                        <textarea class="re-textarea" placeholder="댓글을 남겨보세요"></textarea>
                                        <button class="re-submit-btn" onclick="submitReply(this)">완료</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr>
        `;
    }); // 댓글 목록 순회
    $commentWrap.insertAdjacentHTML("beforeend", tags);
} // 4.close


























