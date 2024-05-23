package com.example.geungeunhanjan.service;

import com.example.geungeunhanjan.domain.vo.BoardVO;
import com.example.geungeunhanjan.mapper.BoardMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BoardServiceImple implements BoardService {

    private final BoardMapper boardMapper;

    public BoardServiceImple(BoardMapper boardMapper) {
        this.boardMapper = boardMapper;
    }


    @Override
    public List<BoardVO> selectBoard(Long userId) {
        return boardMapper.selectBoard(userId);
    }
}
