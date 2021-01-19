package com.mymap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mymap.dao.MyMapDao;
import com.mymap.vo.sigunguvo;

@Service
public class MyMapService {

	@Autowired MyMapDao mmd;
	
	public List<sigunguvo> getMap() {
		return mmd.getMap();
	}

}
